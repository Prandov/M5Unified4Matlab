# MATLAB Project and toolbox releases

Open `M5Unified4Matlab.prj` in MATLAB to work on this library. The project adds the
repository root and the library, Utilities, and Examples folders to the path
for the project session. Closing the project restores the previous path.
Project startup does not run preparation scripts or connect to hardware.

The project definition is committed with the source. After cloning, open
`M5Unified4Matlab.prj` directly; no project-creation script is required.

## Build an installer

In MATLAB R2024a or later, from this repository's root, run:

```matlab
installer = buildToolbox;
```

The output is `release/M5Unified-0.5.1.mltbx` for the current `VERSION`.
`toolboxOptions.m` defines metadata and installation paths; `toolboxFileList.m`
defines the explicit release file list. Update that list when adding files needed by users. It
includes the MATLAB wrapper, C++ header, utilities, examples, images, license,
README with local board images, changelog, version, and the live navigation page. Development and
project files are excluded. Building does not install the result or run any
library code. No MATLAB Compiler license is needed.

The build copies the listed release files into a temporary staging folder and
uses that folder as the toolbox root. MATLAB creates the outer add-on folder
during installation; `+arduinoioaddons`, `Utilities`, `Examples`, connection
scripts, and documentation are placed directly inside it. The repository's
`M5Unified Add-On Library for Arduino` folder is not repeated inside the
installed add-on folder. Staging is removed after the build.

The GitHub workflow checks this layout and the installed MATLAB paths with
`python tests/verify_toolbox_layout.py release/*.mltbx`.

The release includes GettingStarted.mlx, a text-only Live Editor navigation page.
Its links are usable immediately when opened from Add-Ons > Open Documentation;
there is no Run step and it does not connect to hardware. Edit this file in the
Live Editor to maintain the navigation page. README.md remains the setup guide,
and connection scripts remain the runnable examples. README board images use
standard Markdown and packaged local files under images/boards, so they do not
depend on remote image loading in a Markdown viewer. A GitHub README link is
also available from the live page.

Generated wrapper HTML and its Help registration are omitted from this release
while the HTML is revised. buildToolbox does not publish HTML. buildDocumentation
is retained as an optional development preview, with evalCode=false; its output
is ignored by Git and is not packaged.

Keep identifier `b313688e-800a-415f-b056-b41df863d83c` unchanged across releases;
it matches the existing 0.4.9 add-on. Change `VERSION` before a new release and
keep the MATLAB and C++ source version headers and changelog in sync.

## Install and check a release

Double-click the `.mltbx` file in MATLAB and review the installation dialog.
The installer adds the library parent, Utilities, and Examples to the path.
GettingStarted.mlx is registered as the installer/Add-Ons documentation entry.
It displays navigation links as formatted text without executing any code.
Use README.md for preparation and connection instructions. Install MATLAB
Support Package for Arduino Hardware separately. NeoPixel Add-On Library for
Arduino is also needed by the Standard and Premium examples unchanged.
Arduino C++ libraries are downloaded by the existing manual preparation script.

Before a hardware test, close the development project and remove any manually
added source-copy paths so the installed copy is the one MATLAB resolves:

```matlab
which arduinoioaddons.M5Stack.M5Unified -all
which prepareForM5Stack -all
```

Run `prepareForM5Stack` explicitly after reviewing its effects. Follow the
hardware release checks in `V05-DEVELOPMENT.md`. Creating an installer does not
validate firmware upload or device behavior. The R2024a minimum reflects the
original development release; it is not a claim of testing on every release.
MATLAB Online is excluded because this workflow depends on local hardware
and support-package preparation.

Commit `M5Unified4Matlab.prj` and `resources/project` with the source. Generated
installers under `release` are ignored by Git; attach the tested installer to
the GitHub release when publishing.

The project and local repository folder are named `M5Unified4Matlab`, matching
the GitHub repository. Build scripts derive paths from their own location.
The toolbox image is `images/M5Unified4Matlab.png`, copied unchanged from the
historical File Exchange screenshot. It contains the MATLAB, M5Stack, York U,
and Arduino logos. This is existing artwork, not an AI-generated image.

## GitHub Actions

`.github/workflows/toolbox-release.yml` uses MATLAB R2026a and the same
`buildToolbox` function as a local build. The packaging job needs MATLAB only;
it does not install the Arduino support package or access hardware. Official
MATLAB Actions provide licensing for this public repository without a batch
licensing secret. A private repository would require a suitable licensing setup.

After committing and pushing the workflow, run **Actions > Build MATLAB toolbox >
Run workflow** to build a downloadable installer artifact without creating a
release. To prepare a release, first commit all intended source and metadata,
then create and push a tag matching VERSION, for example `v0.5.1`. The workflow
checks the tag against VERSION, builds the installer, and creates a **draft**
GitHub release containing the `.mltbx` and its SHA-256 checksum. It does not
publish the release automatically. An existing release with the same tag is
not overwritten; a rerun can still supply a new build artifact for inspection.

Download and test that exact installer, complete the hardware checklist, and
review the generated release notes before publishing the draft. With the
existing File Exchange listing configured to follow GitHub Releases, File
Exchange uses an attached `.mltbx` as the download; without one it uses the ZIP
release asset. Match the toolbox version to the release version and verify the
upgrade from an older installed add-on. Keep the same File Exchange listing.

The workflow has been prepared locally; a successful run on GitHub is still
required to verify runner setup, permissions, and release attachment end to end.
