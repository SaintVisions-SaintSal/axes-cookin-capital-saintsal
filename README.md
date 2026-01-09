# HFCI Automation System

Complete automation infrastructure for HFCI foreclosure services with AI agents, lead scraping, and CRM integration.

## 🚀 Quick Start
```bash
# Install dependencies
pip install -r requirements.txt

# Copy .env.example to .env
cp .env.example .env

# Run database schema in Supabase SQL Editor
# (database/supabase_schema.sql)

# Test connection
python scripts/test_supabase.py

# Run scraper
python scripts/scrape_leads.py
```

## 📦 Features

- **Automated Lead Scraping**: Daily from Property Radar + Tavily enrichment
- **AI Voice Agents**: SaintSal, Darren AI, Lender Liaison
- **GHL Integration**: Real-time CRM sync
- **Supabase Backend**: PostgreSQL database

## 🏗️ Project Structure
```
hfci-automation/
├── .env.example          # Environment configuration
├── requirements.txt      # Python dependencies
├── database/
│   └── supabase_schema.sql  # Database schema
├── config/
│   └── supabase_client.py   # DB connection
├── scripts/
│   ├── test_supabase.py     # Test suite
│   ├── scrape_leads.py      # Lead scraper
│   └── ghl_sync_api.py      # GHL sync API
└── .github/
    └── workflows/
        └── daily_scrape.yml  # Automated scraping
```

## 🤖 AI Agents

- **SaintSal**: Primary intake specialist (first contact)
- **Darren AI**: Closer (financials, contracts, payments)
- **Lender Liaison**: 3-way lender calls

## 📅 Automated Runs

Scraper runs daily at 9 AM UTC via GitHub Actions.

Manual trigger: Actions tab → "Daily Lead Scraper" → Run workflow

## 🔐 GitHub Secrets

Add these to Settings → Secrets → Actions:

- `SUPABASE_URL`
- `SUPABASE_SERVICE_KEY`
- `TAVILY_API_KEY`
- `PROPERTY_RADAR_API_TOKEN`
- `GHL_LEAD_WEBHOOK`
- `ELEVENLABS_API_KEY`

## 📞 Support

Questions? Contact CAP or AJ.

---

**Built with ❤️ by AXES & HFCI**
