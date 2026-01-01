-- ==============================================================
-- Migration: Fix Supabase Security Linter Errors
-- Date: 2026-01-01
-- Fixes: SECURITY DEFINER views and RLS disabled tables
-- ==============================================================

-- ============================================================
-- PART 1: Fix SECURITY DEFINER Views
-- Convert to SECURITY INVOKER
-- ============================================================

-- 1. hq_revenue_summary
DROP VIEW IF EXISTS public.hq_revenue_summary;
CREATE OR REPLACE VIEW public.hq_revenue_summary 
WITH (security_invoker = true)
AS
SELECT 
  date_trunc('month', created_at) as month,
  SUM(amount) as total_revenue,
  COUNT(*) as transaction_count
FROM public.transactions
WHERE status = 'completed'
GROUP BY date_trunc('month', created_at)
ORDER BY month DESC;

-- 2. marketplace_stats
DROP VIEW IF EXISTS public.marketplace_stats;
CREATE OR REPLACE VIEW public.marketplace_stats 
WITH (security_invoker = true)
AS
SELECT 
  COUNT(*) as total_listings,
  SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_listings,
  AVG(price) as avg_price
FROM public.listings;

-- 3. tier_limits
DROP VIEW IF EXISTS public.tier_limits;
CREATE OR REPLACE VIEW public.tier_limits 
WITH (security_invoker = true)
AS
SELECT 
  tier,
  max_users,
  max_projects,
  features
FROM public.subscription_tiers;

-- ============================================================
-- PART 2: Enable RLS on Tables
-- ============================================================

-- 1. ag_ranks
ALTER TABLE public.ag_ranks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ag_ranks_select_policy" ON public.ag_ranks
  FOR SELECT USING (true);
CREATE POLICY "ag_ranks_admin_policy" ON public.ag_ranks
  FOR ALL USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- 2. report_verifications
ALTER TABLE public.report_verifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "report_verifications_select_policy" ON public.report_verifications
  FOR SELECT USING (auth.uid() = user_id OR auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));
CREATE POLICY "report_verifications_insert_policy" ON public.report_verifications
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 3. pricing_benchmarks
ALTER TABLE public.pricing_benchmarks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "pricing_benchmarks_select_policy" ON public.pricing_benchmarks
  FOR SELECT USING (true);
CREATE POLICY "pricing_benchmarks_admin_policy" ON public.pricing_benchmarks
  FOR ALL USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- 4. project_submissions
ALTER TABLE public.project_submissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "project_submissions_select_own" ON public.project_submissions
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "project_submissions_insert_own" ON public.project_submissions
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "project_submissions_admin" ON public.project_submissions
  FOR ALL USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- 5. guild_referrals
ALTER TABLE public.guild_referrals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "guild_referrals_select_own" ON public.guild_referrals
  FOR SELECT USING (auth.uid() = referrer_id OR auth.uid() = referred_id);
CREATE POLICY "guild_referrals_insert" ON public.guild_referrals
  FOR INSERT WITH CHECK (auth.uid() = referrer_id);

-- 6. newsletter_events
ALTER TABLE public.newsletter_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "newsletter_events_select" ON public.newsletter_events
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "newsletter_events_insert" ON public.newsletter_events
  FOR INSERT WITH CHECK (true);

-- 7. newsletter_cross_promos
ALTER TABLE public.newsletter_cross_promos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "newsletter_cross_promos_select" ON public.newsletter_cross_promos
  FOR SELECT USING (true);
CREATE POLICY "newsletter_cross_promos_admin_policy" ON public.newsletter_cross_promos
  FOR ALL USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- ============================================================
-- VERIFICATION
-- ============================================================
-- Run: SELECT * FROM pg_catalog.pg_policies;
-- Run: SELECT table_name, row_security FROM information_schema.tables WHERE row_security = 'YES';
