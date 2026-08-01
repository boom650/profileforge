# ProfileForge 2-Hour Improvement Session
**Start:** 15:21 | **End:** 17:21 | **Date:** 2026-08-01

## Phase 1: Replace Gemini SDK with Generic HTTP LLM Client (15:21–15:51)
- [ ] Remove `google_generative_ai` dependency
- [ ] Build `LlmClient` using `dio` (already in pubspec) — supports OpenAI-compatible API format
- [ ] Support multiple providers: OpenCode Zen, Nvidia NIM, Groq, Together, Mistral
- [ ] Update `GeminiService` → `LlmService` with provider config
- [ ] Update AI providers to use new client
- [ ] Add provider selector in AI Settings screen

## Phase 2: Home Page UI Overhaul (15:51–16:21)
- [ ] Redesign hero card with gradient + glassmorphism
- [ ] Add quick-action grid (Chat, Analyzer, Readiness, Timer)
- [ ] Improve mission cards with pill tags + progress indicators
- [ ] Better section headers with decorative accents
- [ ] Add subtle parallax/scroll effects

## Phase 3: Empty States + Loading States (16:21–16:51)
- [ ] Audit all screens for missing empty states
- [ ] Add shimmer loading to: Leagues, Teams, Quests, Challenges, Rewards
- [ ] Create reusable `EmptyState` widget with emoji + CTA
- [ ] Add `LoadingOverlay` for async operations
- [ ] Fix any screens that show blank on first load

## Phase 4: Onboarding + Dead Screen Cleanup (16:51–17:06)
- [ ] Onboarding: add page indicators + smoother transitions
- [ ] Remove any truly dead/unreachable code
- [ ] Fix CalendarScreen and GeoScreen (currently placeholder)
- [ ] Clean up import warnings

## Phase 5: Haptics, Transitions, Micro-interactions (17:06–17:21)
- [ ] Add HapticFeedback.lightImpact() on all tap targets
- [ ] Add slide transitions to all push routes
- [ ] Add scale animation on mission completion
- [ ] Final compilation check
- [ ] Commit all changes
