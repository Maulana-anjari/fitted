# Foundation Stabilization — Design Spec

- **Date:** 2026-06-20
- **Status:** Approved (pending implementation plan)
- **Branch:** `chore/foundation-stabilization`
- **Owner:** Maulana Anjari Anggorokasih

## 1. Problem Statement

The Fitted codebase has a strong design (PRD, TAD, clean architecture, RLS-enforced schema) but the implementation cannot be built, deployed, or trusted in its current state:

1. **Does not compile** — `flutter analyze` reports 356 errors, the majority being `uri_does_not_exist` for dependencies that *are* declared in `pubspec.yaml` (`flutter_riverpod`, `go_router`, `cached_network_image`), indicating `pubspec.lock` was never generated / `flutter pub get` was not run in this environment.
2. **Supabase anon key hard-coded** in `lib/bootstrap.dart` and present in git history at commit `3b1de25`.
3. **Storage buckets not defined as code** — `supabase/migrations/008_rls_policies.sql` contains only documentation comments about storage policies, not DDL. Buckets must be created manually in the dashboard, breaking reproducibility.
4. **No CI** — there is no automated build/test gate, so the 356-error state went undetected.
5. **Document inconsistency** — `PRD.md` §12 describes NestJS + AWS S3 + Cloudflare R2, contradicting `TADv2.md` and `CLAUDE.md` which mandate "Supabase-native, no NestJS for MVP."
6. **No automated tests** — `test/widget_test.dart` is a single `expect(true, isTrue)` placeholder.

This is a *foundation* problem: building features on top of code that cannot be built multiplies risk.

## 2. Goals & Non-Goals

### Goals
- G1. The project builds cleanly: `flutter pub get` + `flutter analyze` → no issues.
- G2. No secrets in source or git history; `.env` is the single source for runtime config.
- G3. Storage buckets and their RLS policies are defined as idempotent SQL migrations.
- G4. A CI workflow gates every pull request with `analyze`, `test`, and `format` checks.
- G5. Documentation is internally consistent and root-level stray docs are organized.
- G6. Critical-path unit tests exist for error handling and the auth/wardrobe repositories.

### Non-Goals (explicitly deferred)
- Implementing the end-to-end upload flow (image pick → remove-background → analyze-clothing → persist). That is Sprint 1.
- Migrating domain models to Freezed code generation.
- Comprehensive test coverage (widget tests, integration tests).
- Wiring PostHog / Sentry into `bootstrap.dart`.
- Fixing the `wear_count` double-increment and the Gemini `dataUri` bug.
- Implementing the AI rate-limiting / cost-guard.

## 3. Security Audit Findings (Pre-Design)

Before finalizing the design, the repository's actual secret exposure was audited:

| Item | Status |
|---|---|
| `.env` file (contains OpenAI / Gemini / RMBG keys + DB password) | **Never committed** — `.gitignore` covers `.env` since the initial commit |
| `.env.example` | Contains only placeholders — safe |
| OpenAI / Gemini / RMBG API keys | **Not present in git history** |
| Supabase DB password | **Not present in git history** |
| Supabase anon key (`REMOVED...`) | **Present at commit `3b1de25`**, hard-coded in `lib/bootstrap.dart` |

**Conclusion:** Only the Supabase **anon key** needs rotation and history cleanup. The publishable anon key is relatively low-risk, but the pattern of hard-coding must be removed. No other secret is exposed.

## 4. Approach: Layer-by-Layer, Verifiable Per Layer

A single branch (`chore/foundation-stabilization`) carries **5 sequential commits**, each producing an independently verifiable state. Order is fixed by technical dependency:

```
chore/foundation-stabilization
 ├─ [1] fix: resolve dependencies & clear analyze errors
 ├─ [2] chore: isolate Supabase credentials in .env
 ├─ [3] feat: define storage buckets as SQL migrations
 ├─ [4] ci: add analyze+test workflow on PR
 └─ [5] docs: align PRD/TAD & relocate root docs
```

### Ordering rationale
| # | Layer | Why this position |
|---|---|---|
| 1 | Build green | Every later layer needs a compiling baseline; CI (layer 4) would be red immediately otherwise. |
| 2 | Secrets `.env` | Modifies `bootstrap.dart`, so it needs layer 1. Must land before CI so CI never observes a hard-coded secret. |
| 3 | Storage as code | Independent of Dart code, but grouped with infra-as-code work for cohesion. |
| 4 | CI guardrail | Placed after the code is clean and secrets isolated, so the first CI run is green by construction. |
| 5 | Doc consistency | Last — docs reflect the final state and don't affect code. |

### Guiding principles
1. **No behavior change** — layers 1–3 must not alter existing (even if rudimentary) functionality; they only make it buildable and safe.
2. **Atomic commits** — each commit passes `flutter analyze` and `flutter test`.
3. **Verifiable** — every layer has an explicit verification command.

## 5. Layer-by-Layer Detail

### Layer 1 — Build Green

**Root cause:** `pubspec.lock` is absent; dependencies declared in `pubspec.yaml` were never resolved in this environment. The `uri_does_not_exist` errors are the symptom.

**Steps:**
1. `flutter pub get` → generates `pubspec.lock`.
2. Re-run `flutter analyze`; isolate genuine errors that remain (those not caused by unresolved imports).
3. Batch-fix the `withOpacity` deprecation lint (`info • deprecated_member_use`) → `.withValues(alpha: …)`.
4. Inspect and resolve any remaining genuine errors one by one. If a fix requires a design decision (e.g., a malformed model), surface it rather than blindly patching.

**Verification:** `flutter analyze` reports `No issues found!` (or a small residual set that is demonstrably unrelated to this effort and tracked separately).

### Layer 2 — Secrets `.env` + Anon Key Rotation

**Current (favorable) state:** `.env` already contains all secrets and is correctly git-ignored; `.env.example` already has placeholders. Only `bootstrap.dart` hard-codes the anon key.

**Steps:**
1. Add `flutter_dotenv` to `pubspec.yaml` dependencies.
2. Load strategy (decided): **dotenv for dev, `--dart-define` for release**.
   - `bootstrap.dart` reads each value as `dotenv.env[K] ?? const String.fromEnvironment(K)`. This makes the same code path work in both modes: dev uses the `.env` file; release injects via `--dart-define=SUPABASE_URL=...`.
   - The `.env` file stays git-ignored and holds real values only on local machines; `.env.example` holds placeholders and is committed.
3. Modify `lib/bootstrap.dart` to remove the hard-coded URL/anon key and read from environment as above. Initialize dotenv from `.env` at app start.
4. **Rotate the anon key** in the Supabase dashboard (manual, by owner). Update the local `.env` with the new key. This invalidates the leaked key.
5. **Install** `git-filter-repo` (`pip install git-filter-repo`) and remove the old anon key string from all history. Since the remote is a private repo in early stage (3 commits), force-push is acceptable; anyone who has cloned must re-clone.

**Verification:** `git log --all -S 'REMOVED' --oneline` returns nothing; the app still initializes against Supabase using the new key.

### Layer 3 — Storage as Code

**Problem:** `008_rls_policies.sql` documents storage policies in comments only; buckets are not created by any migration, so a fresh environment will not have them.

**Steps:**
1. Create `supabase/migrations/009_storage_buckets.sql` containing:
   - `insert into storage.buckets (...)` for: `avatars`, `wardrobe-originals`, `wardrobe-processed`, `fit-collages` (with appropriate `public` flags — originals/processed private, others as needed).
   - Storage RLS policies: a user may `read`/`insert`/`update`/`delete` only objects under a path prefixed by their own `auth.uid()`, enforced via `(storage.foldername(name)) = auth.uid()`.
2. Keep the documentation comments in `008` as reference; the real DDL lives in `009`. This avoids rewriting an applied migration.
3. Idempotency: use `on conflict do nothing` on bucket inserts so re-running is safe.

**Verification:** `supabase db push` against a fresh project applies `009` without error and the four buckets appear in the Storage dashboard.

### Layer 4 — CI Guardrail

**File:** `.github/workflows/ci.yml`

Triggers: `pull_request` and `push` to `main`. Single job runs on `ubuntu-latest`:
- `actions/checkout@v4`
- `subosito/flutter-action@v2` with a pinned Flutter channel and pub caching
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `dart format --set-exit-if-changed lib/ test/` (separate step so formatting drift is reported distinctly)

**Verification:** a push to the PR branch yields a green workflow run.

### Layer 5 — Documentation Consistency

1. Update `PRD.md` §12 (Technical Architecture) to match the TAD decision: "Supabase-native — Auth, PostgreSQL, Storage, Edge Functions. No NestJS for MVP." Remove the S3 / R2 / AWS references that contradict the current stack.
2. Merge the two near-duplicate root files:
   - `fitted-image-prompt.md` + `fitted-image-prompts.md` → `docs/image-prompts.md`.
   - Read both first to ensure no unique content is lost; delete the originals.
3. Relocate `fitted-case-study.md` → `docs/case-study.md`.
4. Add a minimal `CONTRIBUTING.md` (setup, running tests, branch convention, the `.env` requirement).
5. Scan for any broken internal links/references and repair.

**Verification:** no broken file references; `PRD.md` and `TADv2.md` agree on architecture.

## 6. Testing Strategy (Critical Path)

Coverage is intentionally narrow but targeted at the layers most likely to break silently: error mapping and repository behavior.

| Test | Type | What it verifies |
|---|---|---|
| `ErrorHandler.mapException` | Unit | All branches: `ApiException` subtypes, `DioException` types, `supabase.AuthException`, `supabase.PostgrestException`, generic exception — each maps to the correct `Failure` subtype with the expected message/statusCode. |
| `AuthRepositoryImpl` | Unit (mocktail) | `signIn`/`signUp`/`signOut`/`signOut` delegate to the datasource; datasource exceptions are caught and mapped through `ErrorHandler`; success returns the expected `AppUser`/void. |
| `WardrobeRepositoryImpl` | Unit (mocktail) | `getItems` returns remote data on success; on remote failure it falls back to the local Hive cache (offline-first); `addItem`/`deleteItem` delegate correctly and propagate failures. |

**Mechanics:** `mocktail` for datasource mocks. Files placed under `test/core/error/`, `test/features/auth/data/`, `test/features/wardrobe/data/`. Widget and integration tests are explicitly out of scope.

## 7. Risks & Mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| `flutter pub get` surfaces a deeper dependency conflict | Low | Resolve transitively; if a major dep must change, pause and confirm with owner. |
| Genuine analyzer errors beyond missing-imports require design choices | Medium | Surface each to owner rather than guessing; do not silence lints. |
| `git filter-repo` rewrite changes commit hashes and requires force-push | Certain (by design) | Owner has confirmed; remote is private and early-stage. Document the re-clone requirement in the PR description. |
| Layer 3 storage policies are syntactically subtle (folder-name matching) | Medium | Test the migration against a local Supabase (`supabase start`) before pushing; keep policy expressions simple and path-prefixed. |
| CI runner picks a Flutter version incompatible with the code | Low | Pin the Flutter channel in `flutter-action`. |

## 8. Definition of Done

A pull request from `chore/foundation-stabilization` into `main` is mergeable when **all** of the following hold:
1. `flutter analyze` → no issues locally.
2. `flutter test` → all critical-path tests pass.
3. `git log --all -S 'REMOVED'` → empty (old anon key purged).
4. `supabase/migrations/009_storage_buckets.sql` applies cleanly on a fresh project.
5. `.github/workflows/ci.yml` is green on the PR.
6. `PRD.md` §12 agrees with `TADv2.md` on the backend stack.
7. Root directory contains no stray `fitted-*.md` files; those docs live under `docs/`.

## 9. Out of Scope (Recap)

Upload flow, Freezed migration, full test coverage, observability wiring, `wear_count` fix, Gemini `dataUri` fix, AI rate-limiting. Each belongs to a later sprint and will get its own spec.
