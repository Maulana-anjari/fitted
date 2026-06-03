# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Fitted is an AI-powered wardrobe intelligence platform (iOS & Android) that helps users digitize their wardrobe, create Fits (outfits), plan what to wear, and receive AI styling recommendations. The product combines wardrobe management, AI outfit generation, planning/scheduling, wear analytics, and virtual try-on.

Reference docs: `PRD.md` (product requirements), `TADv2.md` (technical architecture), `FITTED.DESIGN.md` (design system).

## Tech Stack

- **Frontend**: Flutter + Dart
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Local Cache**: Hive
- **Networking**: Supabase SDK + Dio
- **Backend (MVP)**: Supabase — Auth, PostgreSQL, Storage, Edge Functions. No dedicated backend server.
- **AI**: GPT-4o Vision (clothing understanding), GPT-4o (Smart Fit Engine), Gemini 2.5 (fallback), RMBG (background removal)
- **Analytics**: PostHog
- **Crash Monitoring**: Sentry
- **Email**: Space Mail

## Useful Commands

```bash
# Flutter
flutter pub get          # Install dependencies
flutter run              # Run on connected device/emulator
flutter test             # Run all tests
flutter test test/path   # Run a single test file
flutter build apk        # Build Android APK
flutter build ios        # Build iOS
flutter analyze          # Static analysis (lint)
flutter format .         # Format Dart code

# Supabase
supabase init            # Initialize Supabase project
supabase start           # Start local Supabase stack
supabase db push         # Push local migrations to remote
supabase functions serve # Run Edge Functions locally
```

## Architecture: Feature-First + Clean Architecture

```
lib/
  features/
    auth/
    wardrobe/
    fits/
    planner/
    fit_check/
    fit_insights/
    profile/
  shared/
  core/
```

Each feature contains its own presentation, domain, and data layers. Shared widgets and utilities go in `shared/`. Core infrastructure (theme, networking, routing) goes in `core/`.

## Product Language

Always use these terms in code, UI copy, and documentation:
- **Fit** (not outfit)
- **Wardrobe** (not closet)
- **Daily Fit**, **Fit Check**, **Fit Planner**, **Fit Insights**, **Fit Builder**, **My Fits**, **Fit DNA**, **Fit Coach**, **Fit Score**, **Fit Preview**

Do not use the words "outfit", "closet", or "styling tool".

## Navigation Tabs

1. Daily Fit (home) — daily recommendations, highest-priority screen
2. Wardrobe — digitized clothing items
3. Fit Planner — monthly calendar scheduling
4. Fit Check — conversational AI style assistant
5. Profile

## Design System Quick Reference

- **Primary**: `#111827` (Deep Charcoal) — buttons, nav, headings
- **AI Accent**: `#6366F1` (Indigo) — exclusively for AI features (Fit Check, Smart Fit, Fit DNA, Fit Coach)
- **Success**: `#22C55E`, **Warning**: `#F59E0B`
- **Background**: `#FAFAFA`, **Surface**: `#FFFFFF`
- **Font**: Inter (Bold/SemiBold/Regular/Medium), 40/32/24/20/16/14/12px
- **Spacing**: 8px base unit (8, 16, 24, 32, 40, 48, 64)
- **Border Radius**: 12/16/24/32px
- **Motion**: 150-250ms, fast and subtle
- **Touch targets**: 44px minimum, contrast 4.5:1 minimum

## MVP Phases

- **Phase 1**: Auth, Wardrobe, Background Removal, AI Categorization
- **Phase 2**: Fit Builder, My Fits, Fit Planner, Wear Tracking
- **Phase 3**: Fit Check, Smart Fit Engine, Weather Integration, Fit Collections

## Key Constraints

- No dedicated backend for MVP — use Supabase Edge Functions exclusively
- No ORM — SQL-first approach via Supabase PostgreSQL
- No custom ML training — orchestrate foundation models only
- Migrate to NestJS only when MAU > 10k or AI requests > 100k/month
- Row Level Security on all database access; private storage buckets by default
