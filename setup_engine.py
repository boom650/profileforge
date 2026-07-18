#!/usr/bin/env python3
"""
Setup engine v2 — FAST. Make repos USABLE without blocking on 340 npm/pip installs.
For each cloned repo:
  - Detect type (mcp / skill / python / node / flutter / unknown)
  - Write a USAGE.md with exact run commands (so it's usable)
  - Skills: link SKILL.md into ~/.hermes/skills/<name>
  - MCP: write entry to mcp_config.json with launch command
  - Python/node: note install command in USAGE.md (no blocking install)
Generates repos2/SETUP_REPORT.md.
"""
import json, os, subprocess, time, shutil
from datetime import datetime

WS = os.path.dirname(os.path.abspath(__file__))
RE2 = os.path.join(WS, "repos2")
REPORT = os.path.join(WS, "repos2/SETUP_REPORT.md")
LOG = os.path.join(WS, "repos2/setup_engine.log")
MCP_CFG = os.path.join(WS, "mcp_config.json")

def log(m):
    ts = datetime.now().strftime("%H:%M:%S")
    line = f"[{ts}] {m}"
    print(line, flush=True)
    with open(LOG, "a") as f: f.write(line + "\n")

def detect(repo_dir):
    files = set(os.listdir(repo_dir))
    has_pkg = "package.json" in files
    has_pyproject = "pyproject.toml" in files or "setup.py" in files
    has_requirements = "requirements.txt" in files
    has_pubspec = "pubspec.yaml" in files
    readme = ""
    if "README.md" in files:
        try: readme = open(os.path.join(repo_dir,"README.md")).read().lower()
        except: pass
    if has_pubspec: return "flutter"
    if "mcp" in repo_dir.lower() or "mcp" in readme[:800]: return "mcp"
    if any(f.lower()=="skill.md" for f in files) or "skill" in repo_dir.lower(): return "skill"
    if has_pyproject or has_requirements: return "python"
    if has_pkg: return "node"
    return "unknown"

def main():
    log("SETUP ENGINE v2 START (fast, no blocking installs)")
    # repos from both dirs
    all_repos = []
    for base in ["repos", "repos2"]:
        bd = os.path.join(WS, base)
        if os.path.isdir(bd):
            for d in os.listdir(bd):
                if os.path.isdir(os.path.join(bd, d)):
                    all_repos.append((base, d))
    log(f"Found {len(all_repos)} repos total")
    mcp = {}
    if os.path.exists(MCP_CFG):
        try: mcp = json.load(open(MCP_CFG))
        except: pass
    report = {}
    skills_linked = 0
    for base, d in sorted(all_repos):
        repo_dir = os.path.join(WS, base, d)
        kind = detect(repo_dir)
        usage = []
        if kind == "mcp":
            # find entry
            entry = None
            if os.path.exists(os.path.join(repo_dir,"package.json")):
                entry = f"npx -y {d.split('__')[-1]}" if False else f"node {repo_dir}"
                usage.append(f"Run: cd {repo_dir} && npm install && npm start")
                usage.append(f"Or: npx -y {d.replace('__','/')}")
            elif os.path.exists(os.path.join(repo_dir,"pyproject.toml")) or os.path.exists(os.path.join(repo_dir,"requirements.txt")):
                usage.append(f"Run: cd {repo_dir} && pip install -e . && python -m {d.split('__')[-1]}")
            mcp[d] = {"path": repo_dir, "launch": usage[0] if usage else "see USAGE.md", "usable": True}
        elif kind == "skill":
            for root, dirs, files in os.walk(repo_dir):
                if "SKILL.md" in files:
                    name = d.split("__")[-1]
                    dest = os.path.expanduser(f"~/.hermes/skills/{name}")
                    try:
                        os.makedirs(dest, exist_ok=True)
                        shutil.copy(os.path.join(root,"SKILL.md"), os.path.join(dest,"SKILL.md"))
                        skills_linked += 1
                        usage.append(f"Linked: ~/.hermes/skills/{name}")
                    except Exception as e:
                        usage.append(f"link FAIL: {e}")
                    break
            else:
                usage.append("no SKILL.md found")
        elif kind == "python":
            if os.path.exists(os.path.join(repo_dir,"requirements.txt")):
                usage.append(f"Setup: cd {repo_dir} && pip install -r requirements.txt --user")
            elif os.path.exists(os.path.join(repo_dir,"pyproject.toml")):
                usage.append(f"Setup: cd {repo_dir} && pip install -e . --user")
            usage.append(f"Import: check README for entry point")
        elif kind == "node":
            usage.append(f"Setup: cd {repo_dir} && npm install && npm run build")
        elif kind == "flutter":
            usage.append(f"Setup: cd {repo_dir} && flutter pub get (needs Flutter SDK)")
            usage.append(f"Build: flutter build apk")
        else:
            usage.append("Unknown type — inspect README.md manually")
        # write USAGE.md
        with open(os.path.join(repo_dir, "USAGE.md"), "w") as f:
            f.write(f"# {d}\n\nType: {kind}\n\n## How to use\n")
            for u in usage: f.write(f"- {u}\n")
        report[d] = {"kind": kind, "usage": usage, "base": base}
        log(f"  {d} -> {kind} ({len(usage)} notes)")
        time.sleep(0.05)
    json.dump(mcp, open(MCP_CFG,"w"), indent=1)
    with open(REPORT, "w") as f:
        f.write("# Setup Report (v2 — fast)\n\n")
        f.write(f"Total repos: {len(report)}\nSkills linked: {skills_linked}\nMCP servers configured: {len(mcp)}\n\n")
        for d, info in report.items():
            f.write(f"## {d} ({info['kind']})\n")
            for u in info["usage"]:
                f.write(f"- {u}\n")
            f.write("\n")
    log(f"SETUP DONE. Report: {REPORT} | Skills linked: {skills_linked} | MCP: {len(mcp)}")

if __name__ == "__main__":
    main()
