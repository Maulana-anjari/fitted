# TAD v2 — Fitted

## Technical Architecture Document

Version: 2.0

Product: Fitted

Tagline: Find Your Perfect Fit Every Day.

Platform: Mobile (iOS & Android)

Architecture Style: Supabase-Native + AI-First

Status: MVP Architecture

---

# 1. Architecture Principles

## Primary Goals

* Fast MVP Delivery
* AI-First Product
* Low Operational Overhead
* Minimal Backend Maintenance
* Production-Ready Security
* Cost Efficient
* Future Scalability

---

## Non-Goals

For MVP, avoid:

* Microservices
* Kubernetes
* Self-hosted infrastructure
* Custom ML training
* Premature optimization

---

# 2. High-Level Architecture

Flutter Mobile App
↓
Supabase Platform

├── Authentication
├── PostgreSQL Database
├── Storage
├── Row Level Security
├── Edge Functions

↓
External AI Services

├── OpenAI
├── Gemini
├── RMBG
├── Weather API

↓
Observability

├── PostHog
├── Sentry

---

# 3. Frontend Architecture

## Technology Stack

Framework:
Flutter

Language:
Dart

State Management:
Riverpod

Routing:
GoRouter

Networking:
Supabase SDK
Dio

Local Cache:
Hive

Image Handling:
Cached Network Image

---

## Architecture Pattern

Feature First + Clean Architecture

Structure:

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

---

## State Management

Riverpod

Reasons:

* Compile-time safety
* Scalable
* Testable
* Modern Flutter ecosystem

---

## Offline Strategy

Cached:

* Wardrobe Items
* My Fits
* User Preferences

Using:

Hive

---

# 4. Supabase Architecture

Supabase acts as:

* Authentication Provider
* PostgreSQL Provider
* Storage Provider
* Realtime Provider
* Backend Foundation

---

## Services Used

Supabase Auth

Google Login

Apple Login

Email Login

---

Supabase Database

PostgreSQL

---

Supabase Storage

Wardrobe Images

Processed Images

Avatar Images

Fit Thumbnails

---

Supabase Edge Functions

AI Calls

Image Processing Orchestration

Recommendation Generation

Webhook Handlers

---

# 5. Database Architecture

Database:
Supabase PostgreSQL

ORM:
None for MVP

SQL-first approach.

---

## Core Tables

users

user_preferences

wardrobe_items

fits

fit_items

planned_fits

wear_history

recommendation_history

---

## Future Tables

fit_collections

fit_preview_jobs

fit_dna_profiles

fit_scores

ai_generations

subscriptions

---

# 6. Supabase Schema

## users

Managed by Supabase Auth

Additional profile data stored separately.

---

## user_preferences

Stores:

* Preferred Style
* Preferred Colors
* Formality Preferences
* Lifestyle Preferences

Used by:

Fit Check

Fit DNA

Smart Fit

---

## wardrobe_items

Stores:

* Images
* Metadata
* Category
* Color
* Material
* Wear Count

Used by:

Wardrobe

Fit Builder

Fit Check

Fit Insights

---

## fits

Stores saved Fits.

---

## fit_items

Relationship table.

Fit ↔ Wardrobe Item

---

## planned_fits

Fit Planner schedule.

---

## wear_history

Tracks actual usage.

Primary source for:

Fit Insights

Recommendation Quality

Wardrobe Analytics

---

## recommendation_history

Tracks AI recommendations.

Used for:

Learning user preferences

Acceptance analysis

Recommendation optimization

---

# 7. Storage Architecture

Provider:
Supabase Storage

---

Buckets

avatars

wardrobe-originals

wardrobe-processed

fit-thumbnails

fit-preview

---

Access Policy

Private by default.

Public URLs generated when needed.

---

# 8. AI Architecture

## AI Philosophy

Never train custom models during MVP.

Use foundation models.

Build value through orchestration.

---

# 8.1 Clothing Understanding

Input:

Clothing Photo

Provider:

GPT-4o Vision

Fallback:

Gemini Vision

---

Output:

Category

Color

Material

Season

Formality

Style Tags

---

Example

White Linen Shirt

↓

{
"category": "TOP",
"color": "White",
"material": "Linen",
"season": "Summer",
"formality": "Smart Casual"
}

---

# 8.2 Smart Fit Engine

Purpose:

Generate recommendations.

Inputs:

Wardrobe

Weather

Calendar

Wear History

User Preferences

Fit DNA

---

Provider:

OpenAI GPT-4o

Fallback:

Gemini 2.5

---

Output:

Daily Fit

Fit Check

Fit Collections

Fit Coach

---

# 8.3 Fit DNA Engine

Purpose:

Generate style personality.

Inputs:

Wardrobe Inventory

Colors

Categories

Wear History

Saved Fits

---

Outputs:

Style Archetype

Preferred Colors

Style Breakdown

Wardrobe Personality

---

# 8.4 Fit Coach

Purpose:

Conversational AI Stylist.

Provider:

GPT-4o

Context:

User Wardrobe

Fit DNA

Weather

Preferences

---

# 9. Image Processing Architecture

## Background Removal

Provider:

RMBG

Alternative:

Cloudinary

---

Flow

Upload

↓

Background Removal

↓

Transparent PNG

↓

Storage

↓

Metadata Generation

---

# 10. Backend Architecture

For MVP:

No dedicated backend.

Use:

Supabase Edge Functions

---

Responsibilities

Secure AI Calls

Prompt Construction

Recommendation Generation

Webhook Processing

Scheduled Jobs

Email Automation

---

# 11. Email Architecture

Provider:

Space Mail

Purpose:

Transactional Email

---

Types

Welcome Email

Verification Email

Password Reset

Weekly Fit Summary

Premium Upgrade

Style Insights Digest

---

Flow

Edge Function

↓

SMTP

↓

Space Mail

↓

User Inbox

---

# 12. Analytics Architecture

Provider:

PostHog

---

Events

Sign Up

Wardrobe Item Added

Fit Created

Fit Planned

Fit Generated

Fit Shared

Fit Coach Used

Premium Clicked

---

North Star Metric

Active Wardrobe Size

---

Secondary Metrics

WAU

Retention

Fits Created

Recommendations Accepted

---

# 13. Crash Monitoring

Provider:

Sentry

---

Track

Flutter Crashes

API Errors

AI Failures

Edge Function Errors

Performance Issues

---

# 14. Security Architecture

Authentication

Supabase Auth

---

Authorization

Row Level Security

---

Encryption

TLS 1.3

---

Storage

Private Buckets

---

Compliance

Indonesian PDP

---

# 15. When NestJS Enters

Do NOT introduce NestJS in MVP.

---

Use Supabase until:

MAU > 10,000

OR

AI Requests > 100,000/month

OR

Business Logic becomes difficult to maintain in Edge Functions

---

Migration Path

Phase 1

Flutter
↓
Supabase

---

Phase 2

Flutter
↓
NestJS API
↓
Supabase PostgreSQL

---

Phase 3

Flutter
↓
API Gateway
↓
Microservices

AI Service

Recommendation Service

Analytics Service

---

# 16. Recommended Production Stack

Frontend

Flutter

Riverpod

GoRouter

Hive

---

Backend

Supabase

Edge Functions

---

Database

Supabase PostgreSQL

---

Storage

Supabase Storage

---

AI

GPT-4o

Gemini 2.5

---

Image Processing

RMBG

---

Analytics

PostHog

---

Crash Monitoring

Sentry

---

Email

Space Mail

---

# 17. Success Criteria

Wardrobe Upload < 5 sec

Background Removal < 10 sec

Daily Fit Generation < 3 sec

Crash-Free Sessions > 99%

Recommendation Acceptance Rate > 30%

Average Wardrobe Size > 30 Items/User

WAU > 40%

D30 Retention > 25%

