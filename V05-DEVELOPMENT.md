# Version 0.5 development

This working change is not a validated release. VERSION remains the last packaging release until 0.5 is ready.

- Remove experimental LCD JPG/BMP/PNG transfer methods, their command handlers and image buffers. Retired command IDs are not reused.
- Remove the unrelated startup PSRAM allocation experiment. Keep audio buffers and memory-status queries.
- Resolve M5.getBoard() names using the installed M5GFX src/lgfx/boards.hpp enum instead of a short hard-coded table. Unknown IDs retain their numeric value in the returned text. Names now use upstream enum spelling without the board_ prefix.
- prepareForM5Stack already invokes patchArduinoUtilityV3. Limit its selection list to ESP32/ESP32-S3; cancellation must not silently select another board.
- Fail before writing Utility.m if patch targets are missing or ambiguous, and retain an existing backup.

## Required validation before release

- Check the patch against the exact installed MathWorks Utility.m and confirm the selected BoardName is used by both compile and upload commands, including ESP32-S3 chip selection and board options.
- Validate the board profiles and partition sizes against the installed Arduino core; the inherited profile table is not yet certified for every model.
- Test first patch, repeat patch, upgrade from V2, cancellation, unsupported Utility layout, and restoration from backup on disposable fixtures before touching the live support package.
- Compile and upload on ESP32 and ESP32-S3 hardware; confirm board identity, memory status, LCD text/shapes, and retained audio functionality.
- Do not reuse cached firmware from 0.4.x when testing the removed commands.
- Review generated HTML help before release; it still describes historical APIs.

Board definitions: https://github.com/m5stack/M5GFX/blob/master/src/lgfx/boards.hpp
