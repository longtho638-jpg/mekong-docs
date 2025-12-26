-- =====================================================
-- FIX: Drop existing policies first, then recreate
-- Run this if you get "policy already exists" error
-- =====================================================

-- Drop existing policies
DROP POLICY IF EXISTS "Affiliates can view own data" ON affiliates;
DROP POLICY IF EXISTS "Affiliates can update own data" ON affiliates;
DROP POLICY IF EXISTS "Affiliates can view own clicks" ON affiliate_clicks;
DROP POLICY IF EXISTS "Affiliates can view own conversions" ON affiliate_conversions;
DROP POLICY IF EXISTS "Affiliates can view own payouts" ON affiliate_payouts;
DROP POLICY IF EXISTS "Affiliates can view own achievements" ON affiliate_achievements;
DROP POLICY IF EXISTS "Anyone can view monthly stats for leaderboard" ON affiliate_monthly_stats;

-- Recreate policies
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

CREATE POLICY "Anyone can view monthly stats for leaderboard" ON affiliate_monthly_stats
  FOR SELECT USING (true);

-- =====================================================
-- Verify tables exist
-- =====================================================
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE 'affiliate%';
