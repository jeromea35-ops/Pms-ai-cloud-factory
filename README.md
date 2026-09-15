# PMS AI Cloud Factory — Android ARM64 sd-cli

Scope: Realme RMX3997 / PMS_AI_CURRENT only.
Vivo is explicitly out of scope.

## Locked target
- stable-diffusion.cpp commit: `59c23bce0d82be3a922023ab811194f05b3e2faa`
- Android ABI: `arm64-v8a`
- Android API: 28
- CPU-only runtime
- OpenMP OFF
- WebP/WebM OFF
- Static C++ STL
- No AI model download in the build workflow

## Factory workflow
`.github/workflows/android-arm64-sd-cli.yml`

The workflow clones the pinned upstream source, initializes its pinned submodules,
cross-compiles with the Android NDK, verifies the ELF machine is AArch64,
strips the binary, generates checksums, and uploads a short-lived artifact.
## Phone verification
After downloading the artifact to the phone, place its contents in a runtime
folder and run:

```bash
./scripts/phone-smoke-test.sh "$HOME/pms-sd-runtime"
```

PASS requires `sd-cli --help` to execute successfully on the Realme phone.
Only after that PASS should a lightweight/quantized model be downloaded.

## Safety
This staging bundle does not touch PMS_AI_CURRENT production files, databases,
port 8787, credentials, publishing, or the existing 94-object local build cache.
