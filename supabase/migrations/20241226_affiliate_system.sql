-- =====================================================
-- AFFILIATE SYSTEM TABLES FOR AGENCYOS
-- Run this migration in Supabase SQL Editor
-- =====================================================

-- 1. AFFILIATES TABLE
-- Stores affiliate accounts and settings
CREATE TABLE IF NOT EXISTS affiliates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  name TEXT,
  referral_code TEXT UNIQUE NOT NULL,
  payment_method TEXT DEFAULT 'paypal', -- paypal, wise, bank
  payment_email TEXT,
  total_clicks INTEGER DEFAULT 0,
  total_conversions INTEGER DEFAULT 0,
  total_earnings DECIMAL(10,2) DEFAULT 0,
  pending_payout DECIMAL(10,2) DEFAULT 0,
  lifetime_earnings DECIMAL(10,2) DEFAULT 0,
  badge TEXT DEFAULT 'new', -- new, first_blood, rising_star, diamond, king
  rank INTEGER,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. AFFILIATE CLICKS TABLE
-- Tracks all clicks on affiliate links
CREATE TABLE IF NOT EXISTS affiliate_clicks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  affiliate_id UUID REFERENCES affiliates(id) ON DELETE CASCADE,
  referral_code TEXT NOT NULL,
  source TEXT, -- utm_source
  medium TEXT, -- utm_medium
  campaign TEXT, -- utm_campaign
  landing_page TEXT,
  ip_hash TEXT, -- hashed for privacy
  user_agent TEXT,
  country TEXT,
  device TEXT, -- desktop, mobile, tablet
  browser TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. AFFILIATE CONVERSIONS TABLE
-- Tracks successful referral conversions
CREATE TABLE IF NOT EXISTS affiliate_conversions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  affiliate_id UUID REFERENCES affiliates(id) ON DELETE CASCADE,
  click_id UUID REFERENCES affiliate_clicks(id),
  order_id TEXT NOT NULL UNIQUE,
  product_name TEXT NOT NULL, -- Starter, Pro, Enterprise
  product_price DECIMAL(10,2) NOT NULL,
  commission_rate DECIMAL(5,2) NOT NULL, -- 0.40 for 40%
  commission_amount DECIMAL(10,2) NOT NULL,
  is_recurring BOOLEAN DEFAULT true,
  status TEXT DEFAULT 'pending', -- pending, approved, paid, refunded
  customer_email TEXT,
  lemon_squeezy_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  approved_at TIMESTAMPTZ,
  paid_at TIMESTAMPTZ
);

-- 4. AFFILIATE PAYOUTS TABLE
-- Tracks payout history
CREATE TABLE IF NOT EXISTS affiliate_payouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  affiliate_id UUID REFERENCES affiliates(id) ON DELETE CASCADE,
  amount DECIMAL(10,2) NOT NULL,
  currency TEXT DEFAULT 'USD',
  method TEXT NOT NULL, -- paypal, wise, bank
  payment_email TEXT,
  transaction_id TEXT,
  status TEXT DEFAULT 'pending', -- pending, processing, completed, failed
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ
);

-- 5. AFFILIATE ACHIEVEMENTS TABLE
-- Tracks earned achievements
CREATE TABLE IF NOT EXISTS affiliate_achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  affiliate_id UUID REFERENCES affiliates(id) ON DELETE CASCADE,
  achievement_type TEXT NOT NULL, -- first_blood, rising_star, diamond, king
  bonus_amount DECIMAL(10,2) NOT NULL,
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(affiliate_id, achievement_type)
);

-- 6. AFFILIATE MONTHLY STATS TABLE
-- Monthly aggregated stats for leaderboard
CREATE TABLE IF NOT EXISTS affiliate_monthly_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  affiliate_id UUID REFERENCES affiliates(id) ON DELETE CASCADE,
  month DATE NOT NULL, -- First day of month
  clicks INTEGER DEFAULT 0,
  conversions INTEGER DEFAULT 0,
  earnings DECIMAL(10,2) DEFAULT 0,
  rank INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(affiliate_id, month)
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_affiliates_referral_code ON affiliates(referral_code);
CREATE INDEX IF NOT EXISTS idx_affiliates_email ON affiliates(email);
CREATE INDEX IF NOT EXISTS idx_affiliate_clicks_referral ON affiliate_clicks(referral_code);
CREATE INDEX IF NOT EXISTS idx_affiliate_clicks_created ON affiliate_clicks(created_at);
CREATE INDEX IF NOT EXISTS idx_affiliate_conversions_affiliate ON affiliate_conversions(affiliate_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_conversions_status ON affiliate_conversions(status);
CREATE INDEX IF NOT EXISTS idx_affiliate_payouts_affiliate ON affiliate_payouts(affiliate_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_monthly_stats_month ON affiliate_monthly_stats(month);

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

ALTER TABLE affiliates ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_clicks ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_conversions ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_payouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_monthly_stats ENABLE ROW LEVEL SECURITY;

-- Affiliates can only see their own data
CREATE POLICY "Affiliates can view own data" ON affiliates
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Affiliates can update own data" ON affiliates
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Affiliates can view own clicks" ON affiliate_clicks
  FOR SELECT USING (
    affiliate_id IN (SELECT id FROM affiliates WHERE user_id = auth.uid())
  );

CREATE POLICY "Affiliates can view own conversions" ON affiliate_conversions
  FOR SELECT USING (
    affiliate_id IN (SELECT id FROM affiliates WHERE user_id = auth.uid())
  );

CREATE POLICY "Affiliates can view own payouts" ON affiliate_payouts
  FOR SELECT USING (
    affiliate_id IN (SELECT id FROM affiliates WHERE user_id = auth.uid())
  );

CREATE POLICY "Affiliates can view own achievements" ON affiliate_achievements
  FOR SELECT USING (
    affiliate_id IN (SELECT id FROM affiliates WHERE user_id = auth.uid())
  );

-- Public can view leaderboard (limited data)
CREATE POLICY "Anyone can view monthly stats for leaderboard" ON affiliate_monthly_stats
  FOR SELECT USING (true);

-- =====================================================
-- FUNCTIONS
-- =====================================================

-- Function to generate unique referral code
CREATE OR REPLACE FUNCTION generate_referral_code()
RETURNS TEXT AS $$
DECLARE
  code TEXT;
  exists BOOLEAN;
BEGIN
  LOOP
    code := upper(substring(md5(random()::text) from 1 for 8));
    SELECT EXISTS(SELECT 1 FROM affiliates WHERE referral_code = code) INTO exists;
    IF NOT exists THEN
      RETURN code;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to update affiliate stats after conversion
CREATE OR REPLACE FUNCTION update_affiliate_stats()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE affiliates
    SET 
      total_conversions = total_conversions + 1,
      total_earnings = total_earnings + NEW.commission_amount,
      pending_payout = pending_payout + NEW.commission_amount,
      updated_at = NOW()
    WHERE id = NEW.affiliate_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for conversion stats
CREATE TRIGGER trigger_update_affiliate_stats
  AFTER INSERT ON affiliate_conversions
  FOR EACH ROW
  EXECUTE FUNCTION update_affiliate_stats();

-- Function to check and award achievements
CREATE OR REPLACE FUNCTION check_achievements()
RETURNS TRIGGER AS $$
DECLARE
  conv_count INTEGER;
  aff_id UUID;
BEGIN
  aff_id := NEW.affiliate_id;
  SELECT total_conversions INTO conv_count FROM affiliates WHERE id = aff_id;
  
  -- First Blood (1 sale)
  IF conv_count >= 1 THEN
    INSERT INTO affiliate_achievements (affiliate_id, achievement_type, bonus_amount)
    VALUES (aff_id, 'first_blood', 25.00)
    ON CONFLICT DO NOTHING;
    UPDATE affiliates SET badge = 'first_blood' WHERE id = aff_id AND badge = 'new';
  END IF;
  
  -- Rising Star (5 sales)
  IF conv_count >= 5 THEN
    INSERT INTO affiliate_achievements (affiliate_id, achievement_type, bonus_amount)
    VALUES (aff_id, 'rising_star', 50.00)
    ON CONFLICT DO NOTHING;
    UPDATE affiliates SET badge = 'rising_star' WHERE id = aff_id AND badge IN ('new', 'first_blood');
  END IF;
  
  -- Diamond (25 sales)
  IF conv_count >= 25 THEN
    INSERT INTO affiliate_achievements (affiliate_id, achievement_type, bonus_amount)
    VALUES (aff_id, 'diamond', 250.00)
    ON CONFLICT DO NOTHING;
    UPDATE affiliates SET badge = 'diamond' WHERE id = aff_id AND badge IN ('new', 'first_blood', 'rising_star');
  END IF;
  
  -- King (100 sales)
  IF conv_count >= 100 THEN
    INSERT INTO affiliate_achievements (affiliate_id, achievement_type, bonus_amount)
    VALUES (aff_id, 'king', 1000.00)
    ON CONFLICT DO NOTHING;
    UPDATE affiliates SET badge = 'king' WHERE id = aff_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for achievements
CREATE TRIGGER trigger_check_achievements
  AFTER INSERT ON affiliate_conversions
  FOR EACH ROW
  EXECUTE FUNCTION check_achievements();

-- =====================================================
-- SAMPLE DATA (Optional - for testing)
-- =====================================================

-- Uncomment to insert sample affiliates for testing
/*
INSERT INTO affiliates (email, name, referral_code, total_clicks, total_conversions, total_earnings, pending_payout, badge)
VALUES 
  ('alex@example.com', 'Alex M.', 'ALEX2024', 523, 47, 1862.00, 356.00, 'diamond'),
  ('sarah@example.com', 'Sarah K.', 'SARAH24', 412, 38, 1505.00, 198.00, 'diamond'),
  ('john@example.com', 'John D.', 'JOHN888', 356, 31, 1228.00, 158.00, 'diamond'),
  ('maria@example.com', 'Maria L.', 'MARIA99', 298, 24, 950.00, 118.00, 'rising_star'),
  ('tom@example.com', 'Tom H.', 'TOMHAWK', 245, 19, 752.00, 79.00, 'rising_star');
*/
