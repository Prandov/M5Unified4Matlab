# M5Unified Add-On Library for Arduino

Use MATLAB to control the display, power management, and other built-in peripherals on an M5Stack device. This add-on extends the MATLAB Support Package for Arduino Hardware using the M5Unified and M5GFX Arduino libraries.

<img src="https://github.com/user-attachments/assets/0213adc5-5ff2-47d4-9160-c0baa1d4e117" height="100" alt="M5Stack Core">
<img src="https://github.com/user-attachments/assets/b78d10e2-06be-4d6a-a0c0-23581f3cf67a" height="100" alt="M5Stack Core2">
<img src="https://github.com/user-attachments/assets/d51304a9-edea-418e-b7f2-7caba869876d" height="100" alt="M5Stack Core2 for AWS">
<img src="https://github.com/user-attachments/assets/618dc43e-1edb-4f4d-ac0c-23d9d03798ef" height="100" alt="M5StickC Plus">

## Required Items

1. MATLAB.
2. MATLAB Support Package for Arduino Hardware.
3. M5Unified Add-On Library for Arduino (this add-on).
4. Use an [M5Unified](https://github.com/m5stack/M5Unified)-compatible device with an ESP32 or ESP32-S3 processor. Check the MathWorks [Supported Hardware](https://www.mathworks.com/help/matlab/supportpkg/supported-hardware.html) list for your MATLAB release.
5. The M5Unified and M5GFX Arduino libraries, installed by the preparation script below.
6. NeoPixel Add-On Library for Arduino: optional for your own connection script; required to run the Standard or Premium examples unchanged.”.

## Prepare MATLAB

After installing items 1 to 3 above, open the add-on's `Utilities` folder in MATLAB and run: `prepareForM5Stack`

This runs `patchArduinoUtilityV3` to enable M5Stack board selection during a server build, then runs `installArduinoLibsFromGitHub` to install the required Arduino libraries. Do this once each time you update to a new version of MATLAB, MATLAB Support Package for Arduino Hardware or this library.

## Connecting to the M5Stack

1. Connect to the M5Stack by creating an `arduino` object.
   -  For an original **ESP32** device such as the Core2 for AWS, use `'ESP32-WROOM-DevKitC'` as the MATLAB board type. Select your actual M5Stack model when prompted during the build.
   -  To find the **Serial port**, run `serialportlist` in the MATLAB Command Window. If several ports appear, compare the list before and after connecting the M5Stack by USB. Replace `'COM6'` with your device's port.

   ```matlab
   m5SerialPort = 'COM6';  % Replace with your port, e.g. '/dev/cu.SLAB_USBtoUART' on macOS.
   esp32 = arduino(m5SerialPort, 'ESP32-WROOM-DevKitC', 'Libraries', {'M5Stack/M5Unified'});
   ```
2. Create an M5Unified object to control the built-in peripherals on the M5Stack.

   ```matlab
   m5u = addon(esp32, 'M5Stack/M5Unified');
   ```

## Controlling the M5Stack

Use `esp32` for pin I/O, I2C, and serial communication. For example, if D33 is available as an analog input on your board:

```matlab
pinVolts = readVoltage(esp32, 'D33');
```
Use `m5u` for built-in peripherals supported by the M5Unified Library. These examples read the board identity, write to the LCD, and read the battery charge and voltage. 

```matlab
boardName = m5u.getM5Type();
m5u.lcdPrintLn('Hello from MATLAB');
batteryPercent = m5u.powerGetBatteryLevel();
batteryMillivolts = m5u.powerGetBatteryVoltage();
```
## Contributors and Development

Open `M5Unified4Matlab.prj` to work in the MATLAB Project. To build a release installer,
run `buildToolbox` from the repository root. See [PACKAGING.md](PACKAGING.md)
for the build, installation, and release workflow.

Developed by Eric Prandovszky in collaboration with Greatlove Bariboloka.

Development began with the MATLAB-generated ArduinoServer in a separate PlatformIO repository, where we compiled, uploaded, and tested the C++ implementation. We wrote the MATLAB interface directly in MATLAB and synchronized the two periodically before bringing the add-on components together here.

## Notes

- Development has primarily used the **M5Stack Core2 for AWS**. A selectable board profile does not mean that board has been tested.
- The `patchArduinoUtilityV3` script modifies `+arduinoio/+internal/Utility.m` in the MathWorks Arduino support package and saves `UtilityOriginalUnpatched.m` **in the same directory**. Run `which('arduinoio.internal.Utility')` to see the full path on your machine.
- Originally developed with MATLAB R2024a. See the [changelog](CHANGELOG.md) and [release checklist](V05-DEVELOPMENT.md).

## Reference Connection Scripts

These scripts are examples of ways to connect to the M5Stack:

- `connectToM5StackUltraBasic`: manually set the serial port and create just the two connection objects.
- `connectToM5StackStandard`: select a numbered port in the Command Window.
- `connectToM5StackPremium`: select a USB serial device in a window or specify the port manually.

Standard and Premium also include an optional NeoPixel test. Both request `Adafruit/NeoPixel` when creating the Arduino object, so you need MATLAB NeoPixel Add-On Library for Arduino to use either script unchanged.
