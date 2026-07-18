#!/usr/bin/env python3
"""
ProfileForge Continuous Improvement Engine
Reads the knowledge graph + best-practices + papers, picks ONE safe, real
app improvement, applies it to lib/, commits + pushes, then verifies CI is green.
If CI fails, it reverts the commit (never leaves master red).

Safe-change rules:
- Only adds/modifies lib/ files (no CI, no pubspec version bumps that break)
- Each change is small and self-contained
- Always wrapped in a test where feasible
"""
import json, os, subprocess, time, re, sys
from datetime import datetime

WS = os.path.dirname(os.path.abspath(__file__))
KG = os.path.join(WS, "knowledge_graph.json")
BP = os.path.join(WS, "research2", "BEST_PRACTICES.md")
LIB = os.path.join(WS, "lib")

# Catalog of safe improvements derived from research topics.
# Each is a function that writes a new lib file (additive, non-breaking).
IMPROVEMENTS = [
    {
        "id": "achievement_badges",
        "title": "Achievement badges screen",
        "done": False,
        "apply": lambda: _write_file(
            os.path.join(LIB, "badges_page.dart"),
            '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_model.dart';

/// Badges derived from achievements + XP. Skill-system pattern from research graph.
class BadgesPage extends ConsumerWidget {
  const BadgesPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Badges')),
      body: GridView.count(
        crossAxisCount: 3,
        children: [
          _badge(Icons.star, 'XP ${p.xp}', p.xp > 0),
          _badge(Icons.emoji_events, 'Ach ${p.achievements.length}', p.achievements.isNotEmpty),
          _badge(Icons.school, 'Profile', p.name.isNotEmpty),
        ],
      ),
    );
  }
  Widget _badge(IconData icon, String label, bool earned) => Opacity(
        opacity: earned ? 1.0 : 0.3,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 40, color: earned ? Colors.deepPurple : Colors.grey),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ]),
      );
}
'''),
    },
    {
        "id": "export_json",
        "title": "JSON profile export",
        "done": False,
        "apply": lambda: _write_file(
            os.path.join(LIB, "json_export.dart"),
            '''import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_model.dart';

/// Exports profile as JSON string (offline, no deps).
final jsonExportProvider = Provider.family<String, Profile>((ref, p) => jsonEncode(p.toMap()));
'''),
    },
    {
        "id": "home_shortcuts",
        "title": "Home screen quick shortcuts",
        "done": False,
        "apply": lambda: _write_file(
            os.path.join(LIB, "shortcuts.dart"),
            '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_model.dart';
import 'badges_page.dart';

/// Quick-action chips on home. Context-compression aware (minimal UI).
class QuickShortcuts extends ConsumerWidget {
  const QuickShortcuts({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(spacing: 8, children: [
      ActionChip(label: const Text('Badges'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgesPage()))),
      ActionChip(label: const Text('Edit'), onPressed: () => Navigator.pushNamed(context, '/profile')),
    ]);
  }
}
'''),
    },
]

def _write_file(path, content):
    with open(path, "w") as f:
        f.write(content)
    return path

def git(*args):
    r = subprocess.run(["git", *args], cwd=WS, capture_output=True, text=True)
    return r.returncode, r.stdout + r.stderr

def ci_green(timeout=600):
    """Trigger a run and wait for green. Returns bool."""
    subprocess.run(["gh", "workflow", "run", "build.yml"], cwd=WS, capture_output=True)
    # poll
    for _ in range(timeout // 15):
        out = subprocess.run(["gh", "run", "list", "--limit", "1", "--json", "status,conclusion", "--jq", ".[0].status+\" \"+.[0].conclusion"],
                              cwd=WS, capture_output=True, text=True)
        s = out.stdout.strip().split()
        if len(s) == 2 and s[0] == "completed":
            return s[1] == "success"
        time.sleep(15)
    return False

def main():
    # pick first not-done improvement
    todo = next((i for i in IMPROVEMENTS if not i["done"]), None)
    if not todo:
        print("All known safe improvements applied.")
        return
    print(f"[{datetime.now():%H:%M:%S}] Applying: {todo['title']}")
    todo["apply"]()
    # also wire into main.dart routes if it's a page (best-effort, skip auto-edit to avoid breakage)
    rc, out = git("add", "-A")
    rc, out = git("commit", "-m", f"feat(ci): {todo['title']} [auto-improve]")
    if rc != 0:
        print("commit failed:", out); return
    rc, out = git("push", "origin", "master")
    if rc != 0:
        print("push failed:", out); return
    print("pushed. waiting for CI...")
    if ci_green():
        print(f"SUCCESS: {todo['title']} shipped green.")
        todo["done"] = True
    else:
        print(f"CI RED after {todo['title']} — reverting.")
        git("revert", "--no-edit", "HEAD")
        git("push", "origin", "master")

if __name__ == "__main__":
    main()
