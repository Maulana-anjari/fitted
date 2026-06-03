# Fitted

**Find Your Perfect Fit Every Day.**

Fitted is an AI-powered wardrobe intelligence platform that helps you digitize your wardrobe, create Fits (outfits), plan what to wear, and receive AI styling recommendations.

---

## Product

Fitted combines the intelligence of ChatGPT, the habit loop of Duolingo, the personalization of Spotify, and the elegance of Apple. It feels less like software and more like having a personal stylist available every day.

### Features

- **Daily Fit** — AI-recommended outfit every morning based on weather, calendar, and wear history
- **Wardrobe** — Digitize your clothing with AI-powered categorization and background removal
- **Fit Builder** — Drag-and-drop canvas to create and save Fits
- **Fit Planner** — Monthly calendar to schedule what to wear
- **Fit Check** — Conversational AI style assistant with full wardrobe context
- **Fit Insights** — Analytics on wardrobe utilization, most-worn items, cost-per-wear

### MVP Phases

| Phase | Scope |
|-------|-------|
| 1 | Auth, Wardrobe digitization, Background removal, AI categorization |
| 2 | Fit Builder, My Fits, Fit Planner, Wear tracking |
| 3 | Fit Check, Smart Fit Engine, Weather integration, Fit Collections |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter + Dart |
| State Management | Riverpod |
| Routing | GoRouter |
| Local Cache | Hive |
| Backend (MVP) | Supabase — Auth, PostgreSQL, Storage, Edge Functions |
| AI | GPT-4o Vision, GPT-4o, Gemini 2.5 (fallback) |
| Image Processing | RMBG (background removal) |
| Analytics | PostHog |
| Crash Monitoring | Sentry |
| Email | Space Mail |

---

## Architecture

```
lib/
  features/
    auth/           # Authentication (email, Google, Apple)
    wardrobe/       # Clothing digitization & management
    fits/           # Fit creation & management
    planner/        # Calendar scheduling
    fit_check/      # Conversational AI assistant
    fit_insights/   # Analytics & insights
    daily_fit/      # Home screen — daily recommendations
    profile/        # User settings & identity
  shared/           # Shared widgets
  core/             # Theme, router, networking, storage
```

Each feature follows **Feature-First + Clean Architecture** with domain, data, and presentation layers.

---

## Getting Started

### Prerequisites

- Flutter 3.27+
- Dart 3.5+
- Supabase CLI
- A Supabase project

### Setup

```bash
# Clone the repo
git clone git@github.com:Maulana-anjari/fitted.git
cd fitted

# Install dependencies
flutter pub get

# Configure environment
cp .env.example .env
# Fill in your Supabase and API keys in .env

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Launch the app
flutter run
```

### Supabase Setup

```bash
supabase init
supabase link --project-ref <your-project-ref>
supabase db push
```

### Edge Functions

```bash
supabase functions deploy analyze-clothing
supabase functions deploy remove-background
supabase functions deploy smart-fit
supabase functions deploy fit-check
```

---

## Design System

| Token | Value |
|-------|-------|
| Primary | `#111827` (Deep Charcoal) |
| AI Accent | `#6366F1` (Indigo) — AI features only |
| Background | `#FAFAFA` |
| Font | Inter (Bold/SemiBold/Regular/Medium) |
| Spacing | 8px base unit |
| Border Radius | 12/16/24/32px |
| Touch Targets | 44px minimum |

See [FITTED.DESIGN.md](FITTED.DESIGN.md) for the complete design system.

---

## Product Language

Always use these terms in code, UI copy, and documentation:

- **Fit** (not outfit)
- **Wardrobe** (not closet)
- **Daily Fit**, **Fit Check**, **Fit Planner**, **Fit Insights**, **Fit Builder**, **My Fits**

---

## Documentation

- [PRD.md](PRD.md) — Product requirements
- [TADv2.md](TADv2.md) — Technical architecture
- [FITTED.DESIGN.md](FITTED.DESIGN.md) — Design system

---

## License

Proprietary. All rights reserved.
