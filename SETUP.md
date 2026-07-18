# ProfileForge — Setup, Configuration & Continuous Improvement

## What this is
ProfileForge is a Flutter app (gamified college-admissions profile builder) with a
**continuous-improvement pipeline**: research → knowledge graph → auto-proposed app
features → CI build → published APK. All driven from this Termux workspace.

## Repository
`https://github.com/boom650/profileforge`

## Prerequisites (on this machine — Termux/Android)
- `git`, `gh` (authenticated as boom650), `python3`, `pip`
- GitHub CLI: `gh auth login` already done
- Network access (HN, GitHub API, arXiv Export, OpenAlex all verified working)
- NO local Flutter SDK — builds run on GitHub Actions CI only

## 1. Clone & run locally (optional — needs Flutter SDK)
```bash
git clone https://github.com/boom650/profileforge
cd profileforge
flutter pub get
flutter run          # needs Flutter 3.27.4 on your machine
```

## 2. Get the built APK (no Flutter needed)
Every push to `master` triggers CI and publishes a pre-release:
```bash
gh release list --limit 1
# download app-arm64-v8a-release.apk from the latest "ProfileForge APK – master"
```
Or open: https://github.com/boom650/profileforge/releases

## 3. CI pipeline (`.github/workflows/build.yml`)
Triggers: push to `master`/`main`, or manual `workflow_dispatch`.
Steps: checkout (clean) → Flutter 3.27.4 → Java 17 → `flutter create` (regenerates
canonical android/) → `pub get` → **`flutter analyze`** (gate) → **`flutter test`**
(gate) → build APK (split-per-abi) → build AAB → GitHub Release (prerelease).
**Broken code never ships** — analyze+test must pass.

## 4. Continuous improvement cycle
Files:
- `improve.py` — picks one safe feature from `IMPROVEMENTS`, writes it to `lib/`,
  commits, pushes, waits for CI. If CI is RED, it auto-reverts (master never stays red).
- `research2_engine.py` — pulls 1000+ web sources (HN) + 200 new repos.
- `research2_papers.py` — pulls 2400+ academic papers (arXiv + OpenAlex).
- `setup_engine.py` — classifies cloned repos, links skills to Hermes, writes USAGE.md.
- `ingest_graph.py` / `update_graph_research2.py` — build the knowledge graph.
- `graphify_watch.py` — live watcher; rebuilds graph when sources change.
- `query_kg.py` — query graph by keyword (app/pdf/web/agent).

Run one improvement cycle manually:
```bash
python3 improve.py
```

Schedule it (cron) to run autonomously, e.g. every 6 hours:
```bash
# via Hermes cron (recommended): create a cronjob with prompt
# "Run cd /data/data/com.termux/files/home/workspace && python3 improve.py"
# schedule: 'every 6h'
```

## 5. Knowledge graph (Graphify-Labs/graphify, persisted as JSON)
- `knowledge_graph.json` — 3,301 nodes / 3,333 edges (repos, papers, web sources, domains).
- Live watcher: `python3 graphify_watch.py` (rebuilds on source-file mtime change).
- Route "app"/"PDF"/"web"/"agent" through it via the `knowledge-graph-query` Hermes skill.

## 6. Research artifacts (gitignored — not in app repo)
- `repos/`, `repos2/` — cloned GitHub repos (357 total)
- `research1000/`, `research2/` — corpora (4,389 web + 2,413 papers)
- `mcp_config.json` — 140 MCP servers configured
- `~/.hermes/skills/` — 162 skills linked

## 7. Troubleshooting
| Symptom | Fix |
|---------|-----|
| CI red on `analyze` | `flutter create` regenerates `test/widget_test.dart`; CI deletes it post-scaffold. Don't re-add it. |
| CI red on `test` | A test failed; `improve.py` auto-reverts. Check `test/profile_test.dart`. |
| APK not in release | `fail_on_unmatched_files: false` set; check build step logs. |
| Graph empty | Run `python3 ingest_graph.py && python3 update_graph_research2.py`. |
| Watcher down | `python3 graphify_watch.py &` |

## Current app features (shipped)
- Onboarding (skip) → Home (XP chip) → Profile builder (name, goal, achievements +XP)
- **Offline PDF export** of profile (`pdf` package) → share via system sheet
- Tests: `test/profile_test.dart` (model round-trip + dedupe)
