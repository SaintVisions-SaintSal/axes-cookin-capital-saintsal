-- ============================================
-- HFCI Database Schema
-- Description: Complete database structure for HFCI automation
-- Created: 2026-01-09
-- ============================================

-- Drop existing tables if you need to reset (CAREFUL!)
-- DROP TABLE IF EXISTS call_logs CASCADE;
-- DROP TABLE IF EXISTS leads CASCADE;
-- DROP TABLE IF EXISTS scraper_runs CASCADE;

-- ============================================
-- Table 1: Leads (Main CRM Data)
-- ============================================
CREATE TABLE IF NOT EXISTS leads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Contact Info
  name TEXT,
  phone TEXT,
  email TEXT,
  property_address TEXT,
  
  -- Eligibility & Lead Data
  eligibility_code TEXT,
  lead_source TEXT,
  
  -- Lender Information
  lender_name TEXT,
  lender_phone TEXT,
  loan_number TEXT,
  
  -- Financial Details
  behind_amount INTEGER,
  monthly_payment INTEGER,
  loan_balance INTEGER,
  interest_rate NUMERIC(5,3),
  income INTEGER,
  savings_401k INTEGER,
  months_behind INTEGER,
  unpaid_principal_balance INTEGER,
  
  -- Loan Details
  hardship TEXT,
  loan_type TEXT,
  workout_option TEXT,
  
  -- Boolean Flags
  has_heloc BOOLEAN DEFAULT false,
  has_multiple_mortgages BOOLEAN DEFAULT false,
  in_foreclosure BOOLEAN DEFAULT false,
  previous_modification BOOLEAN DEFAULT false,
  data_enriched BOOLEAN DEFAULT false,
  lender_call_complete BOOLEAN DEFAULT false,
  contract_signed BOOLEAN DEFAULT false,
  payment_processed BOOLEAN DEFAULT false,
  
  -- Important Dates
  sale_date DATE,
  loan_origination_date DATE,
  maturity_date DATE,
  contract_sent_date DATE,
  contract_signed_date DATE,
  
  -- Tracking
  agent_last_contacted TEXT,
  ghl_contact_id TEXT,
  
  -- Timestamps
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- Table 2: Call Logs (AI Agent Activity)
-- ============================================
CREATE TABLE IF NOT EXISTS call_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
  
  -- Call Details
  agent_name TEXT,
  call_type TEXT,
  call_duration INTEGER,
  
  -- Call Content
  call_summary TEXT,
  call_transcript TEXT,
  call_recording_url TEXT,
  
  -- Action Items
  next_action TEXT,
  tags TEXT[],
  
  -- Timestamp
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- Table 3: Scraper Runs (Monitoring)
-- ============================================
CREATE TABLE IF NOT EXISTS scraper_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  run_date DATE DEFAULT CURRENT_DATE,
  
  -- Metrics
  leads_found INTEGER,
  leads_enriched INTEGER,
  leads_sent_to_ghl INTEGER,
  
  -- Errors
  errors TEXT[],
  status TEXT,
  
  -- Timestamp
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- Indexes for Performance
-- ============================================
CREATE INDEX IF NOT EXISTS idx_leads_phone ON leads(phone);
CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads(created_at);
CREATE INDEX IF NOT EXISTS idx_leads_ghl_contact_id ON leads(ghl_contact_id);
CREATE INDEX IF NOT EXISTS idx_call_logs_lead_id ON call_logs(lead_id);
CREATE INDEX IF NOT EXISTS idx_call_logs_created_at ON call_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_scraper_runs_run_date ON scraper_runs(run_date);

-- ============================================
-- Row Level Security (RLS)
-- ============================================
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE call_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE scraper_runs ENABLE ROW LEVEL SECURITY;

-- Allow service_role full access
CREATE POLICY IF NOT EXISTS "Service role has full access to leads"
ON leads FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

CREATE POLICY IF NOT EXISTS "Service role has full access to call_logs"
ON call_logs FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

CREATE POLICY IF NOT EXISTS "Service role has full access to scraper_runs"
ON scraper_runs FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ============================================
-- Trigger: Auto-update updated_at timestamp
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_leads_updated_at BEFORE UPDATE ON leads
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- Success Message
-- ============================================
DO $$
BEGIN
  RAISE NOTICE '✅ HFCI Database Schema Created Successfully!';
  RAISE NOTICE '📊 Tables: leads, call_logs, scraper_runs';
  RAISE NOTICE '🔒 RLS Enabled on all tables';
END $$;
