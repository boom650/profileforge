#!/usr/bin/env python3
"""Add sql.js script tag to web/index.html for drift web support.
Run after 'flutter create . --platforms web' creates the web directory."""
import re, os

index_path = 'web/index.html'
if not os.path.exists(index_path):
    print(f"ERROR: {index_path} not found. Run 'flutter create . --platforms web' first.")
    exit(1)

with open(index_path, 'r') as f:
    content = f.read()

if 'sql.js' in content:
    print("sql.js already included in index.html")
    exit(0)

# Add sql.js CDN script before </head>
sql_js_tag = '    <script src="https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.11.0/sql-wasm.js"></script>'
content = content.replace('</head>', f'{sql_js_tag}\n</head>')

with open(index_path, 'w') as f:
    f.write(content)

print("Added sql.js CDN script to web/index.html")
