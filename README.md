# ProfileForge

**ProfileForge** is a comprehensive student profile builder and university admissions preparation app built with Flutter and Python (FastAPI).

## Features

- **12-Screen Onboarding Flow** — Collects academic profile, activities, goals, schedule, and university targets
- **Gamification Engine** — XP system, streaks, missions, skins/avatars, leaderboards
- **University Matcher** — AI-powered admissions probability calculator
- **Essay Coach** — AI-assisted essay writing with review feedback
- **Opportunity Discovery** — Free APIs for NGOs, competitions, nearby places, scholarships
- **Chat Assistant** — Real-time AI chat for guidance
- **10 Indian Languages** — i18n infrastructure ready (Hindi, Tamil, Telugu, Bengali, Marathi, Gujarati, Kannada, Malayalam, Punjabi)

## Architecture

```
lib/
├── core/           # Cross-cutting concerns (errors, themes)
├── data/           # Static data (universities, activities)
├── db/             # Drift database (tables, DAOs, migrations)
├── models/         # Data models (freezed/generated)
├── providers/      # Riverpod state management (feature-based)
├── services/       # Business logic (gamification, admissions, AI)
├── ui/
│   ├── screens/    # Feature screens (onboarding, home, profile, etc.)
│   ├── widgets/    # Reusable UI components
│   └── theme/      # AppTheme, colors, spacing
backend/
├── server.py       # FastAPI application
├── config.py       # Environment configuration
├── services/       # Database, chat, AI services
└── scripts/        # Utilities
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3.44, Riverpod, Drift, Google Fonts |
| Backend | Python 3.11, FastAPI, aiosqlite, Pydantic |
| CI/CD | GitHub Actions (matrix builds, coverage, pytest) |
| Linting | flutter_lints, Ruff, Black, mypy |

## Getting Started

### Prerequisites

- Flutter SDK 3.44+
- Python 3.11+
- Git

### Frontend

```bash
cd profileforge
flutter pub get
flutter gen-l10n
flutter run
```

### Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env  # configure SECRET_KEY, DATABASE_URL, etc.
python server.py
```

## Environment Variables

### Backend (`backend/.env`)

```env
SECRET_KEY=your-secret-key-here
ALLOWED_ORIGINS=https://yourdomain.com
DATABASE_URL=sqlite+aiosqlite:///./profileforge.db
OPENAI_API_KEY=sk-...
```

### Flutter Build (`--dart-define`)

```bash
flutter build apk --dart-define=API_BASE_URL=https://api.yourdomain.com
```

## CI/CD

GitHub Actions workflow (`.github/workflows/build.yml`) runs on every PR/push:

1. **lint-and-test** — `flutter analyze`, `flutter test --coverage`, backend `pytest`
2. **build-matrix** — Debug/Release APKs + AABs on `stable` & `beta` Flutter channels
3. **backend-test** — Python unit tests

Dependabot (`.github/dependabot.yml`) creates weekly PRs for Flutter, Python, and GitHub Actions dependencies.

## Project Structure

```
profileforge/
├── lib/                    # Flutter app
├── backend/                # FastAPI backend
├── .github/
│   ├── workflows/          # CI/CD pipelines
│   └── dependabot.yml      # Auto-update config
├── l10n.yaml               # i18n config
├── analysis_options.yaml   # Linter rules
├── pubspec.yaml            # Flutter deps
└── README.md               # This file
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Run `flutter analyze && flutter test` and `ruff check backend/`
4. Submit a PR

## License

MIT License — see LICENSE file for details.

---

*Built with ❤️ for students everywhere.*