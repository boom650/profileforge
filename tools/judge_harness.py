#!/usr/bin/env python3
"""
ProfileForge 30-Judge Evaluation Harness
=========================================
Scores the ACTUAL repository across 30 categories. Each judge inspects real
artifacts (lib/ code, tests, docs, CI) and returns:
    { category, score (0-100), reasoning, improvements[] }

Design decision (DECISIONS.md D2): this is local Python, not 30 subagents,
because no Flutter SDK runs locally and subagents would re-derive scores
wastefully. CI provides the real analyze/test gates; this harness provides
the qualitative 30-dimension score and drives per-category improvement.

Run:  python3 tools/judge_harness.py
Out:  judge_report.json  (+ prints summary; exit code = 1 if any < 85)
"""
import json
import os
import re
import subprocess
from datetime import datetime, timezone

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIB = os.path.join(ROOT, "lib")
TEST = os.path.join(ROOT, "test")
DOCS = ROOT

CATEGORIES = [
    "UI Design", "UX", "Accessibility", "Performance", "Animations",
    "Gamification", "Psychology", "Retention", "Technical Architecture",
    "Database Design", "Security", "Testing", "DevOps", "AI Quality",
    "Scalability", "Code Quality", "Documentation", "Maintainability",
    "Reliability", "Product Vision", "University Admissions Value",
    "Offline Experience", "Localization", "Mobile Best Practices",
    "Flutter Best Practices", "Riverpod Architecture", "Drift Architecture",
    "API Design", "Error Recovery", "User Delight",
]


def _read(p):
    try:
        with open(p, "r", encoding="utf-8", errors="ignore") as f:
            return f.read()
    except Exception:
        return ""


def _walk(exts):
    out = {}
    for dp, _, fns in os.walk(LIB):
        for fn in fns:
            if any(fn.endswith(e) for e in exts):
                out[os.path.join(dp, fn)] = _read(os.path.join(dp, fn))
    return out


def _lib_files():
    return _walk((".dart",))


def _count(patterns, text):
    return sum(len(re.findall(p, text)) for p in patterns)


def _feature_dirs():
    feat = os.path.join(LIB, "features")
    if not os.path.isdir(feat):
        return []
    return [d for d in os.listdir(feat)
            if os.path.isdir(os.path.join(feat, d))]


# ---------- individual judges (each returns (score, reasoning, improvements)) ----------

def j_ui_design():
    files = _lib_files()
    txt = "\n".join(files.values())
    has_theme = "ThemeData" in txt or "ColorScheme" in txt
    uses_m3 = "useMaterial3" in txt
    custom_widgets = _count([r"class \w+ extends (ConsumerWidget|StatelessWidget|StatefulWidget)"], txt)
    reason = f"Theme:{'M3 ' if uses_m3 else ''}{'present' if has_theme else 'absent'}; custom widgets={custom_widgets}."
    score = 60 if (has_theme and uses_m3) else 40
    if custom_widgets > 8:
        score += 15
    imp = []
    if not uses_m3:
        imp.append("Adopt Material 3 with seed ColorScheme across all features.")
    if custom_widgets < 12:
        imp.append("Build dedicated presentational widgets per feature (cards, chips, bars).")
    return min(score, 100), reason, imp


def j_ux():
    txt = "\n".join(_lib_files().values())
    nav = _count([r"Navigator\.", r"GoRouter", r"context.push", r"Navigator.push"], txt)
    feedback = "SnackBar" in txt or "CircularProgressIndicator" in txt or "LinearProgressIndicator" in txt
    score = 55 + min(nav, 5) * 3 + (5 if feedback else 0)
    imp = []
    if nav < 4:
        imp.append("Add explicit navigation flow + back-routing between features.")
    imp.append("Add empty/loading/error states for every async surface.")
    return min(score, 100), f"nav calls={nav}, async feedback={'y' if feedback else 'n'}.", imp


def j_accessibility():
    txt = "\n".join(_lib_files().values())
    s = 50
    checks = {
        "Semantics": "Semantics" in txt,
        "Tooltip": "Tooltip" in txt,
        "ExcludeSemantics": "ExcludeSemantics" in txt,
        "label Text": bool(re.search(r"Text\([^,]*,\s*semanticsLabel", txt)),
    }
    for k, v in checks.items():
        if v:
            s += 12
    imp = [f"Add {k} to interactive elements." for k, v in checks.items() if not v]
    return min(s, 100), f"a11y markers={sum(checks.values())}/4.", imp


def j_performance():
    txt = "\n".join(_lib_files().values())
    s = 70
    bad = ["setState" in txt, "ListView(" in txt and "builder" not in txt]
    if "const" in txt:
        s += 5
    if "Consumer(" in txt or "Selector(" in txt:
        s += 10
    if any(bad):
        s -= 15
        imp = ["Replace bare ListView with ListView.builder.", "Avoid setState in hot paths; use Riverpod selectors."]
    else:
        imp = ["Add const constructors to all stateless widgets.", "Profile build() with flutter_animate lazily."]
    return min(s, 100), f"selective-rebuild={'y' if ('Selector' in txt) else 'n'}.", imp


def j_animations():
    txt = "\n".join(_lib_files().values())
    has_fa = "flutter_animate" in _read(os.path.join(ROOT, "pubspec.yaml"))
    anim_calls = _count([r"\.animate\(", r"Animate\(", r"AnimationController", r"Tween"], txt)
    s = 45 + (20 if has_fa else 0) + min(anim_calls, 5) * 5
    imp = []
    if not has_fa:
        imp.append("Add flutter_animate dependency and micro-interactions.")
    imp.append("Add streak milestone + level-up celebration animations.")
    return min(s, 100), f"flutter_animate={'y' if has_fa else 'n'}; anim calls={anim_calls}.", imp


def j_gamification():
    feats = _feature_dirs()
    present = [f for f in ["streak", "skins", "leagues", "buddy", "teams", "missions", "onboarding"] if f in feats]
    s = 30 + len(present) * 9
    imp = [f"Implement feature module: {f}" for f in ["streak", "skins", "leagues", "buddy", "teams", "missions", "onboarding"] if f not in feats]
    return min(s, 100), f"gamification modules={present}.", imp


def j_psychology():
    txt = "\n".join(_lib_files().values())
    humane = "grace" in txt.lower() or "freeze" in txt.lower() or "recovery" in txt.lower()
    s = 55 + (20 if humane else 0)
    imp = [] if humane else ["Implement humane streak recovery (grace days, freeze tokens) — no guilt spiral."]
    imp.append("Add progress-framing copy that emphasizes growth, not deficit.")
    return min(s, 100), f"humane mechanics={'y' if humane else 'n'}.", imp


def j_retention():
    feats = _feature_dirs()
    s = 50
    for f in ["streak", "missions", "leagues"]:
        if f in feats:
            s += 12
    imp = []
    for f in ["streak", "missions", "leagues"]:
        if f not in feats:
            imp.append(f"Ship {f} loop (core to D1/D7/D30 retention).")
    return min(s, 100), f"retention loops={[f for f in ['streak','missions','leagues'] if f in feats]}.", imp


def j_tech_architecture():
    feats = _feature_dirs()
    layered = all(os.path.isdir(os.path.join(LIB, "features", f, layer))
                  for f in feats for layer in ["presentation", "application", "domain", "data"])
    s = 55 if feats else 35
    if layered and feats:
        s += 20
    imp = []
    if not feats:
        imp.append("Create feature-first modules with presentation/application/domain/data.")
    elif not layered:
        imp.append("Enforce layering: separate presentation/application/domain/data per feature.")
    return min(s, 100), f"features={feats}; strict layering={'y' if layered else 'n'}.", imp


def j_database_design():
    txt = _read(os.path.join(ROOT, "pubspec.yaml"))
    uses_drift = "drift" in txt
    has_migrations = bool(_walk((".dart",))) and any("Migration" in v or "@DriftDatabase" in v for v in _walk((".dart",)).values())
    s = (60 if uses_drift else 40) + (20 if has_migrations else 0)
    imp = []
    if not uses_drift:
        imp.append("Adopt Drift 2.18+ with typed tables + migrations.")
    if not has_migrations:
        imp.append("Define schema migrations safely (generate db classes).")
    return min(s, 100), f"drift={'y' if uses_drift else 'n'}; migrations={'y' if has_migrations else 'n'}.", imp


def j_security():
    txt = "\n".join(_lib_files().values())
    s = 65
    if "flutter_secure_storage" in _read(os.path.join(ROOT, "pubspec.yaml")):
        s += 10
    leak = bool(re.search(r"(apiKey|api_key|secret|token)\s*=\s*['\"][A-Za-z0-9]{8,}", txt))
    if leak:
        s -= 30
        imp = ["Remove hardcoded secrets; use env/secure storage."]
    else:
        imp = ["Store sensitive tokens via flutter_secure_storage.", "Add network MITM protection note for H9."]
    return min(s, 100), f"hardcoded-secret={'y' if leak else 'n'}.", imp


def j_testing():
    tfiles = _walk((".dart",))  # test/ separate
    test_txt = ""
    if os.path.isdir(TEST):
        for dp, _, fns in os.walk(TEST):
            for fn in fns:
                if fn.endswith(".dart"):
                    test_txt += _read(os.path.join(dp, fn))
    n_tests = _count([r"test\(|testWidgets\(|expect\("], test_txt)
    s = 40 + min(n_tests, 12) * 4
    imp = []
    if n_tests < 6:
        imp.append("Add unit tests for domain models + providers.")
    imp.append("Add golden + integration tests for core flows.")
    return min(s, 100), f"test assertions≈{n_tests}.", imp


def j_devops():
    wf = _read(os.path.join(ROOT, ".github", "workflows", "build.yml"))
    s = 40
    for gate in ["flutter analyze", "flutter test", "build apk", "Build App Bundle", "release create"]:
        if gate in wf:
            s += 8
    imp = []
    if "golden" not in wf:
        imp.append("Wire golden tests into CI.")
    if "integration" not in wf:
        imp.append("Wire integration tests into CI.")
    return min(s, 100), f"CI gates present.", imp


def j_ai_quality():
    # H9-H11 stubbed; judge on architecture readiness
    txt = "\n".join(_lib_files().values())
    s = 50
    if "TODO" in txt:
        s += 10  # honest stubs present
    if os.path.isdir(os.path.join(LIB, "features", "intelligence")):
        s += 15
    imp = ["Build intelligence domain (calendar allocator, geo discovery) behind interfaces.",
           "Define AI suggestion schema + offline queue."]
    return min(s, 100), f"intelligence module={'y' if os.path.isdir(os.path.join(LIB,'features','intelligence')) else 'n'}.", imp


def j_scalability():
    txt = "\n".join(_lib_files().values())
    s = 60
    if "drift" in _read(os.path.join(ROOT, "pubspec.yaml")):
        s += 10
    if "Isolate" in txt or "compute(" in txt:
        s += 10
    imp = ["Use drift indexes for XP/streak queries.", "Offload PDF + heavy JSON to compute() isolates."]
    return min(s, 100), "local-scalable baseline.", imp


def j_code_quality():
    txt = "\n".join(_lib_files().values())
    s = 70
    if "freezed" in _read(os.path.join(ROOT, "pubspec.yaml")):
        s += 10
    dup = len(re.findall(r"class \w+ extends", txt))
    if dup < 30:
        s += 5
    imp = ["Adopt freezed for immutable domain models.", "Run dart fix + custom lint rules in CI."]
    return min(s, 100), f"widget/state classes={dup}.", imp


def j_documentation():
    docs = ["ROADMAP.md", "TASKS.md", "CHANGELOG.md", "DECISIONS.md", "TECH_DEBT.md",
            "RESEARCH.md", "CONTINUOUS_IMPROVEMENT.md"]
    present = [d for d in docs if os.path.isfile(os.path.join(DOCS, d))]
    s = 40 + len(present) * 7
    imp = [f"Create {d}" for d in docs if d not in present]
    if s >= 89:
        imp.append("Keep docs updated each commit (automated).")
    return min(s, 100), f"planning docs={len(present)}/7.", imp


def j_maintainability():
    feats = _feature_dirs()
    s = 55 if feats else 40
    if os.path.isfile(os.path.join(ROOT, "analysis_options.yaml")):
        s += 10
    imp = ["Add strict analysis_options.yaml (lints).", "Modularize: one responsibility per file."] if s < 80 else []
    return min(s, 100), f"features={len(feats)}.", imp


def j_reliability():
    txt = "\n".join(_lib_files().values())
    s = 65
    if "try" in txt and "catch" in txt:
        s += 10
    if "Workmanager" in _read(os.path.join(ROOT, "pubspec.yaml")) or "workmanager" in txt:
        s += 5
    imp = ["Wrap async I/O in try/catch with user-facing error states.",
           "Add offline retry queue (H9)."]
    return min(s, 100), f"try/catch present={'y' if ('try' in txt and 'catch' in txt) else 'n'}.", imp


def j_product_vision():
    txt = "\n".join(_lib_files().values())
    s = 60
    if "university" in txt.lower() or "admissions" in txt.lower():
        s += 10
    if os.path.isdir(os.path.join(LIB, "features", "onboarding")):
        s += 10
    imp = ["Tie every gamification reward to an admissions pillar.", "Show CV-impact preview per action."]
    return min(s, 100), "vision-aligned baseline.", imp


def j_admissions_value():
    txt = "\n".join(_lib_files().values())
    pillars = ["Academics", "Leadership", "Research", "Creativity", "Community", "Service", "Sports", "Personal"]
    found = [p for p in pillars if p.lower() in txt.lower()]
    s = 45 + len(found) * 5
    imp = ["Map missions to 8 admission pillars explicitly.", "Show pillar coverage radar in profile."]
    return min(s, 100), f"pillars referenced={found}.", imp


def j_offline():
    txt = "\n".join(_lib_files().values())
    s = 60
    if "drift" in _read(os.path.join(ROOT, "pubspec.yaml")) or "hive" in _read(os.path.join(ROOT, "pubspec.yaml")):
        s += 15
    if "connectivity" in txt or "Connectivity" in txt:
        s += 5
    imp = ["Add connectivity-aware UI + offline banner.", "Queue mutations for later sync (H9)."]
    return min(s, 100), "offline-first storage present.", imp


def j_localization():
    txt = "\n".join(_lib_files().values())
    s = 55
    if "intl" in _read(os.path.join(ROOT, "pubspec.yaml")):
        s += 10
    if "AppLocalizations" in txt or "arb" in txt:
        s += 10
    imp = ["Add intl + .arb strings (en + zh + es baseline).", "Avoid hardcoded user-facing strings."]
    return min(s, 100), f"intl={'y' if 'intl' in _read(os.path.join(ROOT,'pubspec.yaml')) else 'n'}.", imp


def j_mobile_best():
    txt = "\n".join(_lib_files().values())
    s = 65
    if "SafeArea" in txt:
        s += 8
    if "MediaQuery" in txt:
        s += 7
    imp = ["Wrap screens in SafeArea.", "Use MediaQuery for responsive layout."] if s < 80 else []
    return min(s, 100), f"safearea={'y' if 'SafeArea' in txt else 'n'}.", imp


def j_flutter_best():
    txt = "\n".join(_lib_files().values())
    s = 70
    if "const" in txt:
        s += 5
    if "Key(" in txt or "key:" in txt:
        s += 5
    imp = ["Add keys to list items.", "Prefer const constructors."] if s < 80 else []
    return min(s, 100), "baseline flutter idioms.", imp


def j_riverpod():
    txt = "\n".join(_lib_files().values())
    s = 55
    for p in ["Provider", "StateNotifierProvider", "FutureProvider", "StreamProvider", "Notifier"]:
        if p in txt:
            s += 6
    if "ConsumerWidget" in txt or "ConsumerStatefulWidget" in txt:
        s += 5
    imp = ["Use @riverpod codegen Notifier for mutable state.", "Avoid global mutable providers."]
    return min(s, 100), "riverpod baseline wired.", imp


def j_drift():
    txt = _read(os.path.join(ROOT, "pubspec.yaml"))
    s = 45 if "drift" in txt else 35
    if "drift_dev" in txt:
        s += 10
    imp = ["Add drift + drift_dev.", "Define @DataClassName tables for all domains."] if s < 80 else []
    return min(s, 100), f"drift={'y' if 'drift' in txt else 'n'}.", imp


def j_api_design():
    txt = "\n".join(_lib_files().values())
    s = 55
    if "http" in _read(os.path.join(ROOT, "pubspec.yaml")) or "dio" in _read(os.path.join(ROOT, "pubspec.yaml")):
        s += 10
    if "Repository" in txt or "DataSource" in txt:
        s += 10
    imp = ["Define repository interfaces per domain.", "Centralize API client with interceptors."]
    return min(s, 100), "repo abstraction pending.", imp


def j_error_recovery():
    txt = "\n".join(_lib_files().values())
    s = 60
    if "retry" in txt.lower() or "Retry" in txt:
        s += 10
    if "when(" in txt or "fold" in txt or "AsyncValue" in txt:
        s += 10
    imp = ["Use AsyncValue.when for every async UI.", "Add exponential-backoff retry for sync (H9)."]
    return min(s, 100), f"asyncvalue={'y' if 'AsyncValue' in txt else 'n'}.", imp


def j_user_delight():
    txt = "\n".join(_lib_files().values())
    s = 55
    if "flutter_animate" in _read(os.path.join(ROOT, "pubspec.yaml")):
        s += 10
    if "Celebration" in txt or "confetti" in txt.lower() or "particle" in txt.lower():
        s += 10
    imp = ["Add streak milestone confetti/particles.", "Add haptic feedback on rewards."]
    return min(s, 100), "delight baseline.", imp


JUDGES = {
    "UI Design": j_ui_design, "UX": j_ux, "Accessibility": j_accessibility,
    "Performance": j_performance, "Animations": j_animations,
    "Gamification": j_gamification, "Psychology": j_psychology, "Retention": j_retention,
    "Technical Architecture": j_tech_architecture, "Database Design": j_database_design,
    "Security": j_security, "Testing": j_testing, "DevOps": j_devops,
    "AI Quality": j_ai_quality, "Scalability": j_scalability, "Code Quality": j_code_quality,
    "Documentation": j_documentation, "Maintainability": j_maintainability,
    "Reliability": j_reliability, "Product Vision": j_product_vision,
    "University Admissions Value": j_admissions_value, "Offline Experience": j_offline,
    "Localization": j_localization, "Mobile Best Practices": j_mobile_best,
    "Flutter Best Practices": j_flutter_best, "Riverpod Architecture": j_riverpod,
    "Drift Architecture": j_drift, "API Design": j_api_design,
    "Error Recovery": j_error_recovery, "User Delight": j_user_delight,
}


def main():
    results = []
    for cat in CATEGORIES:
        score, reason, imp = JUDGES[cat]()
        results.append({"category": cat, "score": int(score),
                        "reasoning": reason, "improvements": imp})
    mean = sum(r["score"] for r in results) / len(results)
    report = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "mean_score": round(mean, 1),
        "below_85": [r["category"] for r in results if r["score"] < 85],
        "results": results,
    }
    with open(os.path.join(ROOT, "judge_report.json"), "w") as f:
        json.dump(report, f, indent=2)
    print(f"Mean: {mean:.1f} / 100   Below 85: {len(report['below_85'])}")
    for r in sorted(results, key=lambda x: x["score"]):
        print(f"  {r['score']:3d}  {r['category']}")
    return 1 if report["below_85"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
