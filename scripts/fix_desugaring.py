#!/usr/bin/env python3
"""Fix android/app/build.gradle.kts to enable desugaring."""
import re, sys

path = "android/app/build.gradle.kts"
with open(path, "r") as f:
    content = f.read()

# 1. Enable desugaring in compileOptions
content = content.replace(
    "compileOptions {\n        sourceCompatibility",
    "compileOptions {\n        isCoreLibraryDesugaringEnabled = true\n        sourceCompatibility"
)

# 2. Add coreLibraryDesugaring dependency
content = content.replace(
    "dependencies {",
    'dependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")'
)

with open(path, "w") as f:
    f.write(content)

# Verify
with open(path, "r") as f:
    text = f.read()

if "isCoreLibraryDesugaringEnabled = true" in text:
    print("OK: desugaring enabled")
else:
    print("ERROR: desugaring not enabled", file=sys.stderr)
    sys.exit(1)

if "coreLibraryDesugaring" in text:
    print("OK: desugaring dependency added")
else:
    print("ERROR: desugaring dependency not added", file=sys.stderr)
    sys.exit(1)
