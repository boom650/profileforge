#!/usr/bin/env python3
"""Fix android/app/build.gradle.kts to enable desugaring."""
import sys

path = "android/app/build.gradle.kts"
with open(path, "r") as f:
    content = f.read()

# 1. Enable desugaring in compileOptions
if "isCoreLibraryDesugaringEnabled = true" not in content:
    content = content.replace(
        "compileOptions {\n",
        "compileOptions {\n        isCoreLibraryDesugaringEnabled = true\n"
    )
    print("OK: desugaring enabled in compileOptions")
else:
    print("OK: desugaring already enabled")

# 2. Add coreLibraryDesugaring dependency (before existing dependencies)
desugar_dep = '    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")\n'
if "coreLibraryDesugaring" not in content:
    # Try multiple patterns for dependencies block
    if "dependencies {" in content:
        content = content.replace("dependencies {", "dependencies {\n" + desugar_dep, 1)
        print("OK: desugaring dependency added")
    elif "dependencies\n{" in content:
        content = content.replace("dependencies\n{", "dependencies\n{\n" + desugar_dep, 1)
        print("OK: desugaring dependency added (alt format)")
    else:
        # Append at end of file
        content = content.rstrip() + "\n\n" + "dependencies {\n" + desugar_dep + "}\n"
        print("OK: desugaring dependency appended")
else:
    print("OK: desugaring dependency already present")

with open(path, "w") as f:
    f.write(content)

# Verify
with open(path, "r") as f:
    text = f.read()

ok = True
if "isCoreLibraryDesugaringEnabled = true" not in text:
    print("ERROR: desugaring not enabled", file=sys.stderr)
    ok = False
if "coreLibraryDesugaring" not in text:
    print("ERROR: desugaring dependency missing", file=sys.stderr)
    ok = False

if ok:
    print("ALL OK")
else:
    print("FAILED", file=sys.stderr)
    sys.exit(1)
