# M5Stack support for MATLAB

This *Custom Arduino Add-On Library* for the **MATLAB Support Package for Arduino hardware** brings support for **M5Stack** esp32 based devices to MATLAB. 
This Add-On Library allows MATLAB to communicate with the integrated peripherals on the M5Stack(IMU,LCD,MIC,PMU,SPKR,etc.) using the M5Unified & M5GFX Arduino Libraries.

<img src="https://github.com/user-attachments/assets/0213adc5-5ff2-47d4-9160-c0baa1d4e117" height="100" alt="M5StackCore1">
<img src="https://github.com/user-attachments/assets/b78d10e2-06be-4d6a-a0c0-23581f3cf67a" height="100" alt="M5StackCore2"> 
<img src="https://github.com/user-attachments/assets/d51304a9-edea-418e-b7f2-7caba869876d" height="100" alt="M5StackCore2AWS"> 
<img src="https://github.com/user-attachments/assets/618dc43e-1edb-4f4d-ac0c-23d9d03798ef" height="100" alt="M5StickCPlus"> 

## Required Items:

1. MATLAB.  
2. esp32 based M5Stack (Core, Core2, Stick, Stick2,Atom).  
3. MATLAB Support Package for Arduino hardware.  
4. M5Unified & M5GFX Arduino Libraries installed in the arduino libraries folder [install script included].  
5. M5Unified Add-On Library for Arduino (this).

## Connecting to the M5Stack

Once the environment is set up, you must create two objects in our workspace.

1. An 'arduino' object that represents the esp32 microcontroller .  
2. An 'addon' object that represents the M5Unified Libraries & the devices M5Unified controls.

### First: Initialize communication with the esp32 inside the M5Stack.

*Example:*

```esp32 \= arduino('COM6','ESP32-WROOM-DevKitC','Libraries',{'I2C','M5Stack/M5Unified'});```

### Second: Initialize the M5Unified Arduino Add-On Library.

*Example:*

```M5Unified \= addon(esp32,'M5Stack/M5Unified');```

## Controlling the M5Stack

Use the 'arduino' object namespace to communicate with the esp32.

*Example:*

```esp32.writeDigitalPin('D32',0);```

```esp32.readVoltage('D33');```

Use the 'addon' object namespace to communicate with the M5Stack components.

*Example:*

```M5Unified.lcdPrint('Hello');```

## Notes

* This Library is in development and more features will be added over time.  
* Created using MATLAB 2024a, it likely works with any version of the arduino support packages that supports esp32.  
* Developed using the M5 Core2 for AWS, and some testing with the M5 StickC has been done.
