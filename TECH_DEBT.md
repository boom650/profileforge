# ProfileForge — TECH_DEBT

| ID | Item | Impact | Plan |
|----|------|--------|------|
| TD-1 | Legacy Hive `Profile` model coexists with new Drift layer | Dual source of truth | Migrate callers to Drift; remove Hive |
| TD-2 | No golden/integration tests yet | Visual regressions unseen | Add in CI after H1–H8 land |
| TD-3 | Google Maps/Places not wired (no API key) | H11 blocked | Add secret in CI; implement adapter |
| TD-4 | No backend yet (H9) | Buddy/Teams sync offline-only | Build REST/WS adapter behind interface |
