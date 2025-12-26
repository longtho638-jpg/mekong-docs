-- =============================================
-- EMAIL QUEUE SYSTEM
-- For scheduled onboarding emails
-- =============================================

CREATE TABLE IF NOT EXISTS email_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT NOT NULL,
    template TEXT NOT NULL,
    data JSONB DEFAULT '{}',
    send_at TIMESTAMP WITH TIME ZONE NOT NULL,
    sent BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP WITH TIME ZONE,
    error TEXT,
    order_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for efficient queue processing
CREATE INDEX IF NOT EXISTS idx_email_queue_pending ON email_queue(sent, send_at) 
WHERE sent = FALSE;

CREATE INDEX IF NOT EXISTS idx_email_queue_email ON email_queue(email);

-- Function to queue onboarding emails
CREATE OR REPLACE FUNCTION queue_onboarding_emails(
    p_email TEXT,
    p_name TEXT,
    p_order_id TEXT
)
RETURNS VOID AS $$
BEGIN
    -- Day 1 email (24 hours after)
    INSERT INTO email_queue (email, template, data, send_at, order_id)
    VALUES (
        p_email,
        'onboardingDay1',
        jsonb_build_object('name', p_name),
        NOW() + INTERVAL '1 day',
        p_order_id
    );
    
    -- Day 3 email
    INSERT INTO email_queue (email, template, data, send_at, order_id)
    VALUES (
        p_email,
        'onboardingDay3',
        jsonb_build_object('name', p_name),
        NOW() + INTERVAL '3 days',
        p_order_id
    );
    
    -- Day 7 email
    INSERT INTO email_queue (email, template, data, send_at, order_id)
    VALUES (
        p_email,
        'onboardingDay7',
        jsonb_build_object('name', p_name),
        NOW() + INTERVAL '7 days',
        p_order_id
    );
END;
$$ LANGUAGE plpgsql;

-- RLS
ALTER TABLE email_queue ENABLE ROW LEVEL SECURITY;

-- Only service role can access
CREATE POLICY "Service role only" ON email_queue
    FOR ALL USING (false);
