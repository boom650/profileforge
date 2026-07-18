# ProfileForge — RESEARCH

## Corpus (in `research2/`, gitignored from app repo)
- `all_sources.json` — 4,389 web sources (HN practitioner comments, blogs).
- `papers.json` / `papers.md` — 2,413 academic papers (arXiv + OpenAlex).
- `BEST_PRACTICES.md` — synthesized Flutter/gamification/product practices.
- Knowledge graph `knowledge_graph.json` — 3,301 nodes / 3,333 edges.

## Key findings applied
- **Streaks:** grace days + freeze tokens reduce churn; celebrate recovery, not just
  continuity (Duolingo-style but humane — no guilt spiral).
- **Leagues:** weekly cohorts with promotion/demotion + shields prevent demotivation
  at bottom tiers.
- **Skins:** cosmetic progression tied to admission pillars increases long-term goals
  salience.
- **Onboarding:** collect schedule + target unis early; first 7 days predict D30.
- **Offline-first:** Drift + Workmanager; never block UI on network.

## Tools
- `research2_engine.py` (web), `research2_papers.py` (papers), `ingest_graph.py`,
  `update_graph_research2.py`, `query_kg.py` (route by app/pdf/web/agent).
