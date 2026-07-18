#!/usr/bin/env python3
import json
import os

WS = "/data/data/com.termux/files/home/workspace"
OUT = os.path.join(WS, "knowledge_graph.json")

def node(id, label, type, meta=None): return {"id": id, "label": label, "type": type, "meta": meta or {}}
def edge(a, b, rel): return {"from": a, "to": b, "rel": rel}

nodes = [
    node("domain:pdf", "PDF", "domain", {"sources": 161}),
    node("domain:app", "App (Flutter/Android)", "domain", {"status": "GREEN"}),
    node("repo:obra/superpowers", "Superpowers", "repo", {"stars": 256525}),
    node("finding:flutter-create-fix", "Regenerate android/ via flutter create in CI", "finding", {"status": "verified GREEN"}),
]
edges = [
    edge("domain:app", "finding:flutter-create-fix", "fixed-by"),
    edge("domain:agentic", "repo:obra/superpowers", "contains"),
]

with open(OUT, "w") as f: json.dump({"nodes": nodes, "edges": edges}, f, indent=2)
print(f"Graph built: {len(nodes)} nodes, {len(edges)} edges -> {OUT}")
