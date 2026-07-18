#!/usr/bin/env python3
"""Query knowledge_graph.json. Usage: query_knowledge_graph.py <term>"""
import json, sys, os

WS = "/data/data/com.termux/files/home/workspace"
G = os.path.join(WS, "knowledge_graph.json")

def load():
    with open(G) as f:
        return json.load(f)

def main():
    term = " ".join(sys.argv[1:]).lower().strip()
    if not term:
        print("Usage: query_knowledge_graph.py <term>  (e.g. PDF, app, agent, Flutter)")
        return
    g = load()
    nodes = {n["id"]: n for n in g["nodes"]}
    hits = []
    for n in g["nodes"]:
        blob = (n["label"] + " " + n["id"] + " " + " ".join(n.get("meta", {}).get("tags", []))).lower()
        if term in blob:
            hits.append(n)
    if not hits:
        print(f"No nodes match '{term}'.")
        return
    # map domain keywords
    keyword_map = {"app": "domain:app", "flutter": "domain:app", "android": "domain:app",
                   "pdf": "domain:pdf", "web": "domain:web", "agent": "domain:agentic",
                   "mcp": "topic:mcp", "skill": "topic:skills"}
    # expand: include neighbors
    seen = set()
    def show(n, depth=0):
        if n["id"] in seen: return
        seen.add(n["id"])
        ind = "  " * depth
        meta = n.get("meta", {})
        print(f"{ind}- {n['label']} [{n['type']}]")
        for k, v in meta.items():
            if k in ("tags",): continue
            print(f"{ind}    {k}: {v}")
        if depth == 0:
            for e in g["edges"]:
                if e["from"] == n["id"] and e["to"] in nodes:
                    show(nodes[e["to"]], depth+1)
    for h in hits:
        show(h)

if __name__ == "__main__":
    main()
