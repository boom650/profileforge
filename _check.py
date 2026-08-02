import sys

filepath = sys.argv[1]

with open(filepath) as f:
    lines = f.readlines()

depth = 0
for i, line in enumerate(lines):
    stripped = line.rstrip()
    old_depth = depth
    for ch in stripped:
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
    if i >= 710 or (old_depth <= 2 and depth < old_depth and old_depth <= 2):
        ln = i + 1
        print(f"L{ln:4d}: d={old_depth}->{depth} | {stripped}")
