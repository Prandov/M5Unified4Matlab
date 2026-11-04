%% connectToM5StackBasic.m
% ==================================================================================================
% Create a connection to the M5Stack in your MATLAB workspace
% Copyright 2024, Eric Prandovszky
% Contact: prandov@yorku.ca
% Version 2
% Oct 11, 2024
% Updated: November 3, 2026
% Script to help get connected to the M5Stack.
% ==================================================================================================

%% Connect to the M5Stack ESP32 processor using the arduino() command in matlab:
%   arduino(Port, Board, Libraries, Other Flags)
%       Port:  [defined below]
%       Board: ['ESP32-WROOM-DevKitC']
%       Libraries: [,'Libraries',{'I2C','M5Stack/M5Unified'}], other libraries can be added as needed
% additionally: [,'Traceon', true,] prints debug info to the Command Window
% additionally: [,'ForceBuildOn',true] forces a re-compile and re-upload arduinoServer each time (used during library development)
% Example full command: esp32 = arduino(M5SerialPort,'ESP32-WROOM-DevKitC','Libraries',{'I2C','M5Stack/M5Unified','Adafruit/NeoPixel'},'Traceon', true);

%% A. Select the serial port to connect to
% 1. Get the list of available serial ports
    mySerialPorts = serialportlist;
% 2. Check if any ports are available
    if isempty(mySerialPorts)
        error('M5Stack:NoSerialPorts', 'No serial ports detected. Check the device connection.');
    end
% 3. Display the ports to the user with a numbering system
    fprintf("Available Serial Ports:\n");
    for i = 1:length(mySerialPorts)
        fprintf("[%d] %s\n", i, mySerialPorts(i));
    end
% 4. Prompt the user for a numerical input
    choice = input("\nEnter the number of the port you want to select: ");
% 5. Direct Validation: Check if the choice exists in the list of valid indices
    if ~ismember(choice, 1:length(mySerialPorts))
        error("Invalid selection. Please run the script again and enter a valid number.");
    else
        M5SerialPort = mySerialPorts(choice);
        fprintf("You selected: %s\n", M5SerialPort);
    end
    clear mySerialPorts choice
%% B. Initialize the arduino object
    if ~exist('esp32','var')
        esp32 = arduino(M5SerialPort,'ESP32-WROOM-DevKitC','Libraries',{'I2C','M5Stack/M5Unified','Adafruit/NeoPixel'},'Traceon', true,'ForceBuildOn',true);
    end
    clear M5SerialPort
%% C. Initialize the M5Unified Library as an arduinoAddOn
%   The M5Unified Library supports devices on the M5: LCD, IMU, Mic, Spkr, PMU, etc.
    if ~exist('m5u','var')
        m5u = addon(esp32,'M5Stack/M5Unified');
    end
    %m5u.begin %begin must be called to start the library. %!Now called automatically
    m5u.lcdPrintLn('Hi Everybody')

%% D. Initialize Neopixels
%   Neopixels (programmable RGB LED's) on the M5Stack are accessed through the Adafruit NeoPixel library MATLAB Add-On, and are initialized separately.
%   Example: M5Stack Core2 for AWS has 10 neopixels connected to D25.
    if ~exist('neopix','var')
        neopix = addon(esp32, 'Adafruit/NeoPixel', 'D25', 10, 'NeoPixelType', 'GRB');
    end
    % Traffic Light Example:
    % writeColor(neopix, 1, 'green');
    % writeColor(neopix, 3, 'yellow');
    % writeColor(neopix, 5, 'red');


