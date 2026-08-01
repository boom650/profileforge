# ProfileForge — Deferred Tasks (Require API Keys / Human Authentication)

These tasks cannot be completed without external services, API keys, or human
authentication. They are listed here for future completion.

---

## 🔐 API Key Required

### 1. Rive Animations
- **What**: Download and integrate Rive animations for onboarding/success
- **Why**: Rive community assets require Rive account to download .riv files
- **Auth needed**: Rive account (free tier available)
- **Priority**: Medium

### 2. AI Mission Generation
- **What**: Wire OpenAI/Claude API for dynamic mission generation
- **Why**: Currently uses local generation; AI would make missions more personalized
- **Auth needed**: OpenAI API key or Anthropic API key
- **Priority**: High

### 3. Cloud Sync
- **What**: Sync user data across devices via Firebase/Supabase
- **Why**: Currently local-only; cloud sync enables multi-device
- **Auth needed**: Firebase project or Supabase project
- **Priority**: Medium

### 4. Push Notifications
- **What**: Send streak reminders, mission alerts via FCM
- **Why**: Re-engage users who haven't opened the app
- **Auth needed**: Firebase Cloud Messaging setup
- **Priority**: High

### 5. Analytics Dashboard
- **What**: Track user behavior, retention, feature usage
- **Why**: Data-driven product decisions
- **Auth needed**: Firebase Analytics or Mixpanel key
- **Priority**: Medium

---

## 👤 Human Authentication Required

### 6. Apple Sign In
- **What**: Add Sign in with Apple for iOS
- **Why**: Required for iOS apps with social login
- **Auth needed**: Apple Developer account + App Store Connect
- **Priority**: High (for iOS release)

### 7. Google Sign In
- **What**: Add Sign in with Google
- **Why**: Most common social login on Android
- **Auth needed**: Google Cloud Console project
- **Priority**: High (for Android release)

### 8. Magic Link Email
- **What**: Send magic link emails for passwordless login
- **Why**: Current magic link screen exists but no email service
- **Auth needed**: SendGrid/Mailgun API key
- **Priority**: Medium

---

## 🌐 External Service Integration

### 9. University Data API
- **What**: Fetch real university admission requirements
- **Why**: Currently uses static data; real data would be more accurate
- **Auth needed**: College Board API or similar
- **Priority**: Low

### 10. Calendar Integration
- **What**: Sync deadlines with Google Calendar / Apple Calendar
- **Why**: Never miss application deadlines
- **Auth needed**: Google Calendar API / Apple EventKit
- **Priority**: Low

### 11. Social Sharing Backend
- **What**: Share progress to social media with rich previews
- **Why**: Viral growth through sharing
- **Auth needed**: Twitter/LinkedIn API keys
- **Priority**: Low

---

## 📱 Device-Specific

### 12. Biometric Authentication
- **What**: Add fingerprint/face unlock for app access
- **Why**: Privacy for sensitive admission data
- **Auth needed**: Device biometric hardware
- **Priority**: Low

### 13. Widget Support
- **What**: iOS/Android home screen widgets showing streak/progress
- **Why**: Always-visible engagement
- **Auth needed**: None (but complex implementation)
- **Priority**: Low

---

## Priority Order for Implementation

1. **AI Mission Generation** — Core differentiator
2. **Push Notifications** — Re-engagement
3. **Apple/Google Sign In** — Required for store release
4. **Cloud Sync** — Multi-device
5. **Analytics** — Data-driven decisions
6. **Magic Link Email** — Passwordless auth
7. **Rive Animations** — Premium feel
8. **University Data** — Accuracy
9. **Calendar Integration** — Convenience
10. **Social Sharing** — Growth
11. **Biometric Auth** — Privacy
12. **Widgets** — Engagement
