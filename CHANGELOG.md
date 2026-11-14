# Changelog

## 0.5.2 - Documentation and distribution refresh

- Publish the documentation refresh under a distinct toolbox version so File Exchange and Add-Ons can identify it as an update.
- Expand the live Getting Started page with Documentation, Preparation, and Connection Scripts sections, descriptions, a preparation-script link, a release label, and separated attribution.
- Resize the four separate board images to 120 pixels tall and reorganize the README sections.
- Consolidate build scripts, tests, developer notes, and documentation images under development; update project and packaging references.
- Synchronize package, source labels, patch marker, and displayed library version to 0.5.2. No functional library or connection changes.

## 0.5.1 - Project and toolbox packaging (published)

- Name the MATLAB Project and its entry file M5Unified4Matlab to match the GitHub repository.
- Restore the original MATLAB/M5Stack/York U/Arduino collage as the toolbox image.
- Set Eric Prandovszky as the release author; retain contributor credits in the source and README.
- Defer generated HTML documentation from the release while it is revised.
- Bundle local board images for the README and use standard Markdown image links.
- Center the Premium serial-port selector before displaying it, retaining its dropdown and fixed size.
- Close temporary Utility files before deleting them after write failures; retain the original write error and existing Utility/backup contents.
- Package from a flat staging root so the library folder is not duplicated inside the installed add-on folder; verify root files and installed path entries in GitHub Actions.
- Add the M5Unified MATLAB Project, project paths, and build shortcuts.
- Keep setup instructions in README.md and connection scripts; provide GettingStarted.mlx with immediately usable navigation links and no Run step.
- Build an explicit `.mltbx` release with `buildToolbox`, reading the version from VERSION and preserving the existing add-on UUID.
- Include the wrapper, C++ header, utilities, examples, license, images, and user documentation; exclude development metadata and installed artifacts.
- Add a GitHub Actions workflow to build installers on demand and prepare a draft GitHub release on version-tag pushes.
- Retain buildDocumentation as an optional development-only HTML preview using evalCode=false.
- Keep preparation manual: opening the project and building the installer do not patch MathWorks files, download Arduino libraries, or connect to hardware.
- Includes the preceding 0.5 candidate changes below. The user confirmed installation, firmware rebuild/upload and device operation, plus working installation from File Exchange and Add-Ons Explorer. Broader board/peripheral coverage remains unverified.

Future work: support the legacy Arduino library location before R2024a and verify the corresponding Utility patch. The current preparation requirement remains R2024a or later.

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
