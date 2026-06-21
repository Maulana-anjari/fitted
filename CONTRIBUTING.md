# Contributing to Fitted

## Setup

1. Install Flutter (stable channel): https://docs.flutter.dev/get-started/install
2. Clone the repo and install dependencies:
   ```bash
   flutter pub get
   ```
3. Copy the env template and fill in real values (the `.env` file is git-ignored and never committed):
   ```bash
   cp .env.example .env
   # edit .env with your Supabase URL/anon key and AI provider keys
   ```
   - In **dev**, values are read from `.env` via `flutter_dotenv`.
   - In **release**, values come from `--dart-define=KEY=value` at build time; see `lib/core/config/env.dart`.

## Supabase

The backend is Supabase-native. Storage buckets and RLS policies are defined as SQL migrations under `supabase/migrations/`. Apply them with the Supabase CLI (`supabase db push`) or via the dashboard SQL editor.

## Running checks before pushing

```bash
flutter analyze      # must report no issues
flutter test         # all tests must pass
dart format lib/ test/   # then commit any formatting changes
```

CI runs the same three commands on every PR and on pushes to `main`.

## Branching & commits

- Branch from `main` with a prefix: `feat/...`, `fix/...`, `chore/...`, `docs/...`, `test/...`.
- Keep PRs focused; one concern per PR.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `test:`, `ci:`).

## Secrets

Never commit secrets. `.env` is git-ignored. If a key is accidentally committed, rotate it in the relevant dashboard and purge it from history before continuing.
