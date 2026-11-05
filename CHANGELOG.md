# Changelog

## 0.5 - Release candidate (not yet published)

- Use the V3 MathWorks Utility patch for M5Stack board-profile selection. All listed profiles remain selectable, including C3/P4; selection does not imply validated support.
- Rebuild Utility.m from its preserved unpatched backup, saving a clean working copy before modifying it. Verify saved contents and stop on missing or ambiguous patch targets.
- Expand the static getM5Type board-ID switch. Retain the documented Utilities/boardNameFromId.m parser and its commented call for future use.
- Remove experimental image commands and image-buffer allocation while retaining commented reference material. Keep audio and memory-status functionality.
- Correct StickC Plus2 PSRAM metadata to 2 MB; this does not independently enable PSRAM in the build configuration.
- Add connectToM5StackUltraBasic.m: set m5SerialPort manually and create the esp32 and m5u objects. Rename connectToM5StackBasic.m to connectToM5StackStandard.m and connectToM5StackAdv.m to connectToM5StackPremium.m; update callers using the old filenames.
- Fix connection-script port capitalization and NeoPixel example names. Standard validates a numbered menu choice without evaluating user input. Premium retains USB-only enumeration and base-workspace assignment, with cancellation and placeholder handling. Its Core2 for AWS traffic-light test is opt-in (`testNeoPixels = true`).
- Remove stale generated HTML documentation and its demo entry; ignore the generated class-documentation folder.

Release gate: test the final candidate on macOS from a fresh MATLAB session and validate the packaged download. The earlier first-connection I/O failure is not yet explained. See V05-DEVELOPMENT.md for checks and test scope.

## 0.4.9.2 - Packaging correction

- Remove stale File Exchange installation metadata and the embedded ZIP from the package's resources folder.
- Remove the MATLAB autosave backup from the distributed package.
- Record the package version in VERSION and synchronize the main MATLAB/C++ header comments.
- Preserve source ZIP distribution and canonical library filenames. No runtime code changes.

Installation through File Exchange/Add-On Explorer and hardware testing are pending.
