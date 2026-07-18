#!/usr/bin/env python3
"""
Build the canonical knowledge graph for ProfileForge research.
Ingests:
  - repos/ANALYSIS.json  (cloned agentic-AI repos, ranked)
  - repos/candidates.json (search candidates)
  - research1000/research_loop.log (1,028 research sources across 36 rounds)
Outputs:
  - knowledge_graph.json  (nodes + edges)
  - GRAPH_REPORT.md       (human-readable summary)

Node types: domain, repo, research_source, finding, keyword
Edge types: ABOUT, RELATES_TO, MENTIONS, TAGGED, SOURCE_OF
"""
import json, re, os, hashlib
from datetime import datetime

WS = os.path.dirname(os.path.abspath(__file__))

def load_json(path):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return None

def node(id, type, **attrs):
    n = {"id": id, "type": type}
    n.update(attrs)
    return n

def main():
    nodes = {}
    edges = {}
    def add_node(n):
        nodes[n["id"]] = n
    def add_edge(s, t, kind, **attrs):
        eid = f"{s}|{t}|{kind}"
        if eid not in edges:
            edges[eid] = {"source": s, "target": t, "kind": kind, **attrs}

    # ---- Domains ----
    domains = {
        "pdf": "PDF generation, parsing, extraction, rendering",
        "app": "Flutter / Android app development, mobile CI",
        "web": "Web development, frameworks, deployment",
        "agentic": "Agentic AI: skills, agents, subagents, orchestration, MCP, context compression",
    }
    for d, desc in domains.items():
        add_node(node(f"domain:{d}", "domain", label=d, description=desc))

    # ---- Repos (from ANALYSIS.json) ----
    analysis = load_json(os.path.join(WS, "repos/ANALYSIS.json"))
    if analysis:
        for r in analysis:
            rid = f"repo:{r['fullName']}"
            add_node(node(rid, "repo",
                label=r["fullName"],
                stars=r.get("stars", 0),
                language=r.get("language", ""),
                description=r.get("description", ""),
                summary=r.get("summary", ""),
                skills_files=r.get("skills_files", []),
                patterns=r.get("patterns", []),
                rank=r.get("rank", 0),
            ))
            # link to domains by keyword match
            text = (r.get("description", "") + " " + r.get("summary", "") + " " + " ".join(r.get("patterns", []))).lower()
            for d in domains:
                if d in text or (d == "agentic" and any(k in text for k in ["agent", "mcp", "skill", "subagent", "orchestrat", "context compress"])):
                    add_edge(rid, f"domain:{d}", "ABOUT")

    # ---- Candidates (from candidates.json) ----
    cands = load_json(os.path.join(WS, "repos/candidates.json"))
    if cands:
        for c in cands:
            fn = c.get("fullName") or c.get("full_name") or c.get("name")
            if not fn:
                continue
            rid = f"repo:{fn}"
            if rid not in nodes:
                add_node(node(rid, "repo",
                    label=fn,
                    stars=c.get("stars", 0),
                    language=c.get("language", ""),
                    description=c.get("description", ""),
                    candidate=True,
                ))
            text = (c.get("description", "") + " " + c.get("language", "")).lower()
            for d in domains:
                if d in text or (d == "agentic" and any(k in text for k in ["agent", "mcp", "skill"])):
                    add_edge(rid, f"domain:{d}", "ABOUT")

    # ---- Research sources (from log) ----
    log_path = os.path.join(WS, "research1000/research_loop.log")
    if os.path.exists(log_path):
        with open(log_path) as f:
            lines = f.readlines()
        src_count = 0
        for line in lines:
            m = re.search(r"\+(\d+) new \(total (\d+)\)", line)
            if m:
                src_count = int(m.group(2))
        # parse queries -> keywords -> sources
        round_re = re.compile(r"Round (\d+): query='([^']+)' \(have (\d+)\)")
        cur_q = None
        for line in lines:
            rm = round_re.search(line)
            if rm:
                cur_q = rm.group(2).lower()
                # link query to domains
                for d in domains:
                    if d in cur_q or (d == "agentic" and any(k in cur_q for k in ["agent", "mcp", "skill", "subagent", "context"])):
                        add_edge(f"query:{cur_q}", f"domain:{d}", "RELATES_TO")
                        if f"query:{cur_q}" not in nodes:
                            add_node(node(f"query:{cur_q}", "keyword", label=cur_q))
            # each "+N new" is a batch of sources for that query
            sm = re.search(r"\+(\d+) new \(total", line)
            if sm and cur_q:
                n = int(sm.group(1))
                sid = f"research:{cur_q}:{src_count}"
                # aggregate as one node per query to avoid 1000+ tiny nodes; track count via attr
                qnid = f"query:{cur_q}"
                if qnid in nodes:
                    nodes[qnid]["source_count"] = nodes[qnid].get("source_count", 0) + n
                    src_count += n
        # also create a research_source node for the whole corpus
        add_node(node("research:corpus", "research_source",
            label="Research corpus (1,028 sources)",
            total=src_count,
        ))
        for d in domains:
            add_edge("research:corpus", f"domain:{d}", "SOURCE_OF")

    # ---- Findings (from CI build success / known facts) ----
    findings = [
        ("finding:ci-green", "ProfileForge Flutter CI build is GREEN — APK (3 ABIs) + AAB published to GitHub release v206-1f573ed", "app"),
        ("finding:flutter-create", "Regenerate android/ via `flutter create --platforms android .` in CI to fix Gradle/AGP mismatch", "app"),
        ("finding:182-repos", "182 agentic-AI GitHub repos cloned + 172 analyzed; top: superpowers, ECC, system-prompts", "agentic"),
    ]
    for fid, text, dom in findings:
        add_node(node(fid, "finding", label=text, domain=dom))
        add_edge(fid, f"domain:{dom}", "ABOUT")

    # ---- Write ----
    out = {"nodes": list(nodes.values()), "edges": list(edges.values()),
           "built_at": datetime.now().isoformat(), "stats": {
               "repos": sum(1 for n in nodes.values() if n["type"] == "repo"),
               "domains": sum(1 for n in nodes.values() if n["type"] == "domain"),
               "queries": sum(1 for n in nodes.values() if n["type"] == "keyword"),
               "findings": sum(1 for n in nodes.values() if n["type"] == "finding"),
               "edges": len(edges),
           }}
    with open(os.path.join(WS, "knowledge_graph.json"), "w") as f:
        json.dump(out, f, indent=1)
    print(f"Built: {len(out['nodes'])} nodes, {len(out['edges'])} edges")
    print("Stats:", out["stats"])

    # ---- Report ----
    report = ["# Knowledge Graph Report", "",
              f"Built: {out['built_at']}", "",
              f"- Repos: {out['stats']['repos']}",
              f"- Domains: {out['stats']['domains']}",
              f"- Queries (keywords): {out['stats']['queries']}",
              f"- Findings: {out['stats']['findings']}",
              f"- Edges: {out['stats']['edges']}", "",
              "## Domains", ""]
    for d in domains:
        report.append(f"- **{d}**: {domains[d]}")
    report.append("")
    report.append("## Top Repos by Stars")
    top = sorted([n for n in nodes.values() if n["type"] == "repo"], key=lambda x: -x.get("stars", 0))[:20]
    for n in top:
        report.append(f"- {n['label']} ({n.get('stars',0)}★) — {n.get('description','')[:80]}")
    with open(os.path.join(WS, "GRAPH_REPORT.md"), "w") as f:
        f.write("\n".join(report))
    print("Report written: GRAPH_REPORT.md")

if __name__ == "__main__":
    main()
