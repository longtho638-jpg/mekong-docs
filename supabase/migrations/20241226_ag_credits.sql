-- =============================================
-- AG CREDITS SYSTEM (TÍCH SẢN)
-- Internal credit for affiliate commissions
-- 1 AGC = $1 USD
-- =============================================

-- Credit balances per user
CREATE TABLE IF NOT EXISTS ag_credits (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    balance DECIMAL(12,2) DEFAULT 0 CHECK (balance >= 0),
    lifetime_earned DECIMAL(12,2) DEFAULT 0,
    lifetime_spent DECIMAL(12,2) DEFAULT 0,
    lifetime_transferred_out DECIMAL(12,2) DEFAULT 0,
    lifetime_transferred_in DECIMAL(12,2) DEFAULT 0,
    rank TEXT DEFAULT 'chien_binh' CHECK (rank IN ('chien_binh', 'tuong_quan', 'thong_soai', 'nguyen_soai')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transaction history
CREATE TABLE IF NOT EXISTS ag_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_user_id UUID REFERENCES auth.users(id),
    to_user_id UUID REFERENCES auth.users(id),
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    type TEXT NOT NULL CHECK (type IN ('earn', 'spend', 'transfer', 'bonus', 'refund', 'cashout')),
    status TEXT DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'failed', 'cancelled')),
    description TEXT,
    reference_id TEXT, -- Order ID, subscription ID, etc.
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Payout requests (for cash out)
CREATE TABLE IF NOT EXISTS ag_payouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    amount DECIMAL(12,2) NOT NULL CHECK (amount >= 100), -- Min $100
    fee DECIMAL(12,2) DEFAULT 0, -- 5% fee
    net_amount DECIMAL(12,2) NOT NULL,
    method TEXT NOT NULL CHECK (method IN ('paypal', 'wise', 'bank', 'crypto')),
    payout_details JSONB NOT NULL, -- email, wallet address, etc.
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled')),
    processed_at TIMESTAMP WITH TIME ZONE,
    transaction_ref TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Rank thresholds
CREATE TABLE IF NOT EXISTS ag_ranks (
    rank TEXT PRIMARY KEY,
    min_lifetime_earned DECIMAL(12,2) NOT NULL,
    bonus_percentage DECIMAL(5,2) DEFAULT 0,
    display_name TEXT NOT NULL,
    emoji TEXT NOT NULL,
    perks JSONB DEFAULT '[]'
);

-- Insert rank definitions
INSERT INTO ag_ranks (rank, min_lifetime_earned, bonus_percentage, display_name, emoji, perks) VALUES
    ('chien_binh', 0, 0, 'Chiến Binh', '🥉', '["Basic access"]'),
    ('tuong_quan', 500, 5, 'Tướng Quân', '🥈', '["5% bonus on earn", "Priority support"]'),
    ('thong_soai', 2000, 10, 'Thống Soái', '🥇', '["10% bonus on earn", "Badge", "Early access"]'),
    ('nguyen_soai', 10000, 15, 'Nguyên Soái', '👑', '["15% bonus", "Custom page", "VIP support", "Exclusive events"]')
ON CONFLICT (rank) DO NOTHING;

-- Function to update user rank
CREATE OR REPLACE FUNCTION update_user_rank()
RETURNS TRIGGER AS $$
BEGIN
    NEW.rank := (
        SELECT rank FROM ag_ranks 
        WHERE min_lifetime_earned <= NEW.lifetime_earned 
        ORDER BY min_lifetime_earned DESC 
        LIMIT 1
    );
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update rank
DROP TRIGGER IF EXISTS trigger_update_rank ON ag_credits;
CREATE TRIGGER trigger_update_rank
    BEFORE UPDATE ON ag_credits
    FOR EACH ROW
    WHEN (OLD.lifetime_earned IS DISTINCT FROM NEW.lifetime_earned)
    EXECUTE FUNCTION update_user_rank();

-- Function to add credits (with bonus calculation)
CREATE OR REPLACE FUNCTION add_ag_credits(
    p_user_id UUID,
    p_amount DECIMAL,
    p_type TEXT,
    p_description TEXT DEFAULT NULL,
    p_reference_id TEXT DEFAULT NULL
)
RETURNS DECIMAL AS $$
DECLARE
    v_bonus_pct DECIMAL;
    v_total_amount DECIMAL;
BEGIN
    -- Get user's bonus percentage
    SELECT COALESCE(r.bonus_percentage, 0) INTO v_bonus_pct
    FROM ag_credits c
    LEFT JOIN ag_ranks r ON c.rank = r.rank
    WHERE c.user_id = p_user_id;
    
    -- Calculate total with bonus
    v_total_amount := p_amount * (1 + COALESCE(v_bonus_pct, 0) / 100);
    
    -- Upsert credits
    INSERT INTO ag_credits (user_id, balance, lifetime_earned)
    VALUES (p_user_id, v_total_amount, v_total_amount)
    ON CONFLICT (user_id) DO UPDATE SET
        balance = ag_credits.balance + v_total_amount,
        lifetime_earned = ag_credits.lifetime_earned + v_total_amount;
    
    -- Record transaction
    INSERT INTO ag_transactions (from_user_id, to_user_id, amount, type, description, reference_id)
    VALUES (NULL, p_user_id, v_total_amount, p_type, p_description, p_reference_id);
    
    RETURN v_total_amount;
END;
$$ LANGUAGE plpgsql;

-- Function to transfer credits P2P
CREATE OR REPLACE FUNCTION transfer_ag_credits(
    p_from_user UUID,
    p_to_user UUID,
    p_amount DECIMAL,
    p_description TEXT DEFAULT 'P2P Transfer'
)
RETURNS BOOLEAN AS $$
DECLARE
    v_from_balance DECIMAL;
BEGIN
    -- Check sender balance
    SELECT balance INTO v_from_balance
    FROM ag_credits WHERE user_id = p_from_user;
    
    IF v_from_balance IS NULL OR v_from_balance < p_amount THEN
        RAISE EXCEPTION 'Insufficient balance';
    END IF;
    
    -- Deduct from sender
    UPDATE ag_credits SET
        balance = balance - p_amount,
        lifetime_transferred_out = lifetime_transferred_out + p_amount
    WHERE user_id = p_from_user;
    
    -- Add to receiver
    INSERT INTO ag_credits (user_id, balance, lifetime_transferred_in)
    VALUES (p_to_user, p_amount, p_amount)
    ON CONFLICT (user_id) DO UPDATE SET
        balance = ag_credits.balance + p_amount,
        lifetime_transferred_in = ag_credits.lifetime_transferred_in + p_amount;
    
    -- Record transaction
    INSERT INTO ag_transactions (from_user_id, to_user_id, amount, type, description)
    VALUES (p_from_user, p_to_user, p_amount, 'transfer', p_description);
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function to spend credits (for purchasing)
CREATE OR REPLACE FUNCTION spend_ag_credits(
    p_user_id UUID,
    p_amount DECIMAL,
    p_description TEXT,
    p_reference_id TEXT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    v_balance DECIMAL;
BEGIN
    SELECT balance INTO v_balance
    FROM ag_credits WHERE user_id = p_user_id;
    
    IF v_balance IS NULL OR v_balance < p_amount THEN
        RAISE EXCEPTION 'Insufficient balance';
    END IF;
    
    UPDATE ag_credits SET
        balance = balance - p_amount,
        lifetime_spent = lifetime_spent + p_amount
    WHERE user_id = p_user_id;
    
    INSERT INTO ag_transactions (from_user_id, to_user_id, amount, type, description, reference_id)
    VALUES (p_user_id, NULL, p_amount, 'spend', p_description, p_reference_id);
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- RLS Policies
ALTER TABLE ag_credits ENABLE ROW LEVEL SECURITY;
ALTER TABLE ag_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ag_payouts ENABLE ROW LEVEL SECURITY;

-- Users can view their own credits
CREATE POLICY "Users view own credits" ON ag_credits
    FOR SELECT USING (auth.uid() = user_id);

-- Users can view their own transactions
CREATE POLICY "Users view own transactions" ON ag_transactions
    FOR SELECT USING (auth.uid() = from_user_id OR auth.uid() = to_user_id);

-- Users can view their own payouts
CREATE POLICY "Users view own payouts" ON ag_payouts
    FOR SELECT USING (auth.uid() = user_id);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_ag_transactions_from ON ag_transactions(from_user_id);
CREATE INDEX IF NOT EXISTS idx_ag_transactions_to ON ag_transactions(to_user_id);
CREATE INDEX IF NOT EXISTS idx_ag_transactions_type ON ag_transactions(type);
CREATE INDEX IF NOT EXISTS idx_ag_payouts_user ON ag_payouts(user_id);
CREATE INDEX IF NOT EXISTS idx_ag_payouts_status ON ag_payouts(status);
