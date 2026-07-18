#!/usr/bin/env python3
"""
FRESH research engine v5 — hard timeouts on EVERY external call. No hangs.
- HN stories + comments for web sources (proven 6.8k achievable)
- gh repo search for NEW repos (wrapped in `timeout 20`)
- Incremental persist per topic
- Excludes known repos
"""
import json, os, time, urllib.request, urllib.parse, subprocess, re
from collections import Counter

WS = os.path.dirname(os.path.abspath(__file__))
R2 = os.path.join(WS, "research2"); os.makedirs(R2, exist_ok=True)
RE2 = os.path.join(WS, "repos2"); os.makedirs(RE2, exist_ok=True)

known = set()
for fn in ["repos/ANALYSIS.json", "repos/candidates.json"]:
    p = os.path.join(WS, fn)
    if os.path.exists(p):
        try:
            for r in json.load(open(p)):
                fn_ = r.get("fullName") or r.get("full_name") or r.get("name")
                if fn_: known.add(fn_)
        except Exception: pass

TOPICS = {
    "flutter_best_practices": ["flutter clean architecture","flutter state management riverpod","flutter performance optimization","flutter testing best practice"],
    "pdf_generation_web": ["pdf generation server side","html to pdf production","pdf rendering library","reportlab weasyprint"],
    "context_compression": ["llm context compression","prompt caching token reduction","long context window optimization","kv cache compression"],
    "agentic_patterns": ["multi-agent orchestration","agentic workflow production","ai agent memory","tool use agent pattern"],
    "mcp_servers": ["model context protocol server","mcp server implementation","fastmcp client","mcp tool"],
    "skill_systems": ["ai agent skill","claude skills system","agent instruction methodology","prompt engineering agent"],
}

def fetch(url, timeout=10):
    try:
        req = urllib.request.Request(url, headers={"User-Agent":"Mozilla/5.0 (research)"})
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.read().decode("utf-8","ignore")
    except Exception:
        return ""

def hn_search(q, page=0, hits=50):
    u=f"https://hn.algolia.com/api/v1/search?query={urllib.parse.quote(q)}&tags=story&page={page}&hitsPerPage={hits}"
    try: return json.loads(fetch(u)).get("hits",[])
    except Exception: return []

def hn_comments(oid, limit=10):
    try:
        d=json.loads(fetch(f"https://hn.algolia.com/api/v1/items/{oid}", 10))
        out=[]
        def walk(c,depth=0):
            if depth>3 or len(out)>=limit: return
            if c.get("text"):
                t=re.sub(r"<[^>]+>","",c["text"]); t=re.sub(r"\s+"," ",t).strip()
                if len(t)>40: out.append(t)
            for ch in c.get("children",[]): walk(ch,depth+1)
        for c in d.get("children",[]): walk(c)
        return out
    except Exception: return []

def gh_search(q, per_page=40):
    try:
        out=subprocess.run(["timeout","20","gh","api",f"search/repositories?q={urllib.parse.quote(q)}&per_page={per_page}&sort=stars"],
                           capture_output=True,text=True,timeout=25)
        if out.returncode==0:
            try: return json.loads(out.stdout).get("items",[])
            except Exception: return []
    except Exception: pass
    return []

all_sources=[]; new_repos=[]

def persist():
    with open(os.path.join(R2,"all_sources.json"),"w") as f: json.dump(all_sources,f,indent=1)
    seen=set(); uniq=[]
    for r in new_repos:
        if r["fullName"] not in seen: seen.add(r["fullName"]); uniq.append(r)
    with open(os.path.join(RE2,"ANALYSIS2.json"),"w") as f: json.dump(uniq,f,indent=1)
    return uniq

def main():
    for topic, queries in TOPICS.items():
        print(f"\n=== {topic} ===", flush=True)
        for q in queries:
            for page in range(4):
                for s in hn_search(q, page, 50):
                    all_sources.append({"type":"article","title":s.get("title",""),
                        "link":s.get("url",""),"points":s.get("points",0),
                        "topic":topic,"hn_id":s.get("objectID","")})
                    for c in hn_comments(s.get("objectID",""),10):
                        all_sources.append({"type":"comment","text":c,"topic":topic,"hn_id":s.get("objectID","")})
            for r in gh_search(q, 40):
                fn_=r["full_name"]
                if fn_ in known: continue
                known.add(fn_)
                new_repos.append({"fullName":fn_,"stars":r["stargazers_count"],
                    "language":r.get("language",""),"description":r.get("description",""),
                    "topic":topic,"url":r["html_url"]})
        uniq=persist()
        print(f"  sources: {len(all_sources)} | new repos: {len(uniq)}", flush=True)
        time.sleep(0.5)

    uniq=persist()
    print(f"\nDONE. Web sources: {len(all_sources)} ({Counter(s['type'] for s in all_sources)}) | New repos: {len(uniq)}", flush=True)

    to_clone=sorted(uniq,key=lambda x:-x["stars"])[:200]
    cloned=0
    for r in to_clone:
        dest=os.path.join(RE2,r["fullName"].replace("/","__"))
        if os.path.exists(dest): cloned+=1; continue
        try:
            res=subprocess.run(["timeout","120","git","clone","--depth","1",r["url"],dest],capture_output=True,text=True,timeout=130)
            if res.returncode==0: cloned+=1; print(f"  cloned {r['fullName']} ({cloned}/200)", flush=True)
            else: print(f"  FAIL {r['fullName']}", flush=True)
        except Exception: print(f"  ERR {r['fullName']}", flush=True)
    print(f"Cloned {cloned}/200", flush=True)

if __name__=="__main__":
    main()
