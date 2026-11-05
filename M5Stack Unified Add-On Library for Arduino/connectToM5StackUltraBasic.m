%% connectToM5StackUltraBasic.m
% ==================================================================================================
% Connect an M5Stack to MATLAB using a manually entered serial port.
% Contact: prandov@yorku.ca
% Version 1 | November 5, 2026

% Edit the port below (e.g. 'COM4' or '/dev/cu.SLAB_USBtoUART') and run in a fresh workspace.
m5SerialPort = 'enter your serial port here';
esp32 = arduino(m5SerialPort, 'ESP32-WROOM-DevKitC', 'Libraries', {'M5Stack/M5Unified'});
m5u = addon(esp32, 'M5Stack/M5Unified');
