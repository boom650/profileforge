# ProfileForge Master Execution Plan — July 7, 2026 Night Shift
## Deadline: 6:30 AM IST

---

## PHASE 1: BACKEND STABILITY (1:00 - 2:00 AM)
### 1.1 Backend Server Fixes
- [x] Server starts (51 routes, health OK)
- [x] 39/39 tests pass
- [x] Bridge server starts
- [ ] Fix deprecation warnings (on_event → lifespan)
- [ ] Add proper error handling to all endpoints
- [ ] Ensure all DB tables create properly on first run
- [ ] Add CORS headers for mobile app
- [ ] Test all CRUD endpoints with curl

### 1.2 AI Integration
- [ ] Make /api/chat endpoint functional (connect to Hermes)
- [ ] Make /api/evaluate/text functional (essay evaluation)
- [ ] Make /api/ai/tasks/generate functional
- [ ] Ensure chat maintains conversation history
- [ ] Test AI responses with real prompts

### 1.3 Database & Services
- [ ] Verify all service imports work
- [ ] Test GamificationService persistence
- [ ] Test XP award system
- [ ] Test mission generation
- [ ] Test streak tracking
- [ ] Test skin unlock system

---

## PHASE 2: FRONTEND FIXES (2:00 - 3:30 AM)
### 2.1 Onboarding Improvements
- [ ] Better welcome screen with animated hero
- [ ] Streamlined quick profile (fewer fields, better UX)
- [ ] Smart goals screen with AI suggestions
- [ ] Better activity inventory with categories
- [ ] Improved school timetable with time picker
- [ ] Smart free slots calculator
- [ ] School frequency with visual calendar
- [ ] Animated roadmap with milestones

### 2.2 Dashboard Tab
- [ ] Real-time XP display with progress bar
- [ ] Streak ring animation fix
- [ ] Mission cards with completion toggle
- [ ] Opportunity feed with real data
- [ ] Quick actions section
- [ ] Weekly progress summary

### 2.3 Missions Tab
- [ ] Active missions with progress tracking
- [ ] Completed missions history
- [ ] Mission categories (academic, EC, research, social)
- [ ] XP reward display
- [ ] Mission detail view

### 2.4 Opportunities Tab
- [ ] Search and filter interface
- [ ] Map view with location markers
- [ ] NGO opportunities from NGO Darpan
- [ ] ATL Lab finder
- [ ] Competition calendar
- [ ] Save and apply functionality

### 2.5 Courses Tab
- [ ] Course catalog with search
- [ ] Enrollment flow
- [ ] Certificate upload
- [ ] Progress tracking
- [ ] Completion certificates

### 2.6 Skins Tab
- [ ] Skin collection grid
- [ ] Equipped skin display
- [ ] Unlock animation
- [ ] Skin store / preview
- [ ] Badge collection

### 2.7 Profile Tab
- [ ] Student profile display
- [ ] Admissions probability radar
- [ ] Settings and preferences
- [ ] Data export
- [ ] Privacy controls

---

## PHASE 3: NEW FEATURES (3:30 - 5:00 AM)
### 3.1 AI Essay Coach (NEW)
- [ ] Common App prompt selector
- [ ] Essay structure analyzer
- [ ] Real-time feedback on drafts
- [ ] Story suggestion engine
- [ ] Pitfalls checklist

### 3.2 Spike Framework (NEW)
- [ ] Spike identification from activities
- [ ] Uniqueness scoring
- [ ] Improvement suggestions
- [ ] Visual spike profile

### 3.3 University Matcher (NEW)
- [ ] University database (US/UK/Canada/AU/EU)
- [ ] Admission probability per university
- [ ] Fit scoring (major, location, cost)
- [ ] Application deadline tracker

### 3.4 Weekly Targets System (NEW)
- [ ] Auto-generated weekly goals
- [ ] Research paper milestones
- [ ] Progress tracking
- [ ] Streak bonus for completion

### 3.5 Notification System
- [ ] Daily reminder notifications
- [ ] Streak protection alerts
- [ ] Deadline reminders
- [ ] New opportunity alerts

---

## PHASE 4: POLISH & TESTING (5:00 - 6:30 AM)
### 4.1 UI Polish
- [ ] Consistent color theme
- [ ] Smooth animations
- [ ] Loading states
- [ ] Error states
- [ ] Empty states
- [ ] Responsive layout

### 4.2 Testing
- [ ] Backend endpoint tests
- [ ] Frontend widget tests
- [ ] Integration tests
- [ ] Performance check

### 4.3 Documentation
- [ ] Update README
- [ ] API documentation
- [ ] Setup instructions

---

## EXECUTION STRATEGY
- Run 3 parallel subagents for different phases
- Main thread handles critical fixes and coordination
- Test after each phase completion
- Document all changes
