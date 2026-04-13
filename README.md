# MultiVentures 🔮

**AI-Powered Multi-Agent Business Intelligence Platform**

6 specialized AI agents analyze any business idea across Market, Strategy, Finance, Growth, Operations, and Risk — then synthesize a definitive Venture Compass Report.

## Stack

- **Frontend**: Next.js 14 (App Router), TypeScript, Tailwind CSS
- **AI**: Anthropic Claude (multi-agent pipeline)
- **Auth**: NextAuth.js with Google OAuth
- **Database**: Supabase (PostgreSQL)
- **Payments**: Stripe (subscriptions + billing portal)
- **Deployment**: Vercel

## Getting Started

```bash
npm install
cp .env.example .env.local
# Fill in all environment variables (see DEPLOY_AND_MARKET.md)
npm run dev
```

## Project Structure

```
multiventures/
├── app/
│   ├── page.tsx              # Landing page
│   ├── dashboard/page.tsx    # Main analysis UI
│   ├── history/page.tsx      # Past analyses
│   ├── pricing/page.tsx      # Pricing & upgrade
│   ├── auth/signin/page.tsx  # Sign-in
│   └── api/
│       ├── analyze/          # Main AI pipeline (SSE streaming)
│       ├── auth/             # NextAuth
│       ├── history/          # Analysis CRUD
│       └── stripe/           # Checkout + Webhook + Portal
├── components/
│   └── Navbar.tsx
├── lib/
│   ├── agents.ts             # All 6 agent definitions + prompts
│   ├── supabase.ts           # DB helpers
│   └── stripe.ts             # Stripe helpers + pricing
├── types/index.ts
├── middleware.ts             # Route protection
├── supabase-schema.sql       # Run in Supabase SQL Editor
└── DEPLOY_AND_MARKET.md      # Complete deployment + marketing guide
```

## Deployment

See `DEPLOY_AND_MARKET.md` for complete step-by-step instructions including:
- Google OAuth setup
- Supabase database setup
- Stripe products and webhooks
- Vercel deployment
- Custom domain configuration
- Full marketing playbook

## License

MIT
