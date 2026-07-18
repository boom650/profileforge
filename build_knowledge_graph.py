#!/usr/bin/env python3
"""Build knowledge_graph.json from research findings + repo analysis.

Nodes: domains (pdf, app/flutter, web, agentic), tools, repos, findings, constraints.
Edges: relates_to / preferred_for / blocked_by / supersedes / source.
"""
import json, os, sys

WS = "/data/data/com.termux/files/home/workspace"
OUT = os.path.join(WS, "knowledge_graph.json")

def load(p, default):
    try:
        with open(p) as f:
            return json.load(f)
    except Exception:
        return default

nodes, edges = [], []
def node(id, label, type, meta=None):
    nodes.append({"id": id, "label": label, "type": type, "meta": meta or {}})
def edge(a, b, rel):
    edges.append({"from": a, "to": b, "rel": rel})

# --- Domain nodes ---
node("domain:pdf", "PDF", "domain", {
    "status": "backend-preferred",
    "on_device": "Flutter pdf/printing OK for simple docs only",
    "backend": ["ReportLab (Python)", "WeasyPrint (HTML->PDF)", "pdf-lib (JS, form-fill/merge)"],
    "ocr": "Tesseract", "sign": "server-side mature; mobile fragile",
    "sources": 161})
node("domain:app", "App (Flutter/Android)", "domain", {
    "status": "build GREEN",
    "working_stack": "Flutter 3.27.4 + Gradle 8.6 + AGP 8.4 + Kotlin 2.0.20 + Java 17",
    "state": "Riverpod 2.x + Freezed", "arch": "clean (data/domain/presentation)",
    "native": "Pigeon for FFI", "sources": 184})
node("domain:web", "Web", "domain", {
    "status": "reference for companion admin / PDF backend",
    "stack": ["Next.js 16 (App Router, RSC)", "Vite", "SvelteKit", "Astro", "Vue"],
    "styling": ["Tailwind v4", "shadcn/ui", "styled-components"],
    "perf": ["Core Web Vitals", "Cloudflare Edge Functions"], "sources": 204})
node("domain:agentic", "Agentic AI", "domain", {
    "status": "primary domain (most sources)",
    "subtopics": ["skills-systems", "multi-agent-orchestration", "context-compression", "MCP", "agentic-SWE"],
    "sources": 479})

# --- Tool / technique nodes (agentic) ---
tools = [
    ("obra/superpowers", "Skills-first methodology; explicit SKILL.md dispatch", 256525, ["skills"]),
    ("affaan-m/ECC", "Agent harness perf: instincts/memory/security", 230606, ["skills"]),
    ("x1xhlol/system-prompts", "Production system-prompt dumps", 142015, ["skills"]),
    ("langchain-ai/langchain", "Agent engineering platform", 141996, ["framework"]),
    ("punkpeye/awesome-mcp-servers", "Catalog of MCP servers", 90882, ["mcp"]),
    ("bytedance/deer-flow", "Long-horizon research/code/create SuperAgent", 77285, ["framework"]),
    ("headroomlabs-ai/headroom", "Compress tool output/logs/RAG -> 20% fewer tokens", 59644, ["context-compression"]),
    ("crewAIInc/crewAI", "Role-playing autonomous agents", 55689, ["framework"]),
    ("Yeachan-Heo/oh-my-claudecode", "Teams-first multi-agent orchestration", 37842, ["multi-agent"]),
    ("langchain-ai/langgraph", "Resilient graph agents", 37513, ["framework"]),
    ("microsoft/playwright-mcp", "Playwright MCP server", 35203, ["mcp"]),
    ("DeusData/codebase-memory-mcp", "Codebase knowledge-graph MCP", 32359, ["mcp"]),
    ("github/github-mcp-server", "GitHub official MCP", 31515, ["mcp"]),
    ("langchain-ai/deepagents", "Batteries-included agent harness", 26368, ["framework"]),
    ("PrefectHQ/fastmcp", "Pythonic MCP server/client builder", 26242, ["mcp"]),
    ("NirDiamant/agents-towards-production", "Prod-grade GenAI agent tutorials", 21083, ["framework"]),
    ("openai/swarm", "Lightweight multi-agent (educational)", 21805, ["multi-agent"]),
    ("TauricResearch/TradingAgents", "Multi-agent financial trading", 93414, ["multi-agent"]),
    ("microsoft/LLMLingua", "Prompt/context compression", 0, ["context-compression"]),
    ("Xnhyacinth/Awesome-LLM-Long-Context", "Long-context modeling survey", 0, ["context-compression"]),
    ("assafelovic/gpt-researcher", "Deep research agent", 0, ["agentic-SWE"]),
    ("SWE-agent/swe-agent", "Agentic software engineering", 0, ["agentic-SWE"]),
    ("NirDiamant/GenAI_Agents", "50+ agent technique tutorials", 23293, ["framework"]),
    ("activepieces/activepieces", "AI workflow automation (~400 MCP)", 23308, ["mcp"]),
]
for name, desc, stars, tags in tools:
    nid = "repo:" + name
    node(nid, name, "repo", {"desc": desc, "stars": stars, "tags": tags})
    # link to agentic domain
    edge("domain:agentic", nid, "contains")
    for t in tags:
        edge(nid, "topic:" + t, "topic")

# topic nodes
for t in ["skills", "mcp", "framework", "multi-agent", "context-compression", "agentic-SWE"]:
    node("topic:" + t, t, "topic", {})
    edge("domain:agentic", "topic:" + t, "has-topic")

# --- Key findings / constraints ---
node("finding:gradle-mismatch", "AGP9/Gradle9 breaks Flutter plugin engine classpath", "finding",
     {"severity": "critical", "fix": "Flutter 3.27.4 + Gradle 8.6 + AGP 8.4 + Kotlin 2.0.20"})
edge("domain:app", "finding:gradle-mismatch", "blocked-by")
edge("finding:gradle-mismatch", "finding:flutter-create-fix", "fixed-by")
node("finding:flutter-create-fix", "Regenerate android/ via `flutter create --platforms android .` in CI", "finding",
     {"status": "verified GREEN", "release": "v206-1f573edb4d84dd386430fa3174517d546272b853"})
node("finding:flutter-kts", "Flutter 3.27.4 generates Groovy build.gradle, NOT Kotlin .kts", "finding",
     {"impact": "hand-written .kts broke earlier builds"})
edge("domain:app", "finding:flutter-kts", "constraint")
node("finding:l10n-path", "L10n: flutter gen-l10n + l10n.yaml output-dir lib/generated/l10n/, imported as real path", "finding", {})
edge("domain:app", "finding:l10n-path", "uses")
node("finding:pdf-backend", "Complex PDF => backend (ReportLab/WeasyPrint); mobile pdf pkg simple-only", "finding", {})
edge("domain:pdf", "finding:pdf-backend", "constraint")

graph = {"nodes": nodes, "edges": edges,
         "meta": {"built_from": ["research1000/findings.md", "repos/ANALYSIS.json"],
                  "source_count": 1028, "repo_count": 172, "version": 1}}
with open(OUT, "w") as f:
    json.dump(graph, f, indent=2)
print(f"Knowledge graph built: {len(nodes)} nodes, {len(edges)} edges -> {OUT}")
