#!/usr/bin/env python3
"""
Live watcher for the knowledge graph.
- Polls source files (repos/ANALYSIS.json, repos/candidates.json, research1000/research_loop.log)
  every 30s; if any mtime changed, re-runs ingest_graph.py.
- Also watches research1000/ for new research logs and repos/ for new clones.
Runs forever (background). Logs to graphify_watch.log.
"""
import os, time, subprocess, sys

WS = os.path.dirname(os.path.abspath(__file__))
SOURCES = [
    os.path.join(WS, "repos/ANALYSIS.json"),
    os.path.join(WS, "repos/candidates.json"),
    os.path.join(WS, "research1000/research_loop.log"),
]
WATCH_DIRS = [
    os.path.join(WS, "research1000"),
    os.path.join(WS, "repos"),
]
LOG = os.path.join(WS, "graphify_watch.log")

def mtimes():
    mt = {}
    for s in SOURCES:
        try:
            mt[s] = os.path.getmtime(s)
        except OSError:
            mt[s] = 0
    # newest file in watch dirs
    for d in WATCH_DIRS:
        try:
            for f in os.listdir(d):
                p = os.path.join(d, f)
                if os.path.isfile(p):
                    mt[p] = os.path.getmtime(p)
        except OSError:
            pass
    return mt

def log(msg):
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line, flush=True)
    with open(LOG, "a") as f:
        f.write(line + "\n")

def main():
    log("WATCHER START: monitoring sources for changes")
    last = mtimes()
    while True:
        time.sleep(30)
        cur = mtimes()
        changed = [k for k in cur if cur.get(k) != last.get(k)]
        if changed:
            log(f"CHANGE detected in {len(changed)} file(s) — rebuilding graph")
            try:
                subprocess.run([sys.executable, os.path.join(WS, "ingest_graph.py")],
                               cwd=WS, check=True)
                log("GRAPH REBUILT OK")
            except subprocess.CalledProcessError as e:
                log(f"REBUILD FAILED: {e}")
            last = cur
        else:
            log("no changes")

if __name__ == "__main__":
    main()
