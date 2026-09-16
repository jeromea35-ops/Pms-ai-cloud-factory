#!/usr/bin/env bash
set -euo pipefail

DEST="${1:-$HOME/PMS_LOCAL_ENGINE}"
mkdir -p "$DEST/models/visual/sd15-q4" \
         "$DEST/models/voice/ta-rasa-female-medium" \
         "$DEST/models/voice/ta-rasa-male-medium" \
         "$DEST/manifests"

fetch_verified() {
  local url="$1"
  local out="$2"
  local sha="$3"
  mkdir -p "$(dirname "$out")"
  if [ -f "$out" ] && echo "$sha  $out" | sha256sum -c --status; then
    echo "verified existing: $out"
    return 0
  fi
  curl --fail --location --retry 5 --retry-delay 3 --continue-at - \
    --output "$out.part" "$url"
  mv "$out.part" "$out"
  echo "$sha  $out" | sha256sum -c --strict
}
SD_REV='f41080936c76af537542aedf67f0dab94e1f337f'
SD_FILE='stable-diffusion-v1-5-pruned-emaonly-Q4_0.gguf'
SD_SHA='b8944e9fe0b69b36ae1b5bb0185b3a7b8ef14347fe0fa9af6c64c4829022261f'
SD_URL="https://huggingface.co/second-state/stable-diffusion-v1-5-GGUF/resolve/$SD_REV/$SD_FILE"

F_REV='89e15edafc8b31e66ddf25f2adbe3bd3f20a9496'
M_REV='0b041f8e882b1e6f41f427169be25bcb0e94f352'
F_BASE="https://huggingface.co/tinisoft/piper-ta_IN-rasa_female-medium/resolve/$F_REV"
M_BASE="https://huggingface.co/tinisoft/piper-ta_IN-rasa_male-medium/resolve/$M_REV"

fetch_verified "$SD_URL" "$DEST/models/visual/sd15-q4/$SD_FILE" \
  'b8944e9fe0b69b36ae1b5bb0185b3a7b8ef14347fe0fa9af6c64c4829022261f'

fetch_verified "$F_BASE/ta_IN-rasa_female-medium.onnx" \
  "$DEST/models/voice/ta-rasa-female-medium/ta_IN-rasa_female-medium.onnx" \
  '1befd7c4034429cecf3143d5eab4810b29833420aedb951bef4092779d074d59'

fetch_verified "$F_BASE/ta_IN-rasa_female-medium.onnx.json" \
  "$DEST/models/voice/ta-rasa-female-medium/ta_IN-rasa_female-medium.onnx.json" \
  'e49a5f947bfe64bc232d9f900a163b3b771b812780fd8efe0d411a3d8f4b4ee2'
fetch_verified "$M_BASE/ta_IN-rasa_male-medium.onnx" \
  "$DEST/models/voice/ta-rasa-male-medium/ta_IN-rasa_male-medium.onnx" \
  '0df057808d684ce59e3fd1cb02d6bfd5ef860d14a9e3c515c65ca5c61062ce39'

fetch_verified "$M_BASE/ta_IN-rasa_male-medium.onnx.json" \
  "$DEST/models/voice/ta-rasa-male-medium/ta_IN-rasa_male-medium.onnx.json" \
  'b4e9c2b637d80f4a6de1be6ffd6c7ae1bc97a1420698e2bf9df7fedc352488d1'

MANIFEST="$(cd "$(dirname "$0")/.." && pwd)/factory/LOCAL_MODEL_MANIFEST.json"
if [ -f "$MANIFEST" ]; then
  cp "$MANIFEST" "$DEST/manifests/LOCAL_MODEL_MANIFEST.json"
fi

cat > "$DEST/manifests/PACK_STATUS.txt" <<EOF
status=VERIFIED_DOWNLOAD_COMPLETE
inference_network_required=false
paid_api_fallback_allowed=false
visual_pack=SD1.5_Q4
voice_pack=PIPER_TAMIL_FEMALE_MALE
EOF

echo "PMS local model pack download and hash verification PASS: $DEST"
