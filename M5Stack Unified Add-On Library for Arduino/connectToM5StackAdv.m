%% connectToM5StackAdv.m
% ==================================================================================================
% Create a connection to the M5Stack in your MATLAB workspace
% Copyright 2024, Eric Prandovszky
% Contact: prandov@yorku.ca
% Version 1
% Oct 11, 2024
% Script to help get connected to the M5Stack.
% ==================================================================================================

%% Find the Serial Port of the device using serialportlist
serialportlist

%% Manually enter the serial port name you want from the returned list (or leave blank to use a selection window)
myM5SerialPort = ''; 

if ~exist('M5serialport','var');M5SerialPort ='';end % Check for a previously selected port.
if ~isempty(myM5SerialPort);M5SerialPort = myM5SerialPort;end; clear myM5SerialPort; % Check for a manually defined port.
if isempty(M5SerialPort);serialPortSelectionWindow;end % Call the port selection window.

%% Define the M5Stack's ESP32 processor as an Arduino: arduino(Port, Board, Libraries, Other Flags)
% Port is [defined above]
% Board is ['ESP32-WROOM-DevKitC']
% Libraries are typically [,'Libraries',{'I2C','M5Stack/M5Unified','Adafruit/NeoPixel'}]
% adding [,'Traceon', true,] prints debug info to the Command Window
% adding [,'ForceBuildOn',true] forces a re-compile and re-upload arduinoServer each time (used during library development)
    if ~exist('esp32','var')
        esp32 = arduino(M5SerialPort,'ESP32-WROOM-DevKitC','Libraries',{'I2C','M5Stack/M5Unified','Adafruit/NeoPixel'},'Traceon', true);
    end
%% Initialize the M5Unified Library as an arduinoAddOn
% The M5Unified Library supports devices on the M5: LCD, IMU, Mic, Spkr, PMU, etc.
    if ~exist('m5u','var')
        m5u = addon(esp32,'M5Stack/M5Unified');
    end
    %m5u.begin %begin must be called to start the library. !Now called automatically
    m5u.lcdPrintLn('Hello')

%% Neopixels
% Neopixels (programmable RGB LED's) on the M5Stack are accessed through the Adafruit NeoPixel library MATLAB Add-On, and are initialized separately.
    if ~exist('neopix','var') 
        neopix = addon(esp32, 'Adafruit/NeoPixel', 'D25', 10, 'NeoPixelType', 'GRB'); %M5Stack Core2 for AWS has 10 neopixels connected to D25.
    end
 % Traffic Light Example:
 % writeColor(neopixels, 1, 'green');
 % writeColor(neopixels, 3, 'yellow');
 % writeColor(neopixels, 5, 'red');

 %% Functions
% Function to create a serial port selection window.
   function serialPortSelectionWindow
        %arduinoio.arduinoio.setup.internal.HardwareInterface.getAvailableArduinoPorts(~, oldPort)
        usbdev = matlab.hwmgr.internal.hwconnection.USBDeviceEnumerator;
        ports = getSerialPorts(usbdev);
        % Remove the repeated port addresses from the ports list. See g2539001.
        ports = unique(ports, 'stable');
        if isempty(ports)
            error('No USB serial devices detected. Please check your connection.');
        else
            ports = ['select a value',ports];
            % Create a figure for the dropdown
            hFig = figure('Position', [100, 100, 300, 150], 'MenuBar', 'none', 'Name', 'Select Serial Port', 'NumberTitle', 'off');
            hDropdown = uicontrol('Style', 'popupmenu','String', ports, 'Position', [50, 70, 200, 30]);
            hButton = uicontrol('Style', 'pushbutton', 'String', 'Select','Position', [100, 30, 100, 30], 'Callback', @(src, event) selectPort(hDropdown, hFig));
            uiwait(hFig); 
            %clear usbDev hFig hDropdown hButton selectedPort;
        end
    end
    % Function to handle the serial port selection.
    function selectPort(dropdown, fig)
        selectedIndex = dropdown.Value;
        selectedPort = dropdown.String{selectedIndex};
        disp(['Selected Serial Port: ', selectedPort]);
        assignin('base', 'M5serialport', selectedPort); % Assign to base workspace.
        close(fig); % Close the figure.
    end
