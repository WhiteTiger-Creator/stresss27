#!/usr/bin/env bash
set -uo pipefail

mkdir -p /logs/verifier

# Always leave a reward behind, even on an early failure, so the verifier never
# finishes without writing /logs/verifier/reward.txt.
echo 0 > /logs/verifier/reward.txt

if [ "$PWD" = "/" ]; then
    echo "Error: No working directory set. Please set a WORKDIR in your Dockerfile before running this script."
    exit 0
fi

CANDIDATE_USER="${CANDIDATE_USER:-snapshot-candidate}"

# --- Real OS-level isolation of the verifier + reference trees from the candidate ---
# Candidate-controlled code (the CLI and the repaired pipeline) runs as an
# unprivileged user that CANNOT read /tests or /solution, so it cannot copy the
# reference implementation or expected outputs (even via os.open/os.read) and
# hardcode them. pytest itself stays root so it can still read the locked trees.
if [ "$(id -u)" = "0" ] && id "$CANDIDATE_USER" >/dev/null 2>&1; then
    for locked in /tests /solution; do
        if [ -d "$locked" ]; then
            chown -R root:root "$locked" 2>/dev/null || true
            chmod 700 "$locked" 2>/dev/null || true
            find "$locked" -mindepth 1 -exec chmod go-rwx {} + 2>/dev/null || true
        fi
    done

    mkdir -p /app/output
    chmod 0777 /app/output 2>/dev/null || true
    chown -R "$CANDIDATE_USER":"$CANDIDATE_USER" /app/workflow /app/output 2>/dev/null || true

    # Re-establish the authoritative /app/output from an UNPRIVILEGED candidate run,
    # so a pipeline that depends on reading /tests or /solution fails here.
    runuser -u "$CANDIDATE_USER" -- \
        python3 /app/snapshot_audit.py repair --output-dir /app/output \
        >/logs/verifier/candidate_repair.log 2>&1 || true
fi

set +e

python3 -m pytest -o cache_dir=/tmp/pytest_cache \
  --ctrf /logs/verifier/ctrf.json /tests/test_outputs.py -rA
RC=$?

if [ "$RC" -eq 0 ]; then
    echo 1 > /logs/verifier/reward.txt
else
    echo 0 > /logs/verifier/reward.txt
fi
