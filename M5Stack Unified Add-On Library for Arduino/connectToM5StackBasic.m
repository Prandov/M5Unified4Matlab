%% connectToM5StackBasic.m
% ==================================================================================================
% Create a connection to the M5Stack in your MATLAB workspace
% Copyright 2024, Eric Prandovszky
% Contact: prandov@yorku.ca
% Version 1
% Oct 11, 2024
% Script to help get connected to the M5Stack.
% ==================================================================================================

%% Find the Serial Port of the device using serialportlist
    disp(serialportlist) % Paste this into the command window
% hint: run serialportlist before plugging  in the M5 and again after, your device should be the new entry.
% If nothing shows up, check the cable, check if you need a serial port driver. 
%% Enter the position in the list of the port you'd like to connect to
    mySerialPorts = serialportlist;
    M5SerialPort= mySerialPorts(2); % *Before Running, enter the array position of the port you want to connect to!
    clear mySerialPorts

%% Define the M5Stack's ESP32 processor as an 'Arduino': arduino(Port, Board, Libraries, Other Flags)
% Port is [defined above]
% Board is ['ESP32-WROOM-DevKitC']
% Libraries are typically [,'Libraries',{'I2C','M5Stack/M5Unified','Adafruit/NeoPixel'}]
% adding [,'Traceon', true,] prints debug info to the Command Window
% adding [,'ForceBuildOn',true] forces a re-compile and re-upload arduinoServer each time (used during library development)
% Example: esp32 = arduino(M5SerialPort,'ESP32-WROOM-DevKitC','Libraries',{'I2C','M5Stack/M5Unified','Adafruit/NeoPixel'},'Traceon', true);
    if ~exist('esp32','var')
        esp32 = arduino(M5SerialPort,'ESP32-WROOM-DevKitC','Libraries',{'I2C','M5Stack/M5Unified','Adafruit/NeoPixel'},'Traceon', true,'ForceBuildOn',true);
    end
    clear M5SerialPort
%% Initialize the M5Unified Library as an arduinoAddOn
% The M5Unified Library supports devices on the M5: LCD, IMU, Mic, Spkr, PMU, etc.
    if ~exist('m5u','var')
        m5u = addon(esp32,'M5Stack/M5Unified');
    end
    %m5u.begin %begin must be called to start the library. %!Now called automatically
    m5u.lcdPrintLn('Hi Everybody')

%% Neopixels
% Neopixels (programmable RGB LED's) on the M5Stack are accessed through the Adafruit NeoPixel library MATLAB Add-On, and are initialized separately.
    if ~exist('neopix','var')
        neopix = addon(esp32, 'Adafruit/NeoPixel', 'D25', 10, 'NeoPixelType', 'GRB'); %M5Stack Core2 for AWS has 10 neopixels connected to D25.
    end
    % Traffic Light Example:
    % writeColor(neopix, 1, 'green');
    % writeColor(neopix, 3, 'yellow');
    % writeColor(neopix, 5, 'red');

    