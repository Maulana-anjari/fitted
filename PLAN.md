# Fitted — Implementation Plan

## Context

Fitted is an AI-powered wardrobe intelligence platform (Flutter + Supabase). Currently the repo only has docs (`PRD.md`, `TADv2.md`, `FITTED.DESIGN.md`). No Flutter code exists — this is a greenfield build.

We have 18 UI screens in Stitch (project `4081707793138547390`) covering all 5 tabs + dark variants + AI features. Implementation follows the MVP phasing from PRD:

- **Phase 1**: Auth, Wardrobe, Background Removal, AI Categorization
- **Phase 2**: Fit Builder, My Fits, Fit Planner, Wear Tracking
- **Phase 3**: Fit Check, Smart Fit Engine, Weather Integration, Fit Collections

This plan details Phase 1 file-by-file. Phases 2-3 are structural overviews.

---

## Step 1: Flutter Project & Dependencies

**Create the Flutter project at repo root:**
```bash
flutter create --org com.fitted --project-name fitted .
flutter pub get
```

**Dependencies** (`pubspec.yaml`):
- State: `flutter_riverpod`, `riverpod_annotation`
- Router: `go_router`
- Supabase: `supabase_flutter`
- Local cache: `hive_flutter`, `hive_generator`
- Network: `dio`
- Images: `cached_network_image`, `image_picker`, `image_cropper`
- UI: `flutter_svg`, `shimmer`, `google_fonts`
- Analytics: `posthog_flutter`, `sentry_flutter`
- Dev: `riverpod_generator`, `build_runner`, `mocktail`, `flutter_lints`

---

## Step 2: Core Infrastructure (`lib/core/`)

Create these files BEFORE any feature code:

| File | Purpose |
|------|---------|
| `core/theme/app_colors.dart` | `AppColors` — #111827, #6366F1, #FAFAFA, #22C55E, etc. |
| `core/theme/app_typography.dart` | `AppTypography` — Inter text styles (display 40px Bold through metadata 12px Medium) |
| `core/theme/app_spacing.dart` | `AppSpacing` — 8px base unit (xs:8, sm:16, md:24, lg:32, xl:40, 2xl:48, 3xl:64) |
| `core/theme/app_radius.dart` | `AppRadius` — sm:12, md:16, lg:24, hero:32, full:999 |
| `core/theme/app_theme.dart` | Light + dark `ThemeData` (uses above tokens, bottom nav styling) |
| `core/router/route_names.dart` | Named route constants (`/`, `/login`, `/wardrobe`, etc.) |
| `core/router/app_router.dart` | GoRouter config — `StatefulShellRoute.indexedStack` for 5 tabs, auth redirect guard |
| `core/network/supabase_client.dart` | `Supabase.initialize()` with env keys, exposes `supabaseClientProvider` |
| `core/network/dio_client.dart` | Dio instance for external AI APIs |
| `core/network/api_exception.dart` | Sealed exception hierarchy |
| `core/storage/hive_service.dart` | Hive init, typed boxes (wardrobe, fits, preferences) |
| `core/error/failure.dart` | Sealed `Failure` class (Network, Auth, Cache, Server) |
| `core/error/error_handler.dart` | Maps exceptions → Failures, wraps calls with try/catch |
| `core/analytics/analytics_service.dart` | PostHog wrapper with standard events |

---

## Step 3: Supabase Setup

### 3.1 Database Migrations (`supabase/migrations/`)

| Migration | Table | Phase |
|-----------|-------|-------|
| `001_users.sql` | `user_profiles` (extends auth.users, trigger on signup) | 1 |
| `002_wardrobe_items.sql` | `wardrobe_items` (images, metadata, wear_count, ai_metadata JSONB) | 1 |
| `003_fits.sql` | `fits` (saved outfits) | 2 |
| `004_fit_items.sql` | `fit_items` (fit ↔ wardrobe_item junction, layer order) | 2 |
| `005_planned_fits.sql` | `planned_fits` (calendar schedule) | 2 |
| `006_wear_history.sql` | `wear_history` (actual usage tracking) | 2 |
| `007_recommendation_history.sql` | `recommendation_history` (AI recommendations) | 3 |
| `008_rls_policies.sql` | RLS policies for ALL tables (user-owns-row pattern) | 1 |

### 3.2 Storage Buckets

Private-by-default buckets: `avatars`, `wardrobe-originals`, `wardrobe-processed`, `fit-thumbnails`, `fit-preview`. Each with RLS: user reads/writes only own folder.

### 3.3 Edge Functions (`supabase/functions/`)

| Function | Trigger | Model | Phase |
|----------|---------|-------|-------|
| `analyze-clothing` | Flutter invokes after upload | GPT-4o Vision (fallback Gemini 2.5) | 1 |
| `remove-background` | Flutter invokes after upload | RMBG API | 1 |
| `smart-fit` | Flutter invokes for recommendations | GPT-4o | 3 |
| `fit-check` | Flutter invokes for chat | GPT-4o (with wardrobe context) | 3 |

### 3.4 Env Secrets (Edge Functions)

`OPENAI_API_KEY`, `GEMINI_API_KEY`, `RMBG_API_KEY`, `SPACE_MAIL_API_KEY`

---

## Step 4: Phase 1 — Auth + Wardrobe

### 4.1 Shared Widgets (`lib/shared/widgets/`)

Create before feature screens — used everywhere:

| File | What |
|------|------|
| `app_bottom_nav.dart` | 5-tab `BottomNavigationBar` — Daily Fit, Wardrobe, Fit Planner, Fit Check, Profile |
| `app_scaffold.dart` | Shared scaffold wrapper (safe area, padding) |
| `loading_indicator.dart` | Branded spinner |
| `empty_state.dart` | Educational empty state with icon + text + CTA |
| `error_state.dart` | Error display with retry button |
| `primary_button.dart` | #111827 filled button, 44px min height, radius 12 |
| `secondary_button.dart` | Outlined button, #111827 border |
| `ai_accent_chip.dart` | Purple (#6366F1) chip for AI-labeled content |

### 4.2 Auth Feature (`lib/features/auth/`)

**Domain layer:**
```
domain/models/
  user.dart              # AppUser entity
  auth_state.dart        # AuthState (status enum + user + error)
domain/repositories/
  auth_repository.dart   # Abstract: signInEmail, signUpEmail, social auth, signOut, resetPassword
```

**Data layer:**
```
data/datasources/
  auth_remote_datasource.dart    # Supabase Auth + user_profiles table calls
data/repositories/
  auth_repository_impl.dart      # Maps exceptions → Failures
```

**Presentation layer:**
```
presentation/providers/
  auth_provider.dart             # StreamProvider<AuthState>, currentUserProvider, authNotifierProvider
presentation/screens/
  welcome_screen.dart            # Logo + "Get Started" + "I have an account"
  onboarding_screen.dart         # 3-4 swipeable intro pages
  login_screen.dart              # Email + Password + Social buttons
  signup_screen.dart             # Name + Email + Password + Social buttons
presentation/widgets/
  auth_form.dart                 # Shared TextFormField with validation
  social_auth_buttons.dart       # Google + Apple branded buttons (48px, radius 16)
```

**Route guard**: GoRouter `redirect` reads `authStateProvider` — unauthenticated users go to `/welcome`.

### 4.3 Wardrobe Feature (`lib/features/wardrobe/`)

**Domain layer:**
```
domain/models/
  clothing_category.dart     # Enum: top, bottom, outerwear, footwear, accessory, dress, bag
  wardrobe_item.dart         # Full entity (id, userId, images, category, color, material, season, formality, styleTags, wearCount, aiMetadata, etc.)
  ai_metadata.dart           # AI analysis result (confidence scores, raw AI outputs)
domain/repositories/
  wardrobe_repository.dart   # Abstract: getItems, getItem, addItem, updateItem, deleteItem, archiveItem
```

**Data layer:**
```
data/datasources/
  wardrobe_remote_datasource.dart   # Supabase DB (wardrobe_items) + Storage (upload/download)
  wardrobe_local_datasource.dart    # Hive cache for offline access
data/repositories/
  wardrobe_repository_impl.dart     # Remote-first, local fallback
```

**Presentation layer:**
```
presentation/providers/
  wardrobe_items_provider.dart      # AsyncNotifier — list + CRUD
  wardrobe_filters_provider.dart    # Category/color/season filter state
  wardrobe_upload_provider.dart     # AsyncNotifier — upload, background removal, AI analysis
presentation/screens/
  wardrobe_screen.dart              # Grid of items with filter bar, search, FAB for upload
  wardrobe_item_detail.dart         # Full-screen item view, edit metadata, delete
  wardrobe_upload_screen.dart       # Camera/gallery pick → crop → upload → processing → result
presentation/widgets/
  wardrobe_grid_item.dart           # Grid tile with image + category badge + favorite icon
  wardrobe_filter_bar.dart          # Horizontal chips for category/color/season
  wardrobe_search_bar.dart          # Search input
  upload_progress_widget.dart       # Progress indicator during upload + AI processing
  ai_metadata_card.dart             # AI-generated tags with Indigo accent
```

**Upload flow** (critical path):
1. User picks/captures image → crop (16:9) → preview
2. Upload original to `wardrobe-originals/{userId}/{itemId}.jpg`
3. Invoke `remove-background` edge function → processed image saved to `wardrobe-processed`
4. Invoke `analyze-clothing` edge function → returns structured metadata
5. Insert row into `wardrobe_items` with both image URLs + AI metadata
6. Cache in Hive for offline access

**Wardrobe screen**: 2-column grid, filter chips at top, search bar, FAB for upload, pull-to-refresh.

---

## Step 5: Phase 2 — Fit Builder, My Fits, Fit Planner, Wear Tracking

### 5.1 Fits Feature (`lib/features/fits/`)

```
domain/models/
  fit.dart               # Fit entity (id, name, thumbnail, occasion, isFavorite)
  fit_item.dart          # Junction: fit_id, wardrobe_item_id, layer_order, position
domain/repositories/
  fit_repository.dart    # CRUD fits + manage fit_items

presentation/screens/
  my_fits_screen.dart    # Grid of saved fits, search, filter by occasion
  fit_detail_screen.dart # Full fit view with items layered, edit/delete/duplicate
  fit_builder_screen.dart# Drag-drop canvas to combine wardrobe items
presentation/providers/
  fits_provider.dart     # List + CRUD
  fit_builder_provider.dart # Canvas state (layers, positions)
presentation/widgets/
  fit_card.dart          # Thumbnail card with name + occasion badge
  fit_builder_canvas.dart# Interactive item placement
  layer_panel.dart       # Reorder/remove layers
```

### 5.2 Planner Feature (`lib/features/planner/`)

```
presentation/screens/
  fit_planner_screen.dart   # Monthly calendar + scheduled fits list
presentation/providers/
  planner_provider.dart     # Calendar state, planned fits CRUD
presentation/widgets/
  month_calendar.dart       # Custom calendar grid with fit indicators
  planned_fit_card.dart     # Date label + outfit preview + weather
  schedule_fab.dart         # FAB to add planned fit
```

### 5.3 Wear Tracking

- `wear_history` table tracks each wear event
- `wardrobe_items.wear_count` and `last_worn_at` updated on wear
- "Mark as Worn Today" button on item detail and fit detail

---

## Step 6: Phase 3 — Fit Check, Smart Fit Engine, Weather

### 6.1 Fit Check (`lib/features/fit_check/`)

```
presentation/screens/
  fit_check_screen.dart      # Conversational AI chat interface
presentation/providers/
  fit_check_provider.dart    # Chat messages state, streaming
presentation/widgets/
  ai_message_bubble.dart     # AI response with Indigo accent styling
  fit_suggestion_card.dart   # Generated fit preview card
```

### 6.2 Fit Insights (`lib/features/fit_insights/`)

```
presentation/screens/
  fit_insights_screen.dart   # Analytics dashboard
presentation/widgets/
  wear_stat_card.dart        # "Most worn", "Cost per wear"
  wardrobe_utilization.dart  # Visual chart
  insight_feed.dart          # AI-generated insight cards
```

### 6.3 Smart Fit Engine

Edge function `smart-fit`:
- Input: wardrobe_items, weather, preferences, wear_history
- Output: recommended fit + confidence score + styling notes
- Called from Daily Fit, Fit Check, and Fit Planner

### 6.4 Weather Integration

- Weather API (e.g. OpenWeatherMap) called via Edge Function
- Used as input to Smart Fit Engine
- Displayed on Daily Fit and Fit Planner

---

## Step 7: App Entry Point (`lib/`)

| File | What |
|------|------|
| `main.dart` | Entry point — calls `bootstrap()` then `runApp(FittedApp())` |
| `bootstrap.dart` | Initializes Sentry, PostHog, Hive, Supabase |
| `app.dart` | `MaterialApp.router` with `AppTheme.light`, `AppTheme.dark`, `AppRouter.router` |
| `features/daily_fit/` | Minimal Phase 1 — placeholder screen showing onboarding prompt if wardrobe empty |

---

## Verification

1. **Project setup**: `flutter analyze` passes with zero errors
2. **Auth flow**: Sign up → login → session persists after app restart → sign out
3. **Wardrobe upload**: Pick image → crop → upload → background removal → AI categorization → item appears in grid
4. **Offline**: Airplane mode → cached wardrobe items still visible
5. **Routing**: All 5 tabs navigate correctly, auth guard redirects unauthenticated users
6. **Supabase**: All RLS policies enforce user isolation (verify with two test accounts)
7. **Design system**: Colors, typography, spacing match `FITTED.DESIGN.md` and Stitch screens
