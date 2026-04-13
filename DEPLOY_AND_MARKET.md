# MultiVentures — Complete Deployment & Marketing Guide

---

## PART 1: LOCAL DEVELOPMENT SETUP

### Step 1 — Clone & Install

```bash
cd multiventures
npm install
```

### Step 2 — Set Up Environment Variables

```bash
cp .env.example .env.local
```

Now fill in each value. Follow the sections below.

---

## PART 2: SERVICE SETUP (ONE TIME)

### A — Google OAuth (Free)

1. Go to https://console.cloud.google.com
2. Create new project → name it "MultiVentures"
3. APIs & Services → OAuth consent screen
   - User type: External → Create
   - App name: MultiVentures
   - Add your email as developer contact → Save
4. APIs & Services → Credentials → Create Credentials → OAuth Client ID
   - Application type: Web application
   - Authorized redirect URIs:
     - http://localhost:3000/api/auth/callback/google (local dev)
     - https://your-domain.com/api/auth/callback/google (production)
5. Copy Client ID → GOOGLE_CLIENT_ID
6. Copy Client Secret → GOOGLE_CLIENT_SECRET

### B — Supabase (Free tier is generous)

1. Go to https://supabase.com → New Project
   - Name: multiventures
   - Password: generate and save securely
   - Region: pick closest to your users
2. Wait ~2 minutes for provisioning
3. Settings → API → copy:
   - Project URL → NEXT_PUBLIC_SUPABASE_URL
   - anon/public key → NEXT_PUBLIC_SUPABASE_ANON_KEY
   - service_role key → SUPABASE_SERVICE_ROLE_KEY (keep this secret!)
4. Go to SQL Editor → paste the entire contents of supabase-schema.sql → Run
5. Verify tables created: users, analyses, subscriptions

### C — Razorpay (India's #1 payment gateway — instant signup, no invite needed)

Why Razorpay?
- ✅ Indian company — works instantly for Indian founders
- ✅ Accepts UPI, Cards, NetBanking, Wallets, EMI — all Indian payment methods
- ✅ International cards accepted too (global customers pay you)
- ✅ Instant bank account settlement in INR
- ✅ Free to sign up — only pay per transaction (2% + ₹2 per charge)

1. Go to https://razorpay.com → Create Business Account (takes 10 minutes)
2. Activate your store:
   - Dashboard → Settings → Store
   - Fill in store name, currency (USD recommended), country
   - Add your payout bank account details

3. Create your product:
   - Dashboard → Products → New Product
   - Name: MultiVentures
   - Add 3 variants (one per plan):
   
   STARTER — $29/month:
   - Variant name: Starter
   - Billing: Monthly recurring
   - Price: $29
   - Copy the Variant ID → LS_VARIANT_STARTER
   
   PRO — $79/month:
   - Variant name: Pro  
   - Billing: Monthly recurring
   - Price: $79
   - Copy the Variant ID → LS_VARIANT_PRO
   
   AGENCY — $299/month:
   - Variant name: Agency
   - Billing: Monthly recurring
   - Price: $299
   - Copy the Variant ID → LS_VARIANT_AGENCY

4. Get API credentials:
   - Dashboard → Settings → API → Create API Key
   - Copy key → LEMONSQUEEZY_API_KEY
   - Dashboard → Settings → Store → Copy Store ID → LEMONSQUEEZY_STORE_ID

5. Set up Webhooks (after deploying to Vercel):
   - Dashboard → Settings → Webhooks → Add webhook
   - URL: https://your-domain.com/api/payments/webhook
   - Events to enable:
     ✓ subscription_created
     ✓ subscription_updated
     ✓ subscription_cancelled
     ✓ subscription_expired
     ✓ subscription_payment_failed
     ✓ order_created
   - Copy Signing Secret → LEMONSQUEEZY_WEBHOOK_SECRET

### D — Anthropic API Key

1. Go to https://console.anthropic.com
2. API Keys → Create Key → Copy → ANTHROPIC_API_KEY
3. Set usage limits to prevent runaway costs:
   - Go to Billing → Usage limits
   - Set monthly soft limit: $200 (email alert)
   - Set monthly hard limit: $500 (blocks requests)

### E — Generate NEXTAUTH_SECRET

```bash
openssl rand -base64 32
```

Copy the output → NEXTAUTH_SECRET

---

## PART 3: DEPLOY TO VERCEL (Free)

### Step 1 — Push to GitHub

```bash
git init
git add .
git commit -m "Initial MultiVentures commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/multiventures.git
git push -u origin main
```

### Step 2 — Deploy on Vercel

1. Go to https://vercel.com → Import Git Repository
2. Select your multiventures repository
3. Framework Preset: Next.js (auto-detected)
4. Environment Variables — add ALL variables from .env.example with real values
   (Do this before clicking Deploy)
5. Click Deploy → wait ~3 minutes
6. Your app is live at: https://multiventures-xyz.vercel.app

### Step 3 — Configure Custom Domain (Optional but recommended)

1. Buy domain on Namecheap or Cloudflare (~$10/year)
   Suggested: multiventures.ai, getmultiventures.com, venture-ai.io
2. Vercel → your project → Settings → Domains → Add your domain
3. Update DNS records as Vercel instructs (takes 5–60 minutes)

### Step 4 — Update OAuth & Webhook URLs

After you have your live URL:

1. Google Console → Credentials → Add production URL to Authorized redirect URIs:
   https://your-domain.com/api/auth/callback/google

2. Stripe → Webhooks → Add endpoint:
   https://your-domain.com/api/stripe/webhook
   Copy the new webhook secret → update STRIPE_WEBHOOK_SECRET in Vercel env vars

3. Update NEXTAUTH_URL in Vercel env vars:
   https://your-domain.com

4. Update NEXT_PUBLIC_APP_URL in Vercel env vars:
   https://your-domain.com

5. Redeploy: Vercel dashboard → Deployments → Redeploy

---

## PART 4: VERCEL ENVIRONMENT VARIABLES CHECKLIST

Go to: Vercel → Project → Settings → Environment Variables
Add each of these:

| Variable                             | Where to get it              |
|--------------------------------------|------------------------------|
| ANTHROPIC_API_KEY                    | console.anthropic.com        |
| NEXTAUTH_SECRET                      | openssl rand -base64 32      |
| NEXTAUTH_URL                         | https://your-domain.com      |
| GOOGLE_CLIENT_ID                     | Google Cloud Console         |
| GOOGLE_CLIENT_SECRET                 | Google Cloud Console         |
| NEXT_PUBLIC_SUPABASE_URL             | Supabase → Settings → API    |
| NEXT_PUBLIC_SUPABASE_ANON_KEY        | Supabase → Settings → API    |
| SUPABASE_SERVICE_ROLE_KEY            | Supabase → Settings → API    |
| RAZORPAY_KEY_ID                      | RZP → Settings → API Keys    |
| RAZORPAY_KEY_SECRET                  | RZP → Settings → API Keys    |
| RAZORPAY_WEBHOOK_SECRET              | RZP → Settings → Webhooks    |
| RAZORPAY_PLAN_STARTER                | RZP → Subscriptions → Plans  |
| RAZORPAY_PLAN_PRO                    | RZP → Subscriptions → Plans  |
| RAZORPAY_PLAN_AGENCY                 | RZP → Subscriptions → Plans  |
| NEXT_PUBLIC_APP_URL                  | https://your-domain.com      |

---

## PART 5: TEST EVERYTHING

### Test 1 — Auth
1. Visit your live URL
2. Click "Try Free"
3. Sign in with Google
4. Should redirect to /dashboard

### Test 2 — Run an Analysis (Costs ~$0.05 in API)
1. Type a business idea (at least 20 characters)
2. Click "Deploy All Agents"
3. Watch all 6 agents complete
4. Synthesis report should appear
5. Check Supabase → Table Editor → analyses — record should be there

### Test 3 — Stripe Checkout
1. Go to /pricing
2. Click "Get Started" on Starter plan
3. Use Stripe test card: 4242 4242 4242 4242, any future date, any CVC
4. Should redirect back to /dashboard?upgrade=success
5. Check: user's plan in Supabase should update to "starter"

### Test 4 — Usage Limits
1. Free user: run 1 analysis (used=1, limit=1)
2. Try running a second analysis
3. Should show upgrade prompt

### Test 5 — Webhook
1. In Stripe Dashboard → Webhooks → your endpoint → Send test event
2. Select: checkout.session.completed
3. Check Vercel logs: should show "Stripe event: checkout.session.completed"

---

## PART 6: COST BREAKDOWN (Monthly Operating Costs)

| Service      | Free Tier                     | At $5K MRR              |
|--------------|-------------------------------|-------------------------|
| Vercel       | Free (hobby tier works)       | ~$20/month (pro)        |
| Supabase     | Free up to 500MB              | ~$25/month              |
| Stripe       | Free (2.9% + 30¢ per charge)  | ~$145 on $5K gross      |
| Anthropic    | Per-use (~$0.08/analysis)     | ~$160 (2000 analyses)   |
| Domain       | ~$10/year                     | $1/month                |
| **TOTAL**    | **~$0/month**                 | **~$351/month**         |

At $5K MRR: Net operating cost ≈ 7% of revenue. Extremely lean.

---

## PART 7: REVENUE PROJECTIONS

Conservative growth scenario (you do ZERO paid marketing):

| Month | Users | Paid Conversions | MRR     |
|-------|-------|------------------|---------|
| 1     | 50    | 5 (10%)          | $250    |
| 2     | 150   | 20 (13%)         | $1,000  |
| 3     | 400   | 60 (15%)         | $3,500  |
| 6     | 1,500 | 250 (17%)        | $15,000 |
| 12    | 5,000 | 900 (18%)        | $55,000 |

Assumptions: avg $55/user/month, 3% monthly churn, organic growth via word-of-mouth + content.

---

## PART 8: MARKETING PLAYBOOK — HOW TO MAKE IT VIRAL

### WEEK 1 — FOUNDATIONS (Days 1–7)

#### LinkedIn Strategy (Your strongest channel)
Post this exact sequence — one post every 2 days:

**Post 1 — The Launch Announcement**
Hook: "I spent 3 months building an AI system that deploys 6 specialized agents to analyze any business idea. Here's what it produces in 8 minutes: [screenshot of a real analysis output]"
- Show a screenshot of a compelling synthesis report
- End with: "Link in first comment" (Linkedin algo penalizes links in body)

**Post 2 — The Behind-the-Scenes**
Hook: "Most 'AI tools' just wrap ChatGPT with a better prompt. MultiVentures is different. Here's how a true multi-agent pipeline works:"
- Explain the agent pipeline visually (build a simple diagram)
- End with: "I built this because [personal story about wanting to validate a business idea]"

**Post 3 — The Case Study**
Hook: "I ran a restaurant SaaS idea through MultiVentures. The Risk Guardian identified a regulatory issue that would have killed the business in Year 1. Here's the full analysis:"
- Share 500 words of the actual output (redacted)
- Massive engagement magnet for founders

**Post 4 — The Controversy**
Hook: "Hot take: Most consultants charge $50,000 for a market analysis that an AI can do better in 8 minutes."
- Data-driven comparison
- Will drive comments and shares

#### Twitter/X Strategy
- Share condensed versions of LinkedIn posts
- Use threads format: 1/ 2/ 3/ etc.
- Tag relevant accounts: @levelsio, @IndieHackers, @paulg (aspirational)
- Post in startup/founder spaces

#### Reddit Strategy (High ROI for early traction)
Post authentically in these subreddits (NOT promotional — share value):
- r/startups — "I built a multi-agent AI system. Here's what I learned about agent pipelines"
- r/entrepreneur — "Validated my business idea using AI — sharing the full report"
- r/SideProject — "Launched MultiVentures: 6 AI agents analyze your business idea"
- r/artificial — technical breakdown of multi-agent design
- r/indiehackers — full honest case study post

Rules for Reddit: 
- Lead with VALUE, not promotion
- Be genuinely helpful in comments
- Mention MultiVentures naturally, not in the opener

#### Product Hunt Launch (Week 2–3)
1. Make an account and be active for 1 week before launching
2. Find a hunter with 1000+ followers: DM them on Twitter
3. Prepare:
   - Tagline: "6 AI agents analyze your business idea in 8 minutes"
   - Thumbnail: clean screenshot of the dashboard
   - Gallery: 4-5 screenshots showing the pipeline, agents, report
   - Video: 90-second screen recording walkthrough
4. Launch on Tuesday or Wednesday at 12:01 AM Pacific time
5. Day-of: post in every community you're in, ask friends to upvote
6. Target: Top 5 Product of the Day → sends 500–2,000 visitors

### WEEK 2-4 — AMPLIFICATION

#### Build in Public
Tweet/post every week:
- Revenue numbers (even $0 → $100 → $500 progression is compelling)
- Interesting business ideas people analyzed (with permission)
- Product improvements and new features
- User testimonials and wins

The formula: "X days after launch. $Y MRR. Z users. Here's what I learned:"

#### Content Marketing (The 90-day compounding asset)
Write 2 blog posts per week:
- "How to validate a business idea before quitting your job"
- "The 6 things VCs look at when evaluating a startup (and how to prepare)"
- "TAM, SAM, SOM explained for non-finance founders"
- "5 businesses that failed because they ignored market timing"
- "What does a $1M ARR SaaS business look like? A financial breakdown"

Each post: 800–1,200 words, ends with a CTA to try MultiVentures free.
Post on: your blog, Medium, LinkedIn Articles, Dev.to

SEO targets:
- "business idea validation tool"
- "AI business analyzer"  
- "startup idea validation"
- "business plan AI generator"
- "market analysis AI"

#### YouTube (Highest leverage content channel)
One video per week, 5–10 minutes:
1. "I ran 10 business ideas through AI. Here are the scores."
2. "What a $50B market analysis looks like (using AI)"
3. "My AI rejected my business idea. Here's why it was right."
4. Screen recordings of real analyses (with permission)

#### Influencer Outreach
Target: startup YouTubers with 10K–200K subscribers
Email template:
"Hi [Name], I built MultiVentures — a tool that runs any business idea through 6 AI agents in 8 minutes. Would love to give you a free Pro account to try + $50 affiliate commission for every paying user you send. No pressure, just thought your audience might love it."

Target list: 
- Ali Abdaal (productivity/entrepreneurship)
- Josh Dunlop (side hustles)
- Starter Story / Pat Walls
- Small YouTubers in entrepreneur/startup niches (higher conversion rates)

#### Affiliate Program (Powerful virality flywheel)
Set up simple affiliate program via Rewardful ($49/month):
- 30% recurring commission for life
- Affiliates: business coaches, startup advisors, MBA professors
- Every affiliate becomes a self-interested promoter

#### Email List (Build from Day 1)
- Add email capture on landing page: "Get the free Venture Analysis Checklist"
- Send weekly email: "This week's interesting business analyses + one framework"
- Tool: Resend.com (free up to 3,000 emails/month)
- Grow to 1,000 subscribers → 10% paid conversion = $5,500 MRR

### MONTH 2-6 — SCALE

#### Partnerships
- Startup accelerators: offer free Pro accounts for their cohort members
  (Y Combinator, Techstars, local incubators) → They promote you to applicants
- Business schools: free access for MBA programs doing business plan competitions
- LinkedIn creators in the startup space: affiliate partnerships

#### Paid Marketing (Only start after $2K MRR organic)
- Google Ads: keywords "business idea validation", "startup market analysis"
  Budget: start at $10/day → $300/month
- Facebook/Instagram: target entrepreneurs, small business owners aged 25-45
- Reddit Ads: r/startups, r/entrepreneur

#### Product-Led Growth Features to Add (Months 3–6)
1. Shareable analysis links: "Share your Venture Compass Report" → viral marketing
2. Leaderboard: "Top 10 analyzed business ideas this week" → community + SEO
3. Team mode: multiple people can collaborate on an analysis
4. API access: agencies build it into their workflows → sticky revenue
5. Comparison mode: analyze 2 ideas side by side

---

## PART 9: MONETIZATION EXPANSION (Month 6+)

Once you have 500+ users, unlock these revenue streams:

1. **Done-For-You Reports** ($299 one-time)
   Human-reviewed MultiVentures reports with your personal commentary.
   
2. **Consulting Upsell** ($500–2,000/session)
   "Want me to walk you through your analysis on a call?"
   At 500 users, even 2 sessions/month = $1,000 extra.

3. **White-Label Licensing** ($999/month)
   Sell MultiVentures as "powered by" technology to:
   - Consulting firms
   - Incubators/accelerators
   - Corporate innovation teams
   - Business school programs

4. **API Access** ($99–499/month)
   Developers build MultiVentures into their own products.
   Target: no-code tools, business plan generators, investor portals.

5. **Annual Plans** (20% discount = 2.4 months free)
   Improves cash flow and reduces churn dramatically.
   Offer on pricing page: "$79/month or $758/year (save $190)"

6. **Enterprise** (Custom pricing, $2K–10K/month)
   Large consulting firms, PE/VC funds doing deal analysis.
   Requires: SSO, audit logs, team management, SLA.

---

## PART 10: KEY METRICS TO TRACK

Set up a simple dashboard (use PostHog free tier):

**Growth:**
- New signups per week
- Activation rate (% who run at least 1 analysis)
- Conversion rate (free → paid)

**Revenue:**
- MRR (Monthly Recurring Revenue)
- Churn rate (% cancelling each month — target < 5%)
- LTV / CAC ratio (target > 3:1)
- ARPU (Average Revenue Per User)

**Product:**
- Analyses run per week
- Time to complete analysis
- % who read full synthesis report
- % who share or copy the report

**Weekly Review Ritual:**
Every Monday morning, check:
1. MRR delta (up/down vs last week)
2. New signups (where did they come from?)
3. Any cancellations (email them why)
4. Top 3 actions for the week

---

## PART 11: QUICK-REFERENCE COMMANDS

```bash
# Run locally
npm run dev

# Build for production
npm run build

# Check for TypeScript errors
npx tsc --noEmit

# Update Vercel environment variables
vercel env add VARIABLE_NAME

# View production logs
vercel logs

# Test Stripe webhooks locally (requires Stripe CLI)
stripe listen --forward-to localhost:3000/api/stripe/webhook
```

---

Good luck, Siddharth. This is the blueprint. Now go execute.
The difference between a $0 product and a $50,000/month product is not the code.
It's the consistency of execution for 6 months. Build in public. Ship weekly. Talk to users.
