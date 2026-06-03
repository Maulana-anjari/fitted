# PRD v2 — Fitted

## Document Information

| Field           | Value                                     |
| --------------- | ----------------------------------------- |
| Product Name    | Fitted                                    |
| Version         | 2.0                                       |
| Author          | Product Team                              |
| Status          | Active                                    |
| Target Platform | Mobile (iOS & Android)                    |
| Product Type    | AI-Powered Wardrobe Intelligence Platform |

---

# 1. Executive Summary

Fitted is an AI-powered wardrobe intelligence platform that helps users digitize their wardrobe, create personalized Fits, plan what to wear, and receive daily styling recommendations powered by AI.

Unlike traditional wardrobe management applications, Fitted focuses on helping users maximize every item they own through intelligent outfit generation, wear analytics, wardrobe optimization, and personalized style coaching.

The product combines:

* Digital Wardrobe Management
* AI-Powered Fit Recommendations
* Fit Planning & Scheduling
* Wear Analytics
* Virtual Try-On Technology
* Sustainable Fashion Optimization

---

# 2. Vision

Become the world's most trusted AI wardrobe companion that helps people wear smarter, buy less, and feel confident every day.

---

# 3. Mission

Help users maximize every item in their wardrobe through AI-powered planning, styling, and wardrobe intelligence.

---

# 4. Brand System

## Tagline

Find Your Perfect Fit Every Day.

---

## Core Brand Principle

Users do not create outfits.

Users create Fits.

Every major feature revolves around helping users build, improve, schedule, evaluate, and optimize their Fits.

---

## Product Language

### Avoid

* Outfit
* Closet
* Styling Tool

### Prefer

* Fit
* Wardrobe
* Daily Fit
* Fit Planner
* Fit Check
* Fit Insights

---

## Navigation Structure

| Navigation | Product Name |
| ---------- | ------------ |
| Home       | Daily Fit    |
| Wardrobe   | Wardrobe     |
| Planner    | Fit Planner  |
| AI         | Fit Check    |
| Profile    | Profile      |

---

# 5. Problem Statement

## Outfit Decision Fatigue

Users spend significant time every day deciding what to wear.

---

## Underutilized Wardrobe

Most clothing items are rarely worn despite continued purchases.

---

## Impulse Shopping

Users buy new clothes without understanding what already exists in their wardrobe.

---

## Lack of Wardrobe Visibility

Users have no measurable understanding of wardrobe utilization.

---

## Difficult Fit Coordination

Users struggle to combine existing wardrobe items into attractive Fits.

---

# 6. Target Users

## College Student

Goals

* Look stylish
* Save money
* Plan campus Fits

---

## Young Professional

Goals

* Save time every morning
* Maintain a professional appearance

---

## Fashion Enthusiast

Goals

* Curate Fits
* Track wardrobe usage
* Experiment with personal style

---

# 7. Success Metrics

## User Metrics

* Registration Conversion > 70%
* Wardrobe Completion Rate > 60%
* WAU > 40%
* D30 Retention > 25%
* Fit Creation/User/Month > 12

---

## Business Metrics

* Premium Conversion: 5–10%
* Referral Rate: >15%
* Affiliate CTR: >8%

---

# 8. User Journey

Onboarding
→ Upload First Clothing Item
→ Build Wardrobe
→ Create First Fit
→ Save To My Fits
→ Schedule In Fit Planner
→ Receive Daily Fit Recommendation
→ Improve Style Using Fit Check
→ Track Usage Through Fit Insights

---

# 9. Core Features

## 9.1 Wardrobe

Purpose:
Digitize and organize all clothing items.

Features:

* Clothing Upload
* Camera Capture
* AI Background Removal
* AI Classification
* Smart Search
* Filtering
* Clothing Metadata

Acceptance Criteria:

* Upload < 5 seconds
* Background Removal Accuracy > 90%
* Classification Accuracy > 85%

---

## 9.2 Fit Builder

Purpose:
Create combinations of wardrobe items.

Features:

* Drag & Drop Canvas
* Layer Management
* Save Fit
* Duplicate Fit
* Edit Fit

Primary CTA:

Create Fit

---

## 9.3 My Fits

Purpose:
Store and organize saved Fits.

Features:

* Browse Fits
* Search Fits
* Favorite Fits
* Archive Fits

---

## 9.4 Daily Fit

Purpose:
Provide personalized daily recommendations.

Displays:

* Weather
* Upcoming Events
* Recommended Fit
* Recent Activity

Example:

Today's Fit is ideal for warm weather and light rain.

---

## 9.5 Fit Planner

Purpose:
Schedule Fits in advance.

Features:

* Monthly Calendar
* Event Planning
* Daily Scheduling
* Notifications

Actions:

* Plan Fit
* Reschedule Fit
* View Planned Fit

---

## 9.6 Fit Check

Purpose:
AI-powered style assistant.

Features:

* Daily Recommendations
* Event-Based Suggestions
* Weather-Based Suggestions
* Style Feedback

Actions:

* Run Fit Check
* Generate New Fit

---

## 9.7 Smart Fit Engine

Purpose:
Generate intelligent recommendations.

Inputs:

* Wardrobe Inventory
* Weather
* User Preferences
* Events
* Wear History

Outputs:

* Recommended Fit
* Fit Confidence Score
* Styling Notes

---

## 9.8 Fit Collections

Purpose:
Generate Fits for specific occasions.

Collections:

* Campus Fit
* Office Fit
* Wedding Fit
* Vacation Fit
* Hangout Fit

---

## 9.9 Fit Preview

Purpose:
Virtual Try-On experience.

Features:

* AI Avatar
* Garment Transfer
* Full Body Preview
* Style Comparison

---

## 9.10 Fit Insights

Purpose:
Wardrobe analytics dashboard.

Metrics:

* Most Worn Item
* Least Worn Item
* Cost Per Wear
* Wardrobe Utilization
* Style Trends

Example Insight:

You have not worn this jacket in 143 days.

---

# 10. Retention Features

## Wear Count Tracking

Track:

* Total Wears
* Last Worn Date
* Cost Per Wear

Formula:

Cost Per Wear = Item Price ÷ Total Wears

---

## Smart Wardrobe Insights

Examples:

* This jacket hasn't been worn in 6 months.
* Your black chinos are your highest-value item.

---

## Shopping Suggestions

AI identifies wardrobe gaps.

Example:

You own 12 tops but only 1 outerwear item.

---

## Social Sharing

Share Fits directly to:

* Instagram
* TikTok
* WhatsApp
* X

---

# 11. AI Architecture

## Clothing Detection

Models:

* YOLOv11
* Grounding DINO

---

## Background Removal

Models:

* RMBG
* Segment Anything
* rembg

---

## Smart Fit Engine

Models:

* OpenAI
* Claude
* Gemini

---

## Fit Preview

Models:

* Stable Diffusion XL
* IDM-VTON
* CatVTON
* Kolors Virtual Try-On

---

# 12. Technical Architecture

Frontend:

* Flutter

Backend:

* NestJS
* TypeScript

Database:

* PostgreSQL

Storage:

* AWS S3
* Cloudflare R2

Infrastructure:

* AWS

---

# 13. MVP Scope

## Phase 1

Included:

* Authentication
* Wardrobe
* Background Removal
* AI Categorization

Excluded:

* Fit Preview
* Fit Check

---

## Phase 2

Included:

* Fit Builder
* My Fits
* Fit Planner
* Wear Tracking

---

## Phase 3

Included:

* Fit Check
* Smart Fit Engine
* Weather Integration
* Fit Collections

---

# 14. Monetization

## Free

* 100 Clothing Items
* Basic Fit Builder
* Fit Planner

---

## Premium

* Unlimited Wardrobe
* Fit Check
* Smart Fit Recommendations
* Fit Insights
* Fit Preview

---

## Additional Revenue

* Affiliate Commerce
* Brand Partnerships
* Fashion Marketplace Integration

---

# 15. Future Premium Features

## Fit Score

AI-generated score for every Fit.

Factors:

* Color Harmony
* Occasion Match
* Weather Match
* Personal Preference

---

## Fit DNA

AI-generated style profile.

Examples:

* Minimalist Professional
* Smart Casual Explorer
* Modern Streetwear
* Classic Formal

---

## Fit Coach

Conversational AI stylist.

Examples:

* Can I wear this blazer with white sneakers?
* Generate a Fit for a tech conference.
* What should I pack for Bali for 5 days?

---

# 16. Risks & Mitigation

| Risk                             | Mitigation                      |
| -------------------------------- | ------------------------------- |
| User reluctant to upload clothes | AI import from shopping history |
| High inference cost              | Premium limitations             |
| Poor recommendations             | Personalization loop            |
| Try-on quality issues            | Continuous model tuning         |

---

# 17. Product Vision Statement

Fitted transforms every wardrobe into a smart, searchable, AI-powered fashion ecosystem that helps people create better Fits, reduce waste, save time, and build confidence every day.

