#!/usr/bin/env python3
"""Strip native-only packages from pubspec.yaml for web builds.
These packages use dart:ffi/dart:io and cannot compile for web.
Web-compatible alternatives or stubs are used instead."""
import re, sys

NATIVE_PACKAGES = {
    'sqlite3_flutter_libs': 'Native sqlite3 binaries (use drift web backend)',
    'flutter_local_notifications': 'Not available on web',
    'flutter_secure_storage': 'Replaced by SharedPreferences-based web stub',
    'geolocator': 'Web uses html5_geolocation or similar',
    'permission_handler': 'Not applicable on web',
    'video_player': 'Not used in web build',
}

with open('pubspec.yaml', 'r') as f:
    content = f.read()

original = content
removed = []

for pkg, reason in NATIVE_PACKAGES.items():
    # Match the dependency line (handles both '- package: ^x.y' and '- package: x.y')
    pattern = rf'^([ \t]*-\s*{re.escape(pkg)}:.*$)'
    match = re.search(pattern, content, re.MULTILINE)
    if match:
        line = match.group(1)
        # Comment it out instead of removing (preserves formatting context)
        content = content.replace(line, f'  # [web-build] {line.strip()}  # {reason}')
        removed.append(pkg)

if removed:
    with open('pubspec.yaml', 'w') as f:
        f.write(content)
    print(f"Removed {len(removed)} native packages for web build:")
    for pkg in removed:
        print(f"  - {pkg} ({NATIVE_PACKAGES[pkg]})")
else:
    print("No native packages found to remove")
