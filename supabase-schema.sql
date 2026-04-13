-- =============================================
-- MultiVentures — Supabase Database Schema
-- Run this in the Supabase SQL Editor
-- =============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Users table (synced from NextAuth)
CREATE TABLE IF NOT EXISTS users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email         TEXT UNIQUE NOT NULL,
  name          TEXT,
  image         TEXT,
  stripe_customer_id TEXT,
  plan          TEXT NOT NULL DEFAULT 'free',   -- free | starter | pro | agency
  analyses_used INT NOT NULL DEFAULT 0,
  analyses_limit INT NOT NULL DEFAULT 1,         -- free = 1 lifetime
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Analyses table (stores each venture analysis)
CREATE TABLE IF NOT EXISTS analyses (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  idea          TEXT NOT NULL,
  agent_outputs JSONB,        -- { market: "...", strategy: "...", ... }
  synthesis     TEXT,
  status        TEXT NOT NULL DEFAULT 'pending',  -- pending | running | complete | error
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Subscriptions table (mirrors Stripe data)
CREATE TABLE IF NOT EXISTS subscriptions (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  stripe_subscription_id TEXT UNIQUE NOT NULL,
  stripe_price_id       TEXT NOT NULL,
  plan                  TEXT NOT NULL,
  status                TEXT NOT NULL,    -- active | canceled | past_due | trialing
  current_period_end    TIMESTAMPTZ,
  cancel_at_period_end  BOOLEAN DEFAULT FALSE,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER subscriptions_updated_at BEFORE UPDATE ON subscriptions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Row Level Security (important for security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Service role bypasses RLS (used by our API routes)
-- Users can only see their own data
CREATE POLICY "Users see own data" ON users
  FOR ALL USING (email = current_user);

CREATE POLICY "Users see own analyses" ON analyses
  FOR ALL USING (user_id = (SELECT id FROM users WHERE email = current_user));

-- Indexes for performance
CREATE INDEX IF NOT EXISTS analyses_user_id_idx ON analyses(user_id);
CREATE INDEX IF NOT EXISTS analyses_created_at_idx ON analyses(created_at DESC);
CREATE INDEX IF NOT EXISTS subscriptions_user_id_idx ON subscriptions(user_id);
CREATE INDEX IF NOT EXISTS users_email_idx ON users(email);
CREATE INDEX IF NOT EXISTS users_stripe_customer_id_idx ON users(stripe_customer_id);
