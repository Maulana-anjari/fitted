# Fitted — Image Generation Prompts

## Model: Gemini Banana Pro v2

Semua prompt mengikuti gaya fotografi produk Apple: natural lighting, premium, minimal, editorial fashion feel.
Palet warna: Deep Charcoal #111827, Indigo #6366F1, Soft White #FAFAFA. Font: Inter. No humans visible.

---

## 1. Hero Image — Cover

**File:** `fitted-hero.webp`

```
A premium editorial-style mobile app mockup for "Fitted," an AI-powered wardrobe intelligence platform. The main screen shows a daily outfit recommendation called "Daily Fit" — a ghost figure silhouette wearing a curated smart-casual outfit (white linen shirt, beige chinos, brown leather sneakers) with a floating weather widget showing partly cloudy 24°C and an AI-generated explanation bubble saying "Perfect for your product review meeting." Bottom navigation has 5 tabs: Daily Fit (active, indigo glow), Wardrobe, Fit Planner, Fit Check (with subtle purple AI accent), Profile.

Floating around the phone: a transparent PNG cutout of a navy blazer with metadata tags (category: TOP, color: Navy, material: Wool), and a small analytics card showing "Cost Per Wear: $2.40." A calendar snippet shows Fit Planner with 3 scheduled days.

Soft white studio background with subtle gradient. Natural window lighting from left. Shallow depth of field, focus on phone screen. The composition should feel like an Apple product launch image — clean, premium, intelligent. 8K detail, photorealistic.
```

---

## 2. System Architecture Diagram

**File:** `fitted-architecture.webp`

```
A clean, modern system architecture diagram in a premium presentation style for "Fitted" platform. Three horizontal tiers connected by downward arrows:

Top tier: "Flutter Mobile App" — represented as a sleek smartphone icon with a small clothing hanger icon, labeled "Riverpod / GoRouter / Hive Cache."

Middle tier: "Supabase Platform" — a large card containing four connected boxes in a row: "Auth (Google/Apple/Email)" with a lock icon, "PostgreSQL + RLS" with a database icon, "Storage (Private Buckets)" with a folder icon, and "Edge Functions (AI Orchestration)" with a lightning icon. The Edge Functions box has a subtle indigo glow (#6366F1).

Bottom tier: "External AI Services" — three boxes in a row: "GPT-4o Vision" with a camera icon, "RMBG Background Removal" with an eraser icon, "Weather API" with a cloud icon.

Small arrows flow from Edge Functions down to each AI service. A dashed-line box on the right labeled "Observability" contains "PostHog Analytics + Sentry Crash Monitoring" icons.

Dark charcoal (#111827) background for the canvas area. White cards with subtle rounded corners (12px). Clean sans-serif typography (Inter style). Minimal, no glossy 3D effects. Flat 2D isometric-lite style. Presentation-grade, suitable for a pitch deck.
```

---

## 3. AI Orchestration Pipeline

**File:** `fitted-ai-pipeline.webp`

```
An elegant flowchart-style diagram showing the AI processing pipeline for "Fitted" wardrobe intelligence platform. Left-to-right flow with five stages connected by arrows with small indigo (#6366F1) glow effects.

Stage 1: "Clothing Input" — illustrated as a smartphone camera capturing a white t-shirt on a table. Small label: "User captures clothing photo."

Stage 2: "Image Processing" — a box with two sub-steps: "Background Removal" (small eraser icon, label: RMBG) and "Transparent PNG Output." Subtle background removal visual effect on the shirt icon.

Stage 3: "AI Understanding" — a prominent box with indigo glow, labeled "GPT-4o Vision." Inside, six small tag chips: "Category: TOP", "Color: White", "Material: Cotton", "Season: Summer", "Formality: Casual", "Style: Minimalist." Below: "Fallback: Gemini 2.5" in smaller text.

Stage 4: "Smart Engine" — a box labeled "GPT-4o Smart Fit Engine" with input arrows from weather icon, calendar icon, and wear history graph. Output arrow shows a sparkle icon. Small note: "Context-rich prompt construction in Edge Functions."

Stage 5: "Output" — three result icons: "Daily Fit" (star), "Fit Check" (chat bubble), "Fit Insights" (bar chart).

Soft white-to-light-gray gradient background. Clean flat design, no heavy shadows. Presentation style, suitable for technical documentation. 8K.
```

---

## 4. UI Screen Concept — Multi-Screen Collage

**File:** `fitted-ui-screens.webp`

```
A premium editorial-style collage showing three iPhone mockups side by side on a soft white studio surface (minimal shadow, natural window light from above).

Left phone — "Wardrobe" screen: A Pinterest-style gallery grid of clothing items on a soft white background. Each item shown as a floating transparent PNG cutout. A search bar at top with filter chips below: "All, Tops, Bottoms, Outerwear, Shoes." A small floating card says "AI categorized 12 items" with an indigo (#6366F1) sparkle icon.

Center phone — "Daily Fit" screen: A ghost figure in an outfit with a large "Recommended Fit" header. Weather badge (sunny 28°C) and AI explanation: "Great for today's warm weather. You haven't worn these shorts in 3 weeks." A large indigo "Wear Today" button at bottom.

Right phone — "Fit Check" screen: A conversational AI interface with a chat-style layout. The AI bubble says "I notice you have a presentation today. Your navy blazer from last spring would work perfectly." Below, a "Generate Fit" button with indigo accent. Small clothing thumbnails appear as suggested items.

The overall scene should feel like an Apple product launch editorial photo spread. No human hands holding the phones. Soft shadows, clean lines, premium minimal aesthetic. 8K photorealistic detail.
```

---

## 5. Data Model / Schema Visualization

**File:** `fitted-data-model.webp`

```
A clean entity-relationship diagram (ERD) for "Fitted" database schema in a modern presentation style. Soft white background with subtle grid lines.

Eight entity boxes arranged in a relational layout, each with a header bar in Deep Charcoal (#111827) and white text:

Top-left: "users" with fields: id (PK), email, created_at. Connected to "user_preferences" via one-to-one line: preferred_style, preferred_colors, formality.

Center: "wardrobe_items" (largest box) with fields: id (PK), user_id (FK), image_url, category, color, material, season, formality, style_tags, wear_count, price. Connected to "fits" via a join table "fit_items" (id, fit_id FK, wardrobe_item_id FK).

Top-right: "fits" with fields: id (PK), user_id (FK), name, created_at, favorite.

Below: "planned_fits" with fields: id (PK), fit_id (FK), scheduled_date, event_name.

Bottom row: "wear_history" (id, wardrobe_item_id FK, worn_date) and "recommendation_history" (id, user_id FK, recommended_fit, accepted boolean).

Each relationship line has clear crow's foot notation (one-to-many). Small lock icons on every table header indicating Row Level Security. Indigo (#6366F1) accent on the title. Clean monospace font for field names. Flat design, no 3D. Suitable for technical documentation.
```

---

## 6. Design System Visual

**File:** `fitted-design-system.webp`

```
A premium design system specification board in the style of Linear or Apple Human Interface Guidelines. Flat lay on a soft white surface with natural lighting from above.

Six swatch cards across the top row, each showing a color name and hex value: "Deep Charcoal #111827" (circle swatch, used for buttons/headings), "Indigo #6366F1" (circle swatch, small label "AI Features Only"), "Soft White #FAFAFA" (background), "White #FFFFFF" (surface), "Green #22C55E" (success), "Amber #F59E0B" (warning).

Below: typography specimens for "Inter" font showing all seven sizes: Display 40px Bold, Heading 1 32px Bold, Heading 2 24px Bold, Heading 3 20px SemiBold, Body 16px Regular, Caption 14px Regular, Metadata 12px Medium. Each with a thin gray underline separator.

Bottom section: Spacing grid showing 8px base unit with visual blocks at 8, 16, 24, 32, 40, 48, 64px. Next to it, border radius examples at 12, 16, 24, 32px on small card mockups.

A thin Indigo line separates a small callout box: "Purple = AI Intelligence — learned visual cue." Clean, organized, presentation-grade. No humans. 8K.
```

---

## Usage

Generate each image separately via Banana Pro v2 (Gemini). Rename output files to match the filenames above, then place in `/public/images/` (or your portfolio's image directory). Update `fitted-case-study.md` already references these filenames.
