# Premium App Auth/Onboarding/UI Research — ProfileForge Reference

## 1. DUOLINGO

### Authentication Flow
1. **Landing Screen**: Animated Duo owl + "Get Started" CTA + "I Already Have an Account" link
2. **Email/Social Choice Screen**: 
   - Google (prominent, white button with G logo)
   - Apple (prominent, white button with Apple logo)
   - Email (secondary button, green outline)
   - Phone number (tertiary option, text link)
3. **Email Path**: Email input → password (or magic link) → account created
4. **Phone Path**: Country code selector → phone number → SMS OTP → done
5. **Social Path**: Native OS OAuth sheet → instant account creation → no password needed
6. **Key**: Auth happens AFTER onboarding starts (not before). You sign up for "what language?" first, auth is the last step.

### Onboarding Wizard (THE GOLDS STANDARD)
1. **"What language do you want to learn?"** — Grid of flag icons with language names. Tappable cards with bounce animation on select.
2. **"Why are you learning?"** — Options: School, Travel, Career, Brain Training, etc. Cards with emoji + text. Tap to select with satisfying fill animation.
3. **"How much do you know?"** — Beginner / Intermediate / Advanced. Three cards with difficulty indicators. New to language = green path; some knowledge = orange assessment.
4. **"What's your daily goal?"** — Casual (5 min), Regular (10 min), Serious (15 min), Intense (20 min). Each shows estimated XP/week. Haptic feedback on selection.
5. **"How did you hear about us?"** — Quick selection (optional, skippable).
6. **Trial lesson** — Immediately drops into a 2-3 min interactive lesson BEFORE requiring auth. Teaches 2-3 words. Massive dopamine hit from first interaction.
7. **Auth prompt** — "Save your progress!" → Google/Apple/Email/Phone auth. By now they're invested.

### Personalization From First Session
- **Streak tracking** begins from day 1 (even before full account)
- **XP system** visible immediately after trial lesson
- **League** assignment based on first week performance
- **Adaptive difficulty** adjusts based on correct/incorrect ratio
- **Character voices** personalized (same voice across sessions)
- **Push notification timing** personalized to user's active hours

### UI Patterns
- **Color Palette**: 
  - Primary Green: `#58CC02` (success, CTAs, streaks)
  - Secondary Green: `#89E219` (progress bars, active states)
  - Dark Green: `#4CAF50` (darker accents)
  - White: `#FFFFFF` (backgrounds, cards)
  - Light Gray: `#F7F7F7` (screen backgrounds)
  - Red: `#FF4B4B` (errors, streak breaks)
  - Orange: `#FF9600` (warnings, XP counters)
  - Blue: `#1CB0F6` (links, info)
  - Purple: `#CE82FF` (premium, streak freezes)
  - Gold: `#FFC800` (super, achievements)
  - Text: `#3C3C3C` primary, `#777777` secondary
  - Dark mode: `#131F24` background, `#1A2A31` cards
- **Animations**: 
  - Spring physics on button presses (300ms, 0.5 damping)
  - Bounce on correct answer (scale 1.0 → 1.1 → 1.0)
  - Shake on wrong answer (horizontal oscillation, 200ms)
  - Progress bar fills with easing (ease-out)
  - Lottie animations for character reactions
  - Confetti particle burst on lesson complete
  - Streak fire animation grows with streak count
  - XP counter roll-up animation
  - Screen transitions: slide + fade (300ms, curves.out)
- **Haptics**: Light impact on taps, medium on selections, success haptic on correct answers, notification haptic on streak milestone
- **Typography**: Nunito Sans (rounded, friendly). Headlines 24-32sp bold. Body 16sp regular. Small caps for labels.
- **Cards**: 12-16px border radius, subtle shadow (0 2 8 rgba(0,0,0,0.1)), white on gray bg

### Gamification Visuals
- **Streaks**: Fire emoji that grows from small flame → roaring fire at 365. Animated counter. Streak Freeze shield icon.
- **XP**: Yellow/orange badge with number. Animated counter rolls up. Weekly XP in bar chart.
- **Leagues**: Bronze/Silver/Gold/Platinum/Diamond/Master/Grandmaster. Badge icons with league colors. Animated promotion/demotion.
- **Hearts**: Red hearts, refill over time or earn. Visual depletion.
- **Achievements/Badges**: Circular medal icons with glow effects. New badge = celebration animation.
- **Leaderboard**: Card-based with your position highlighted. Competitor avatars with crowns.
- **Mascot (Duo)**: Animated owl reacts to progress. Sleeps when streak breaks. Celebrates milestones.

---

## 2. LINEAR APP

### Authentication Flow
1. **Landing Page**: Clean dark hero with product screenshot + "Get Started" CTA
2. **Email input**: Single field + "Continue with email" button (no password visible)
3. **Magic link sent**: "Check your email" screen with mailbox animation
4. **Click link → auto-authenticated**: No password ever set
5. **Alternative**: Google OAuth for quick join
6. **Workspace creation**: "What's your team name?" → invite members (optional, skippable)
7. **Key**: Zero friction. No passwords. Magic link = premium feel. Auth takes 10 seconds total.

### Onboarding
1. **"Create your first project"** — Template picker (Bug tracking, Feature tracking, Sales CRM, Custom)
2. **"Import from..."** — Jira, GitHub, Asana, Trello import wizard (optional)
3. **"Set up your workflow"** — Drag to reorder: Backlog → Todo → In Progress → Done (pre-filled, editable)
4. **"Invite your team"** — Email input + role selection (optional, can skip)
5. **First issue creation** — Guided: create issue, assign label, change status. Micro-tutorial.
6. **Total steps**: 3-4 before first real use. Each step has "Skip" option.

### Premium Dark UI Patterns
- **Color Palette**:
  - Background: `#0A0A0B` (near-black, not pure black)
  - Surface: `#141415` (cards, panels)
  - Elevated: `#1C1C1E` (hover states, modals)
  - Border: `#2A2A2C` (subtle dividers)
  - Text Primary: `#EDEDED` (slightly warm white)
  - Text Secondary: `#8A8A8E` (muted gray)
  - Accent: `#5E6AD2` (Linear purple-blue)
  - Success: `#4ADE80` (green)
  - Warning: `#FBBF24` (amber)
  - Error: `#EF4444` (red)
  - Priority colors: Urgent `#EF4444`, High `#FF8C00`, Medium `#FFC107`, Low `#5E6AD2`, No priority `#6B7280`
- **What Makes It Feel Premium**:
  - **Typography**: Inter font. Precise weight hierarchy. Tight letter-spacing on uppercase labels (-0.02em).
  - **Spacing**: Consistent 8px grid. Generous whitespace. Nothing feels cramped.
  - **Micro-interactions**: Keyboard shortcut hints everywhere. Command palette (⌘K). Smooth 200ms transitions.
  - **Borders**: 1px `#2A2A2C` — barely visible but creates structure. Never 2px+.
  - **Shadows**: Almost none. Depth through color elevation, not drop shadows.
  - **Icons**: Custom SVG icon set. Consistent 16px/20px sizes. Stroke width 1.5.
  - **Focus rings**: Subtle purple outline on keyboard focus (accessibility + premium feel)
  - **Scrolling**: Smooth momentum scrolling. No jarring snap points.
  - **Empty states**: Beautiful illustrations + helpful CTAs, never blank.
  - **Animations**: 150-200ms ease-out for all state changes. Never bouncy. Professional restraint.
  - **Keyboard-first**: Every action has a keyboard shortcut. This IS the premium signal.
  - **Density**: Compact but readable. Information-dense without feeling cluttered.
- **Dark Mode Specifics**:
  - Never pure `#000000` — always `#0A0A0B` or darker grays
  - No harsh white text — `#EDEDED` or `#F5F5F5`
  - Subtle borders on ALL surfaces
  - Hover states: `+4%` lighter than base
  - Active states: `+8%` lighter than base
  - Scrollbar: 6px wide, dark gray, appears on hover

---

## 3. NOTION

### Authentication Flow
1. **Landing**: Hero with product demo GIF + "Get Notion free" CTA
2. **Email input**: Single field → "Continue with email"
3. **Magic link**: Email sent with one-click sign-in link
4. **Alternative options** (shown as secondary buttons):
   - Continue with Google
   - Continue with Apple
   - Continue with Microsoft
5. **Onboarding after auth** (not before):
   - "How do you want to use Notion?" (Personal, School, Teams)
   - "What should we call you?" (display name)
   - "Pick a theme" (Light / Dark / System)

### Onboarding / Workspace Setup
1. **"Who's on your team?"** — Invite by email (skippable for personal use)
2. **"What's your workspace name?"** — Company/school name
3. **Template gallery**: Choose starting template:
   - Blank page
   - Meeting notes
   - Project tracker
   - Personal wiki
   - Class notes
   - Reading list
4. **Guided tour** (optional tooltip tour):
   - "This is your sidebar" → "Click + to create a page" → "Drag to reorder" → "Type / for commands"
5. **Block-based editing**: First interaction is creating content via slash commands
6. **Key**: Workspace setup is minimal. Real learning happens through usage + contextual tooltips.

### UI Patterns
- **Color Palette**:
  - Light: `#FFFFFF` bg, `#F7F6F3` secondary bg, `#37352F` text
  - Dark: `#191919` bg, `#202020` secondary bg, `#FFFFFF` text
  - Accent: `#2EAADC` (blue links), `#E16259` (red), `#DFAB01` (yellow)
  - Notion black: `#37352F` (their signature near-black)
  - Gray scale: 7 shades from `#9B9A97` to `#E3E2E0`
- **Typography**: System font stack (`-apple-system, BlinkMacSystemFont, "Segoe UI"`). Monospace for code: `"SFMono-Regular"`.
- **Card/Block Style**: 
  - Hover: gray outline appears
  - Selected: blue outline
  - Drag handle: 6 dots icon on left, appears on hover
  - No drop shadows (flat design)
- **Animations**: Minimal. Page transitions are instant. Sidebar collapse: 200ms ease. Typing is immediate.
- **What Makes It Feel Premium**: Content-first design. Almost zero UI chrome. The workspace disappears and content is king. Slash commands feel like a power tool.

---

## 4. HEADSPACE / CALM

### Headspace Authentication Flow
1. **Splash screen**: Calming gradient animation (orange/peach tones) + "Start your free trial"
2. **Email/social choice**:
   - Continue with Google
   - Continue with Apple
   - Continue with Facebook
   - Continue with Email
3. **Post-auth onboarding**:
   - "What brings you here?" — Stress, Sleep, Focus, Anxiety, Relationships, Self-Esteem
   - "How experienced are you with meditation?" — Beginner, Intermediate, Advanced
   - "How do you feel right now?" — Sliding scale or emoji picker
   - "Set your daily reminder" — Time picker (optional)
4. **First meditation**: 1-2 min breathing exercise. Guided by voice. Immediate calm.
5. **Paywall**: After first session, "Unlock full library" → subscription screen

### Calm Authentication Flow
1. **Splash**: Nature scene animation (rain, forest, waves) + "Begin"
2. **Email/social options**: Same as Headspace
3. **Onboarding**:
   - "What do you want to focus on?" — Sleep, Focus, Anxiety, Stress, Meditation, Music
   - "Choose your daily calm" — Pre-built program recommendation
   - "When should we remind you?" — Notification time
4. **First session**: Sleep Story or Daily Calm (3-5 min). Narrated by celebrity voice.
5. **Paywall**: After taste of content

### Retention Patterns
- **Daily streak counter** with calendar visualization
- **"X days in a row" celebration** on session complete
- **Progress trees/flowers** that grow (Headspace) — visual metaphor
- **Bedtime reminders** at user-set time
- **New content daily** (Daily Calm, Sleep Story) — creates habit
- **Social proof**: "3 million people meditated today"
- **Gentle push notifications**: "Time for your evening wind-down" (not urgent/fear-based)
- **Session history** with mood tracking (before/after)

### UI Patterns
- **Headspace Colors**:
  - Primary Orange: `#F47D31`
  - Background: `#FFF3E0` (warm cream)
  - Characters: Rounded blob characters (distinctive brand asset)
  - Dark mode: Deep navy `#1A1A2E`
  - Accent: Soft yellow, teal, coral
  - Text: `#2D2D2D` on light, `#FFFFFF` on dark
- **Calm Colors**:
  - Primary Blue: `#43B3AE` (teal)
  - Background: Nature photography dominates
  - Dark mode: `#1C2541`
  - Accent: Gold for premium, forest green
  - Text: `#333333` on light
- **Animations**: 
  - Slow, breathing-like (4-7 second cycles)
  - Nature particle effects (rain drops, fireflies)
  - Smooth fade transitions (500-800ms, longer than typical)
  - Content loading = "breathe in/breathe out" animation
  - Lottie character animations (Headspace)
- **Typography**: Headspace uses GT Walsheim (rounded, friendly). Calm uses a custom serif for headers (elegant).
- **What Makes It Feel Premium**: Slow pace. No urgency. Ambient soundscapes. Nature imagery. Everything breathes. Time feels different.

---

## 5. FOREST APP

### How It Makes Focus/Streaks Feel Rewarding
1. **Core metaphor**: Plant a virtual tree → focus for X minutes → tree grows. Break focus = tree dies.
2. **Tree selection**: Choose tree/bush species before timer. Rarer trees = longer focus. Collection = motivation.
3. **Timer flow**:
   - Select duration (25/30/45/60/90 min)
   - Select tree type
   - "Start growing" button
   - Timer starts with a small seedling animation
   - Real-time growth: seedling → sprout → small tree → full tree
   - Background: Forest scene fills as you plant more trees
4. **Streak/Forest visualization**:
   - Your focused sessions create a VIRTUAL FOREST
   - Weekly forest view: all your trees in a landscape
   - Desert (missed days) vs lush forest (consistent days) — visceral visual
   - Monthly/yearly forest overview — growth over time
5. **Rewarding mechanics**:
   - Coins earned per session → spend in "Tree Shop" on new species
   - Rare/special trees for milestones (100 sessions, 365 streak)
   - Badges: "Focused 100 hours", "7-day streak", "Forest guardian"
   - Real tree planting (partnership with Trees for the Future) — 5000 coins = 1 real tree
   - Social: See friends' forests. Team trees.
6. **Loss aversion**: Killing a tree (closing app) is emotionally devastating. Dead tree sticks around in your forest as a sad stump. Powerful motivator.

### UI Patterns
- **Color Palette**:
  - Primary Green: `#4CAF50` (tree, nature)
  - Secondary: `#8BC34A` (light green, sprouts)
  - Background: `#F1F8E9` (very light green tint)
  - Soil Brown: `#795548` (earth tones)
  - Sky Blue: `#87CEEB` (background gradient)
  - Dark mode: `#1B2A1B` (deep forest dark)
  - Dead tree: `#757575` (gray)
  - Coins: `#FFD700` (gold)
- **Animations**:
  - Tree growth: 25-90 min progressive animation
  - Seedling sway in wind (continuous subtle)
  - Rain/nature ambient effects
  - Coin counter pop when earning
  - Forest panorama: parallax scrolling on landscape
- **Typography**: Clean sans-serif. Focus on numbers (timer is HUGE). Minimal text.
- **What Makes It Feel Premium**: Physical metaphor (growing something alive). Real-world impact (real trees). Collection mechanic. Loss aversion.

---

## 6. ROBINHOOD / CASH APP

### Robinhood Auth Flow
1. **Splash**: Clean green screen + "Investing for Everyone" tagline + "Sign Up"
2. **Email input**: Single field
3. **Password creation**: Standard (Robinhood still uses passwords, unlike Linear)
4. **Phone number + SMS verification**: Required (financial app)
5. **Identity verification** (required by law):
   - Full legal name
   - Date of birth
   - Social Security Number (last 4 or full)
   - Home address
   - Citizenship
6. **Funding**: Link bank account or debit card (can skip initially)
7. **Total time**: 5-8 minutes (heaviest auth of all apps due to financial regulations)

### Cash App Auth Flow
1. **Splash**: Dark screen + $ Cashtag visual + "Sign Up"
2. **Phone number**: Primary auth method (not email)
3. **SMS verification code**: 6-digit OTP
4. **Cashtag creation**: Choose unique $YourName identifier
5. **Optional**: Link bank, add cash, verify identity
6. **Much lighter than Robinhood**: No identity verification required for basic use

### Premium Dark UI Patterns (Both Apps)

**Robinhood**:
- **Color Palette**:
  - Background: `#040D14` (very dark blue-black)
  - Surface: `#0F1A23` (cards)
  - Green (gains): `#00C805` (Robinhood's signature green)
  - Red (losses): `#FF5000`
  - Text Primary: `#FFFFFF`
  - Text Secondary: `#9DA3A6`
  - Divider: `#1E2D3A`
  - Accent: `#00C805` (everything ties back to green)

**Cash App**:
- **Color Palette**:
  - Background: `#000000` (pure black, OLED-friendly)
  - Surface: `#1A1A1A`
  - Primary Green: `#00D632` (Cash App green)
  - Text: `#FFFFFF` primary, `#6B6B6B` secondary
  - Purple gradient: `#7B3FE4` → `#A855F7` (Bitcoin/crypto)
  - Gold: `#F7931A` (Bitcoin accent)
  - Card: `#252525`

### Gen Z Design Signals
- **Minimal text**: Numbers speak. "$24.50" not "Your balance is twenty-four dollars and fifty cents."
- **Instant gratification**: Balance updates in real-time. Animations on every transaction.
- **Social features**: Send/receive feels like texting. Cashtags = social handles.
- **Gamification**: 
  - Stock discovery = swipeable cards (Tinder-like)
  - "Everyone's investing in..." social proof
  - Round-ups for investing (micro-investing)
  - "Streak" of investing days
  - Rewards for referrals (free stock)
- **Animation style**:
  - Number counters animate up/down
  - Stock charts: smooth path drawing animation
  - Transaction complete: satisfying "checkmark" pop
  - Pull to refresh: custom animation
  - Stock selection: card flip animation
  - Portfolio value: large number with smooth counting animation
- **Haptics**: Impact on buy/sell confirmation. Success on transaction complete. Notification on price alerts.
- **Typography**: 
  - Robinhood: Robinhood Sans (custom). Clean, modern.
  - Cash App: Circular (Geometric sans). Bold for money amounts.
  - Both: Numbers are HUGE. Dollar signs slightly smaller.

---

## CROSS-APP PATTERNS FOR PROFILEFORGE

### What ALL Premium Apps Share
1. **Auth AFTER onboarding** (Duolingo, Headspace) or **ultra-minimal auth** (Linear, Cash App)
2. **Social login prominent** (Google/Apple always first)
3. **Magic links over passwords** when possible (Linear, Notion)
4. **3-5 onboarding steps MAX** before first value delivery
5. **Skip always available** (never force, always nudge)
6. **First action = first reward** (Duolingo lesson, Forest tree, Cash App $5)
7. **Dark mode as primary** (Linear, Robinhood, Cash App)
8. **8px grid** for all spacing
9. **Spring animations** (300ms, 0.5 damping) for interactions
10. **Haptics on every meaningful action**

### Specific Recommendations for ProfileForge

**Auth Flow (Duolingo-inspired)**:
1. Start with "What are you applying to?" (College, Scholarship, Job, etc.)
2. Profile builder first (name, grade, school)
3. Quick taste of the app (see dashboard with placeholder missions)
4. THEN "Save your progress" → Google/Apple/Email auth
5. Phone auth optional (not required)

**Onboarding (5 steps max)**:
1. "What are you applying to?" — Cards with icons
2. "What year are you?" — Freshman → Senior
3. "What's your GPA range?" — Ranges (for personalization)
4. "What matters most to you?" — Academics, Extracurriculars, Leadership, Service
5. "Pick your style" — Avatar/persona selection (gamification hook)
6. Drop into dashboard with first mission ready

**Dark Theme (Linear-inspired)**:
- Background: `#0A0A0B`
- Surface: `#141415`
- Primary: `#58CC02` (Duolingo green — your stated direction)
- Accent: `#FFC800` (gold for XP/rewards)
- Error: `#FF4B4B`
- Text: `#EDEDED` primary, `#8A8A8E` secondary
- Never pure black, never pure white

**Premium Feel Checklist**:
- [ ] Custom font (not system default)
- [ ] 8px grid spacing
- [ ] 1px borders (never more)
- [ ] Spring animations on all interactions
- [ ] Haptics on key actions
- [ ] Command palette (⌘K)
- [ ] Keyboard shortcuts displayed
- [ ] Loading states = meaningful animation (not spinner)
- [ ] Empty states = illustration + CTA
- [ ] Confetti on milestones
- [ ] No pure black/white
- [ ] Smooth scroll everywhere
