#!/usr/bin/env python3
"""
Query the knowledge graph by keyword (app, pdf, web, agentic, or any repo/term).
Usage: python3 query_kg.py "pdf"
        python3 query_kg.py "app"
        python3 query_kg.py "superpowers"
Prints matched nodes + connected edges. This is what Hermes calls when the user
says a routing keyword.
"""
import json, os, sys

WS = os.path.dirname(os.path.abspath(__file__))
KG = os.path.join(WS, "knowledge_graph.json")

DOMAIN_KEYWORDS = {
    "app": "app", "flutter": "app", "android": "app", "apk": "app", "mobile": "app",
    "pdf": "pdf", "document": "pdf",
    "web": "web", "frontend": "web", "backend": "web",
    "agent": "agentic", "agentic": "agentic", "mcp": "agentic", "skill": "agentic",
    "subagent": "agentic", "orchestrat": "agentic", "context compress": "agentic",
}

def load():
    with open(KG) as f:
        return json.load(f)

def resolve_domain(q):
    q = q.lower().strip()
    for k, d in DOMAIN_KEYWORDS.items():
        if k in q:
            return d
    return None

def main():
    if len(sys.argv) < 2:
        print("Usage: query_kg.py <keyword>")
        sys.exit(1)
    q = sys.argv[1]
    g = load()
    nodes = {n["id"]: n for n in g["nodes"]}
    edges = g["edges"]

    dom = resolve_domain(q)
    matched = []
    if dom:
        matched.append(f"domain:{dom}")
    # also match by label/id substring
    ql = q.lower()
    for nid, n in nodes.items():
        label = str(n.get("label", "")).lower()
        if ql in label or ql in nid.lower():
            matched.append(nid)

    if not matched:
        print(f"No match for '{q}' in graph ({len(nodes)} nodes).")
        return

    seen = set()
    for mid in matched:
        n = nodes.get(mid)
        if not n or mid in seen:
            continue
        seen.add(mid)
        print(f"- {n.get('label', mid)} [{n['type']}]")
        for k, v in n.items():
            if k in ("id", "type", "label"):
                continue
            if isinstance(v, list) and len(v) > 5:
                print(f"    {k}: {len(v)} items")
            elif isinstance(v, (int, float)) and k == "stars":
                print(f"    stars: {v}")
            elif k == "description" and v:
                print(f"    {k}: {str(v)[:120]}")
            elif k == "summary" and v:
                print(f"    summary: {str(v)[:120]}")
            elif k == "source_count":
                print(f"    research sources: {v}")
            elif v and not isinstance(v, (list, dict)):
                print(f"    {k}: {v}")
        # connected edges
        for e in edges:
            if e["source"] == mid:
                t = nodes.get(e["target"])
                if t:
                    print(f"    -> {e['kind']} -> {t.get('label', e['target'])}")
            elif e["target"] == mid:
                s = nodes.get(e["source"])
                if s:
                    print(f"    <- {e['kind']} <- {s.get('label', e['source'])}")

if __name__ == "__main__":
    main()
