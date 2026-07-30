# ProfileForge — UX/UX Overhaul Plan

## Current State Analysis
- **113 dart files**, 25+ features (streaks, XP, leagues, skins, missions, teams, etc.)
- **No auth system** — device-local only, no login/signup
- **No splash screen** — jumps straight to home
- **Onboarding**: 10-step text-heavy wizard (college prep data), functional but generic
- **Home page**: Cluttered ListView with too many sections, no visual hierarchy
- **Theme**: Duolingo green clone — needs premium Lusion-inspired identity
- **No empty states, no loading animations, no personality**

---

## Phase 1: Identity & Polish (Week 1)

### 1A. Splash Screen & App Identity
- Animated logo reveal (Rive or flutter_animate)
- Brand tagline: "Forge Your Future" with subtle particle effect
- Auto-navigate: auth check → onboarding or home

### 1B. Theme Overhaul — Lusion-Inspired Premium Dark
**Kill the Duolingo green clone.** New identity:
- **Primary**: Electric blue (#3B82F6) + Deep violet (#8B5CF6)
- **Surface**: True black (#000000) with subtle blue-tinted cards (#0A0E1A)
- **Accent**: Cyan (#06B6D4) for CTAs, Gold (#F59E0B) for achievements
- **Typography**: Inter or Satoshi (bold headings, clean body)
- **Cards**: Glassmorphism with backdrop blur + subtle borders
- **Spacing**: 16px grid, generous whitespace
- **Border radius**: 20-24px (soft, modern)

### 1C. Micro-interactions & Haptics
- Every tap → subtle haptic + scale animation
- Page transitions → smooth slide + fade
- List items → staggered fade-in on scroll
- Achievement unlock → particle burst + confetti
- Level up → full-screen celebration with Rive animation

---

## Phase 2: Auth System (Week 1-2)

### 2A. Auth Flow (Duolingo-inspired, Gen Z optimized)
**Methods supported:**
1. **Magic Link (Email)** — primary, zero-friction
2. **Google Sign-In** — one tap
3. **Apple Sign-In** — required for iOS
4. **Continue as Guest** — skip auth, create local profile, prompt later

**Flow:**
```
Splash → Auth Gate
  ├─ Has session? → Home
  └─ No session? → Welcome Screen
       ├─ "Continue with Google" (large button, Google logo)
       ├─ "Continue with Apple" (large button, Apple logo)
       ├─ "Continue with Email" (magic link input)
       └─ "Maybe Later" (small text, creates local profile)
```

### 2B. Welcome Screen Design
- Full-screen gradient (deep blue → violet)
- Animated illustration (student with rocket/book)
- "Forge Your Future" headline
- "Join 50K+ students building their dream profile" social proof
- 3 auth buttons stacked vertically
- "By continuing, you agree to our Terms" footer

### 2C. Email Magic Link Screen
- Clean email input with animated underline
- "Send Magic Link" button
- Success state: "Check your email" with envelope animation
- 60s countdown to resend

---

## Phase 3: Onboarding Overhaul (Week 2)

### 3A. New Onboarding — 5 Steps, Not 10
**Cut from 10 to 5 essential steps:**
1. **Welcome & Goal** — "What brings you here?" (3 cards: College Prep / Scholarship / Both)
2. **Target Schools** — Search/select universities (with logos, not text chips)
3. **Your Story** — Quick profile: name, grade, interests (visual selectors)
4. **Your Schedule** — School days + available hours (slider, not text)
5. **Launch!** — "Your forge is ready" + first XP reward animation

### 3B. Onboarding UI/UX
- Full-screen pages with illustrations (not text walls)
- Horizontal swipe between steps (not vertical scroll)
- Animated progress dots (not a bar)
- Each step: illustration top, question middle, action bottom
- Skip option on every step
- Confetti on completion

### 3C. Post-Onboarding: First Mission
- Immediately show "Your first mission" card
- XP reward for completing onboarding (+100 XP)
- "Start Your First Focus Session" CTA

---

## Phase 4: Home Page Redesign (Week 2-3)

### 4A. New Layout Structure
```
┌─────────────────────────┐
│  Profile avatar  |  ⚡XP  |  💎Gems  │  ← Header bar
├─────────────────────────┤
│  ╔═══════════════════╗  │
│  ║  Level Ring +     ║  │  ← Hero card (gradient)
│  ║  Progress bar     ║  │
│  ║  🔥 Streak count  ║  │
│  ╚═══════════════════╝  │
├─────────────────────────┤
│  "What's your goal?"    │  ← Daily focus prompt
│  [Focus Session] [Quest]│
├─────────────────────────┤
│  Today's Missions        │  ← Compact mission cards
│  ┌────┐ ┌────┐ ┌────┐  │
│  │ ✍️ │ │ 📚 │ │ 🏃 │  │
│  └────┘ └────┘ └────┘  │
├─────────────────────────┤
│  Weekly Progress         │  ← Calendar heatmap
│  ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪      │
├─────────────────────────┤
│  League Standing         │  ← League card
│  🥇 #3 Bronze League    │
└─────────────────────────┘
```

### 4B. Design Principles
- **Maximum 4 visible sections** — force priority
- **Each section = 1 clear action**
- **Generous padding** — 20px between sections
- **Card-based** — every section in a rounded card
- **No emoji for icons** — use proper Feather/Phosphor icons
- **Gradient accents** — not flat colors
- **Bottom nav**: Home | Missions | Profile | Shop

---

## Phase 5: Screen-by-Screen Polish (Week 3)

### 5A. Profile Screen
- Large avatar with glow ring
- XP progress ring (animated)
- Stats grid (missions done, streak, rank)
- Badge showcase (horizontal scroll)
- "Edit Profile" floating action button

### 5B. Missions Screen
- Card stack (not list) — swipeable
- Each card: icon, title, reward, progress bar
- Filter tabs: All | Daily | Weekly | Special
- Completion animation: checkmark + XP fly

### 5C. Leagues Screen
- Tier badge (large, animated)
- Leaderboard list with avatars
- Promotion/demotion zone indicator
- Season timer countdown

### 5D. Achievements Screen
- Grid of badge cards
- Locked: grayscale + lock icon
- Unlocked: colored + glow effect
- Tap to see details + date earned

---

## Technical Implementation

### New Packages Needed
- `flutter_animate` (already installed)
- `rive` — for splash animation
- `lottie` — for empty states and celebrations
- `cached_network_image` — for school logos
- `shimmer` — for skeleton loading states
- `gap` — for consistent spacing
- `google_fonts` — Inter font family

### File Structure
```
lib/
  core/
    theme/          → Overhaul app_theme.dart
    widgets/        → Add: glass_card, gradient_button, animated_counter, 
                      particle_effect, skeleton_loader, empty_state
    auth/           → NEW: auth_service, auth_providers, auth_models
    splash/         → NEW: splash_screen
  features/
    auth/           → NEW: login_screen, magic_link_screen, welcome_screen
    onboarding/     → REWRITE: new 5-step flow with illustrations
    home/           → REWRITE: new layout
    ... (existing features stay, just polish UI)
```

### Database Changes
- Add `users` table (id, email, name, avatar_url, auth_provider, created_at)
- Add `sessions` table (user_id, token, expires_at)
- Link existing profile data to user_id

---

## Priority Order
1. **Theme overhaul** (biggest visual impact, do first)
2. **Splash screen** (app identity)
3. **Auth system** (required for multi-device)
4. **Onboarding rewrite** (first impression)
5. **Home page redesign** (daily experience)
6. **Screen polish** (iterative improvement)

---

## What We're NOT Doing
- No backend API yet (keep local-first)
- No real Supabase auth (use mock/local for now, wire real later)
- No payment system
- No social features (those come later)
