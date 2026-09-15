#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

RUNTIME_DIR="${1:-$HOME/pms-sd-runtime}"
BIN="$RUNTIME_DIR/sd-cli"

echo "=== PMS SD-CLI PHONE SMOKE TEST ==="
echo "runtime=$RUNTIME_DIR"
echo "device_arch=$(uname -m)"

if [ ! -f "$BIN" ]; then
  echo "FAIL: sd-cli missing: $BIN"
  exit 2
fi

chmod +x "$BIN"

if [ -f "$RUNTIME_DIR/SHA256SUMS" ]; then
  echo "=== CHECKSUM ==="
  (cd "$RUNTIME_DIR" && sha256sum -c SHA256SUMS)
fi

echo "=== BINARY ==="
command -v file >/dev/null 2>&1 && file "$BIN" || true
echo "=== HELP TEST ==="
set +e
"$BIN" --help >/tmp/pms-sd-cli-help.txt 2>&1
RC=$?
set -e
cat /tmp/pms-sd-cli-help.txt | head -40 || true

if [ "$RC" -ne 0 ]; then
  echo "FAIL: sd-cli --help rc=$RC"
  exit "$RC"
fi

echo "PASS: sd-cli executes on this phone"
echo "No model inference was attempted."
