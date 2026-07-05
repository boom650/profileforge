#!/usr/bin/env python3
"""Strip native-only packages from pubspec.yaml for web builds.
These packages use dart:ffi/dart:io and cannot compile for web.
Web-compatible alternatives or stubs are used instead."""
import re, sys

NATIVE_PACKAGES = {
    'sqlite3_flutter_libs': 'Native sqlite3 binaries (drift web backend used instead)',
    'flutter_local_notifications': 'Not available on web',
    'flutter_secure_storage': 'Replaced by SharedPreferences-based web stub',
    'geolocator': 'Web geolocation not needed for testing',
    'permission_handler': 'Not applicable on web',
    'path_provider': 'Not needed on web (SharedPreferences used instead)',
}

with open('pubspec.yaml', 'r') as f:
    content = f.read()

removed = []

for pkg, reason in NATIVE_PACKAGES.items():
    # Match lines like "  sqlite3_flutter_libs: ^0.5.20"
    pattern = rf'^([ \t]*-?\s*{re.escape(pkg)}:.*)$'
    match = re.search(pattern, content, re.MULTILINE)
    if match:
        line = match.group(1)
        content = content.replace(line, f'  # [web-build] {line.strip()}  # {reason}')
        removed.append(pkg)

if removed:
    with open('pubspec.yaml', 'w') as f:
        f.write(content)
    print(f"Commented out {len(removed)} native packages for web build:")
    for pkg in removed:
        print(f"  - {pkg} ({NATIVE_PACKAGES[pkg]})")
else:
    print("ERROR: No native packages found to remove")
    sys.exit(1)
