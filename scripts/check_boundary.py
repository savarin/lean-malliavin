#!/usr/bin/env python3
"""Boundary check: signatures elaborate and axioms are clean.

Adapted from the formalization starter kit's check_boundary.py.
"""
import json
import pathlib
import re
import subprocess
import sys

AXIOMS_RE = re.compile(r"'([^']+)' depends on axioms: \[(.*)\]")
NO_AXIOMS_RE = re.compile(r"'([^']+)' does not depend on any axioms")


def fail(msg):
    print(f"FAIL: {msg}")
    sys.exit(1)


def run_lean(path):
    proc = subprocess.run(["lake", "env", "lean", str(path)],
                          capture_output=True, text=True)
    return proc.returncode, proc.stdout + proc.stderr


def main():
    manifest = pathlib.Path(sys.argv[1] if len(sys.argv) > 1
                            else "comparator.json")
    if not manifest.is_file():
        fail(f"{manifest} not found")
    m = json.loads(manifest.read_text())

    challenge = pathlib.Path(f"{m['challenge_module']}.lean")
    modules = [m["solution_module"]]
    theorems = m["theorem_names"]
    permitted = set(m["permitted_axioms"])

    print("=== Boundary check ===")
    if not challenge.is_file():
        fail(f"{challenge} not found")

    print(f"[1/2] Elaborating {challenge} ...")
    code, out = run_lean(challenge)
    if code != 0:
        print(out.rstrip())
        fail("challenge file does not elaborate — a signature changed")
    print("  PASS: signatures match")

    print("[2/2] Auditing axioms ...")
    scratch = pathlib.Path("_axiom_check.lean")
    scratch.write_text("".join(f"import {mod}\n" for mod in modules)
                       + "".join(f"#print axioms {t}\n" for t in theorems))
    try:
        code, out = run_lean(scratch)
    finally:
        scratch.unlink(missing_ok=True)
    print(out.rstrip())
    if code != 0:
        fail("axiom check did not elaborate")

    # Join continuation lines (Lean wraps long axiom lists with leading whitespace)
    joined = []
    for line in out.splitlines():
        if joined and line and line[0] == ' ':
            joined[-1] += ' ' + line.strip()
        else:
            joined.append(line)

    seen = {}
    for line in joined:
        mo = AXIOMS_RE.match(line)
        if mo:
            seen[mo.group(1)] = {a.strip() for a in mo.group(2).split(",")
                                 if a.strip()}
            continue
        mo = NO_AXIOMS_RE.match(line)
        if mo:
            seen[mo.group(1)] = set()

    bad = False
    for t in theorems:
        if t not in seen:
            print(f"  FAIL: no axiom report for {t}")
            bad = True
            continue
        extra = seen[t] - permitted
        if extra:
            print(f"  FAIL: {t} uses non-permitted axioms {sorted(extra)}")
            bad = True
        else:
            print(f"  ok: {t} uses only permitted axioms")
    if bad:
        fail("axiom audit failed")
    print("  PASS: axioms clean")
    print("=== BOUNDARY CHECK PASSED ===")


if __name__ == "__main__":
    main()
