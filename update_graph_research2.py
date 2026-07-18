#!/usr/bin/env python3
"""
Update knowledge graph with research2 (new web sources + new repos).
Merges into knowledge_graph.json so the live graph includes both passes.
Also writes a BEST_PRACTICES.md synthesized from the HN comments (real learnings).
"""
import json, os, re
from collections import Counter

WS = os.path.dirname(os.path.abspath(__file__))
KG = os.path.join(WS, "knowledge_graph.json")
R2 = os.path.join(WS, "research2")
RE2 = os.path.join(WS, "repos2")

def load(p):
    if os.path.exists(p):
        try: return json.load(open(p))
        except: return []
    return []

# Load existing graph
g = json.load(open(KG))
nodes = {n["id"]: n for n in g["nodes"]}
edges = g["edges"]

# Add research2 domains/sources
sources = load(os.path.join(R2, "all_sources.json"))
repos2 = load(os.path.join(RE2, "ANALYSIS2.json"))

# Domain nodes for research2 topics
topic_domains = {
    "flutter_best_practices": "flutter2",
    "pdf_generation_web": "pdf2",
    "context_compression": "ctxcompress2",
    "agentic_patterns": "agentic2",
    "mcp_servers": "mcp2",
    "skill_systems": "skill2",
}
domain_labels = {
    "flutter2": "Flutter best-practices (research2)",
    "pdf2": "PDF generation (research2)",
    "ctxcompress2": "Context compression (research2)",
    "agentic2": "Agentic patterns (research2)",
    "mcp2": "MCP servers (research2)",
    "skill2": "Skill systems (research2)",
}
for tid, nid in topic_domains.items():
    if nid not in nodes:
        nodes[nid] = {"id": nid, "type": "domain", "label": domain_labels[nid]}
        g["nodes"].append(nodes[nid])
    # add source nodes (sample up to 200 per topic to keep graph manageable)
    topic_srcs = [s for s in sources if s.get("topic") == tid]
    for s in topic_srcs[:200]:
        sid = f"src2:{tid}:{s.get('hn_id','') or s.get('link','') or hash(s.get('text',''))}"
        sid = str(abs(hash(sid)))[:12]
        if sid not in nodes:
            nodes[sid] = {"id": sid, "type": "source", "label": s.get("title", s.get("text",""))[:80],
                          "topic": tid, "stype": s.get("type","")}
            g["nodes"].append(nodes[sid])
            edges.append({"source": sid, "target": nid, "kind": "ABOUT"})

# Add new repos
for r in repos2[:200]:
    rid = f"repo2:{r['fullName']}"
    if rid not in nodes:
        nodes[rid] = {"id": rid, "type": "repo", "label": r["fullName"], "stars": r.get("stars",0),
                      "language": r.get("language",""), "topic": r.get("topic",""), "new": True}
        g["nodes"].append(nodes[rid])
        # link to domain
        tid = r.get("topic","")
        if tid in topic_domains:
            edges.append({"source": rid, "target": topic_domains[tid], "kind": "ABOUT"})

json.dump(g, open(KG, "w"), indent=1)
print(f"Graph updated: {len(g['nodes'])} nodes / {len(g['edges'])} edges")

# Synthesize BEST_PRACTICES.md from HN comments (real learnings)
comments = [s for s in sources if s.get("type") == "comment"]
bp = {"flutter_best_practices": [], "pdf_generation_web": [], "context_compression": [],
      "agentic_patterns": [], "mcp_servers": [], "skill_systems": []}
for c in comments:
    t = c.get("text", "")
    if len(t) > 60:
        bp.setdefault(c.get("topic",""), []).append(t)
with open(os.path.join(WS, "research2/BEST_PRACTICES.md"), "w") as f:
    f.write("# Best Practices Synthesized from Research2 (HN practitioner comments)\n\n")
    for topic, clist in bp.items():
        f.write(f"## {topic.replace('_',' ').title()}\n")
        for c in clist[:25]:
            f.write(f"- {c[:300]}\n")
        f.write("\n")
print(f"Best practices synthesized: {sum(len(v) for v in bp.values())} comments across {len(bp)} topics")
