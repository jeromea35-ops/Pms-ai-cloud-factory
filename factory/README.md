# PMS AI Local Engine Factory

Purpose: do the expensive preparation work in cloud CPU, then move an assembly-ready local package to Android ARM64.

Final inference must remain local/offline. Cloud is a build/verification factory, not a runtime dependency.

## Primary target

- Android ARM64
- 8 GB physical RAM class device
- Sequential model load/unload
- No paid API fallback
- No mandatory cloud bridge during video generation

## Cloud responsibilities

1. Build Android ARM64 native runtimes.
2. Download exact model revisions.
3. Verify hashes and licenses.
4. Use pre-quantized weights where available.
5. Convert/quantize in cloud when required and license-compatible.
6. Produce manifests, checksums and install-ready layouts.
7. Run host-side smoke/quality proofs where meaningful.
## Device responsibilities

The phone should only do work that must be device-specific:

- install/fix local paths
- hash verification
- actual model load
- local inference
- RAM/thermal measurement
- output-quality checks
- final PMS integration

## Current pack order

1. `VISUAL_PACK_V1` — SD1.5 Q4 + Android ARM64 `sd-cli`.
2. `TAMIL_VOICE_PACK_V1` — local Piper Tamil female/male fallback voices.
3. `LIPSYNC_PACK_V1` — gated until runtime/license/RAM verification.
4. `MOTION_PACK_V1` — gated until 8 GB Android feasibility proof.
5. `SINGING_PACK_V1` — gated until a suitable local model is selected.

A technical PASS is not a visual-quality PASS. Real video output still has to pass the PMS quality gate.
