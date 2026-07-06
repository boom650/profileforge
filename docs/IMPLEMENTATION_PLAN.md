# ProfileForge Implementation Plan
## Date: July 6, 2026

---

## 1. CURRENT STATE ASSESSMENT

### What Exists:
- 7 admissions pillars with XP tracking model (XPState, XPTransaction)
- Essay coach service with Common App prompts
- Location service (native + web stubs)
- Dashboard with missions, spikes, skins, streak system
- Onboarding flow (10 screens)
- Opportunity discovery (NGOs, competitions, places)
- Admissions probability engine

### What's Broken:
- Dashboard shows errors (need to check console logs)
- Location service exists but not wired to anything useful
- No visible XP counter on dashboard
- No research paper upload/analysis system
- No AI-powered feedback loop

---

## 2. FEATURE: RESEARCH PAPER AI REVIEW SYSTEM

### 2.1 Architecture

```
User Upload → Image/PDF Processing → Gemini API Analysis → Improvement List → User Implement → XP Award
```

### 2.2 Components to Build

#### A. Paper Upload Screen
- New screen: `lib/ui/screens/research/paper_upload_screen.dart`
- Support: Camera capture, gallery pick, PDF upload, URL input
- Use `image_picker` for camera/gallery
- Use `file_picker` for PDFs
- Store locally or in temp storage

#### B. Paper Processing Service
- New file: `lib/services/paper_review_service.dart`
- Extract text from images using Gemini Vision (OCR)
- Parse PDFs to text
- For URLs: fetch and extract content

#### C. Gemini Analysis Pipeline
- New file: `lib/services/gemini_review_engine.dart`
- Call Gemini API with structured prompt
- Analyze: structure, argument quality, evidence, writing style, citations
- Generate: specific improvement items with priority levels
- Store analysis results in local DB

#### D. Improvement Tracker
- New table: `paper_improvements` in DB
- Fields: paper_id, improvement_text, priority, status (pending/done), xp_value
- Each improvement = a "mission" that grants XP when completed

#### E. XP Award System
- New service: `lib/services/paper_xp_service.dart`
- Award XP per improvement completed
- Bonus XP for full paper completion
- Map improvements to admissions pillars (research, academics)

### 2.3 Database Schema

```sql
CREATE TABLE papers (
  id TEXT PRIMARY KEY,
  title TEXT,
  original_text TEXT,
  image_path TEXT,
  pdf_path TEXT,
  url TEXT,
  created_at TEXT,
  analysis_status TEXT -- pending/analyzed/reviewed
);

CREATE TABLE paper_analyses (
  id TEXT PRIMARY KEY,
  paper_id TEXT,
  overall_score REAL,
  structure_score REAL,
  argument_score REAL,
  evidence_score REAL,
  writing_score REAL,
  summary TEXT,
  created_at TEXT
);

CREATE TABLE paper_improvements (
  id TEXT PRIMARY KEY,
  paper_id TEXT,
  analysis_id TEXT,
  improvement_text TEXT,
  category TEXT, -- structure/argument/evidence/writing/citation
  priority INTEGER, -- 1-5
  xp_value INTEGER,
  status TEXT, -- pending/in_progress/done
  completed_at TEXT,
  FOREIGN KEY (paper_id) REFERENCES papers(id)
);
```

### 2.4 Gemini Prompt Template

```
You are an expert college admissions essay reviewer. Analyze this research paper/essay:

[Paper Content]

Provide:
1. Overall score (0-100)
2. Structure analysis (intro, body, conclusion quality)
3. Argument quality (thesis strength, logic flow)
4. Evidence usage (citations, data, examples)
5. Writing style (clarity, grammar, engagement)
6. Specific improvements (prioritized list, each with:
   - What to improve
   - Why it matters
   - How to fix it
   - XP value (10-50 based on difficulty))

Format as JSON.
```

### 2.5 UI Flow

1. **Upload Screen** → User captures/uploads paper
2. **Processing Screen** → "Analyzing your paper..." with progress
3. **Results Screen** → Score breakdown + improvement list
4. **Mission Board** → Improvements appear as missions
5. **Completion** → XP awarded, stats updated

### 2.6 Files to Create

```
lib/ui/screens/research/
  paper_upload_screen.dart
  paper_processing_screen.dart
  paper_results_screen.dart

lib/services/
  paper_review_service.dart
  gemini_review_engine.dart
  paper_xp_service.dart

lib/models/
  paper.dart
  paper_analysis.dart
  paper_improvement.dart

lib/db/tables/
  paper_table.dart
  paper_analysis_table.dart
  paper_improvement_table.dart

lib/providers/
  paper_providers.dart

lib/ui/widgets/
  paper_score_card.dart
  improvement_tile.dart
  upload_progress_indicator.dart
```

---

## 3. FEATURE: XP COUNTER & VISIBILITY

### 3.1 Current State
- XPState model exists with totalXP, pillarXP, levels
- No visible counter on dashboard

### 3.2 Components to Build

#### A. XP Counter Widget
- New file: `lib/ui/widgets/xp_counter_widget.dart`
- Show total XP, current level, progress to next
- Animated counter with pulse effect
- Pillar breakdown on tap

#### B. XP Provider
- New file: `lib/providers/xp_provider.dart`
- Stream XPState from DB
- Handle XP transactions

#### C. Dashboard Integration
- Add XP counter to dashboard header
- Add level badge next to profile
- Show recent XP gains in activity feed

### 3.3 Files to Create/Modify

```
lib/ui/widgets/xp_counter_widget.dart (NEW)
lib/providers/xp_provider.dart (MODIFY)
lib/ui/screens/home/home_screen.dart (MODIFY - add XP counter)
```

---

## 4. FEATURE: LOCATION ACCESS FIX

### 4.1 Current State
- Location service implementations exist (native + web)
- Location permission prompt exists in home_screen.dart
- Not connected to opportunity discovery

### 4.2 What's Broken
- Location permission prompt doesn't actually fetch location
- Opportunities tab doesn't use location data
- No reverse geocoding for display

### 4.3 Fix Plan

#### A. Wire Location to Dashboard
- After permission granted, call `locationServiceProvider.getCurrentLocation()`
- Store location in user profile
- Show location on dashboard

#### B. Connect to Opportunity Discovery
- Pass location to NGO service
- Pass location to Overpass API
- Pass location to Nominatim for reverse geocoding
- Sort opportunities by distance

#### C. Location Display
- Show city/state on dashboard
- Show distance on opportunity cards
- Allow manual city search as fallback

### 4.4 Files to Modify

```
lib/ui/screens/home/home_screen.dart (MODIFY - wire location button)
lib/services/opportunity_feed.dart (MODIFY - use location)
lib/services/ngo_darpan_service.dart (MODIFY - add location param)
lib/services/overpass_service.dart (MODIFY - add location param)
lib/providers/app_providers.dart (MODIFY - add location state)
```

---

## 5. FEATURE: DASHBOARD ERROR FIX

### 5.1 Debug Steps
1. Check Flutter console for error messages
2. Identify which widget/provider is failing
3. Check data availability (empty states)

### 5.2 Common Issues to Check
- Provider not initialized
- Empty data causing null errors
- Missing imports
- Widget tree rebuild issues

### 5.3 Files to Check

```
lib/ui/screens/home/home_screen.dart
lib/providers/app_providers.dart
lib/services/gamification.dart
lib/services/opportunity_feed.dart
```

---

## 6. IMPLEMENTATION ORDER

### Phase 1: Foundation (Day 1-2)
1. Fix dashboard errors (debug + fix)
2. Fix location wiring (permission → fetch → display)
3. Add XP counter to dashboard

### Phase 2: Paper System Core (Day 3-5)
1. Create paper upload UI
2. Create paper processing service
3. Create Gemini analysis pipeline
4. Create database tables

### Phase 3: Paper System Integration (Day 6-7)
1. Create improvement tracker
2. Wire improvements to missions
3. Wire XP awards
4. Create results UI

### Phase 4: Polish (Day 8)
1. Test full flow
2. Fix bugs
3. UI polish
4. Build APK

---

## 7. TECHNICAL REQUIREMENTS

### New Packages Needed:
- `image_picker` - camera/gallery access
- `file_picker` - PDF/file selection
- `path_provider` - local file storage
- `google_generative_ai` - Gemini API (if not already included)

### API Requirements:
- Gemini API key (user has Gemini Plus subscription)
- Internet permission for API calls
- Camera permission for photo capture

### Database Changes:
- 3 new tables (papers, analyses, improvements)
- Migration from existing schema

---

## 8. RISKS & MITIGATIONS

| Risk | Impact | Mitigation |
|------|--------|------------|
| Gemini API rate limits | Analysis delays | Queue system, retry logic |
| Large PDF processing | Memory issues | Chunk processing, limits |
| Location permission denied | No nearby opportunities | Manual city search fallback |
| Database migration fails | Data loss | Backup before migration |
| Image quality poor | Bad OCR results | Quality checks, retry |

---

## 9. SUCCESS CRITERIA

- [ ] Dashboard loads without errors
- [ ] Location shows on dashboard after permission
- [ ] Opportunities sorted by distance
- [ ] XP counter visible on dashboard
- [ ] Paper upload works (image + PDF)
- [ ] Gemini analysis produces improvements
- [ ] Improvements appear as missions
- [ ] XP awarded on completion
- [ ] Full flow tested end-to-end

---

## 10. NEXT STEPS

1. Run `flutter run` and capture console errors
2. Fix dashboard errors first
3. Wire location to dashboard
4. Add XP counter widget
5. Build paper upload screen
6. Integrate Gemini analysis
7. Test and iterate

---

*This plan is a living document. Update as implementation progresses.*
