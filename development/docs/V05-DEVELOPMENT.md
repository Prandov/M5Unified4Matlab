# Version 0.5.1 release checklist

Status: release candidate, not yet published. VERSION and the main MATLAB/C++ headers identify 0.5.1. This release includes the 0.5 candidate work and the MATLAB Project/toolbox packaging transition. Do not publish v0.5.1 until the release checks below pass.

See [V05-AUDIT.md](V05-AUDIT.md) for the tag-to-candidate review, approval questions, and source comment markers.

## Current scope

- prepareForM5Stack invokes patchArduinoUtilityV3 for board-profile selection. All listed boards remain selectable, including C3/P4; untested profiles must not be described as validated support.
- The patch preserves UtilityOriginalUnpatched.m, saves a clean Utility.m from that backup, applies modifications in memory, and saves the patched file only after all sections succeed. Writes are checked and read back. A patching failure leaves the clean working copy in place.
- An existing backup is authoritative: it must belong to the installed support-package release. The patch does not automatically determine its provenance.
- getM5Type uses the expanded static M5GFX board-ID switch. Utilities/boardNameFromId.m is documented and available for future use, but its call remains commented out.
- Experimental JPG/BMP/PNG methods, active handlers, image buffers, and the startup allocation experiment are removed. Historical IDs, API notes, and handler placeholders remain comments only; IDs are not reused. Audio and memory-status functionality remain.
- Ultra Basic takes a manually entered m5SerialPort and creates the esp32 and m5u objects. Standard (formerly Basic) prompts for a port number. Premium (formerly Advanced) retains USBDeviceEnumerator and assignin to the base workspace. Its NeoPixel creation and traffic-light writes are disabled unless testNeoPixels is true. The two renamed scripts retain their existing build and reuse settings.
- Generated HTML, its demo entry, installed resources, and autosave files are excluded from the source package. MATLAB does not automatically republish HTML on installation.

## Evidence so far

- MATLAB R2026a disposable-file tests passed for read-only originals, first patch, rebuilding from a backup, repeated patching, patched-source rejection, and failure recovery. The live MathWorks file was not modified by these automated tests.
- Thirty static board-ID mappings were checked against the installed M5GFX header; the deferred parser and unknown-ID fallback were also checked.
- Earlier simulated port-name tests targeted a superseded Basic script; they do not validate the current numeric menu. Test the current scripts on macOS.
- Eric reported successful patch execution and successful device use after recreating the Arduino, M5Unified, and NeoPixel objects. The initial connection/I/O failure remains unexplained.

## Before publishing v0.5.1

- [ ] Commit the final scripts and metadata, and use that exact commit for testing.
- [ ] On the Mac, record the commit, macOS version, MATLAB release, Arduino support-package version, ESP32 core version, M5Unified/M5GFX versions, and board model.
- [ ] Start a fresh MATLAB session and confirm only the intended add-on copy is on the path. Use a backup of Utility.m from that same support-package installation.
- [ ] Build/upload fresh firmware for the candidate rather than reuse cached 0.4.x firmware. Confirm the selected board profile is used.
- [ ] Edit m5SerialPort in Ultra Basic and test in a fresh workspace; confirm esp32 and m5u connect without a port-selection window. Test Premium's USB selection, placeholder rejection and cancellation. Test Standard's numeric input, including empty, vector, out-of-range and valid scalar choices.
- [ ] Connect on the first attempt. Display m5u and inspect m5Type, lcdResolution, and batteryLevel; verify LCD text/shapes and memory status. Check retained audio at low volume if available.
- [ ] Run Premium with testNeoPixels false; then set it true on Core2 for AWS and verify the three LEDs on D25. If the first connection fails again, capture the complete error and TraceOn output before clearing objects.
- [ ] Reconnect using compatible installed firmware without forcing a build. Expect no board-profile dialog. Compare with a forced update, where the dialog should appear for M5Unified.
- [ ] Repeat from a fresh session to check reproducibility; do not treat successful reuse of existing objects as a fresh-connection test.
- [ ] Download/package the exact candidate revision and test installation from that artifact, not just the development checkout. Check for duplicate add-on copies and unwanted resources, autosaves, or generated HTML.
- [ ] Record pass/fail results and tested configurations. Resolve or explicitly document remaining limitations, then finalize release notes and publish the v0.5.1 release.

A full automated hardware-in-the-loop suite is deferred. Broader ESP32-S3 and RISC-V validation is separate from the Core/Core2 smoke test; do not advertise untested boards as verified.

Board definitions: https://github.com/m5stack/M5GFX/blob/master/src/lgfx/boards.hpp
