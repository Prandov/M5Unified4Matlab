%% M5Unified Add-On Library for Arduino
% Created with GPT6A for the MATLAB Project and toolbox release workflow.
% Control built-in peripherals of an M5Stack device from MATLAB.
% This file contains instructions only; running it does not modify MATLAB
% or connect to hardware.
%
% 1. Install MATLAB Support Package for Arduino Hardware using Add-On Explorer.
% 2. Install this M5Unified toolbox. Its library, Utilities and Examples
%    folders are added to the MATLAB path by the toolbox installer.
% 3. Run prepareForM5Stack manually. It patches the Arduino support package's
%    Utility.m (with a backup) and downloads the Arduino libraries M5Unified,
%    M5GFX, and Adafruit NeoPixel. See README.md for preparation details.
% 4. Inspect connectToM5StackUltraBasic, enter your serial port, then run it.
%    The Standard and Premium scripts additionally require the MATLAB
%    NeoPixel Add-On Library for Arduino with their current Libraries list.
%
% Example commands (enter them yourself after completing preparation):
%   serialportlist
%   esp32 = arduino('COM6', 'ESP32-WROOM-DevKitC', ...
%       'Libraries', {'M5Stack/M5Unified'});
%   m5u = addon(esp32, 'M5Stack/M5Unified');
%   m5u.lcdPrintLn('Hello from MATLAB');
%
% Originally developed with R2024a; primarily tested on Core2 for AWS.
% Other selectable board profiles do not imply verified hardware support.
%
% Open the published wrapper reference (comments and source, without execution):
%   classFolder = fileparts(which('arduinoioaddons.M5Stack.M5Unified'));
%   web(fullfile(classFolder, 'html', 'M5Unified.html'), '-browser');
% Repository: https://github.com/Prandov/M5Unified4Matlab
