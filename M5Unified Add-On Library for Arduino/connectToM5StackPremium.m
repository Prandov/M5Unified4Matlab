%% connectToM5StackPremium.m
% ==================================================================================================
% Create a connection to the M5Stack in your MATLAB workspace
% Copyright 2024, Eric Prandovszky
% Contact: prandov@yorku.ca
% Version 1
% Oct 11, 2024
% Updated: November 5, 2026
% Script to help get connected to the M5Stack.
% ==================================================================================================

%% Find the Serial Port of the device using serialportlist
serialportlist

%% Manually enter the serial port name you want from the returned list (or leave blank to use a selection window)
myM5SerialPort = ''; 

if ~exist('M5SerialPort','var');M5SerialPort ='';end % Check for a previously selected port.
if ~isempty(myM5SerialPort);M5SerialPort = myM5SerialPort;end; clear myM5SerialPort; % Check for a manually defined port.
if isempty(M5SerialPort);serialPortSelectionWindow;end % Call the port selection window.
if isempty(M5SerialPort) % GPT6A
    error('M5Stack:PortSelectionCancelled', 'Serial port selection cancelled.');
end

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

%% Neopixel Connection
testNeoPixels = false;
npPin = 'D25'; % NeoPixel data pin on Core2 for AWS.
npCount = 10; % Number of NeoPixels on Core2 for AWS.
if testNeoPixels
    if ~exist('neopix','var') 
        neopix = addon(esp32, 'Adafruit/NeoPixel', npPin, npCount, 'NeoPixelType', 'GRB');
    end
 %Traffic light test.
 writeColor(neopix, 1, 'green');
 writeColor(neopix, 3, 'yellow');
 writeColor(neopix, 5, 'red');
end

 %% Functions
% Function to create a serial port selection window.
   function serialPortSelectionWindow
        usbdev = matlab.hwmgr.internal.hwconnection.USBDeviceEnumerator;
        ports = getSerialPorts(usbdev);
        % Remove the repeated port addresses from the ports list. See g2539001.
        ports = unique(ports, 'stable');
        if isempty(ports)
            error('No USB serial devices detected. Please check your connection.');
        else
            ports = [{'select a value'}; ports(:)]; % GPT6A
            % Create a figure for the dropdown
            hFig = figure('Units', 'pixels', 'Position', [100, 100, 300, 150], ...
                'Visible', 'off', 'WindowStyle', 'normal', 'MenuBar', 'none', ...
                'Name', 'Select Serial Port', 'NumberTitle', 'off');
            hDropdown = uicontrol('Style', 'popupmenu','String', ports, 'Position', [50, 70, 200, 30]);
            uicontrol('Style', 'pushbutton', 'String', 'Select','Position', [100, 30, 100, 30], 'Callback', @(src, event) selectPort(hDropdown, hFig)); % GPT6A
            % GPT6A: Center before showing to avoid a lower-left flash.
            movegui(hFig, 'center');
            set(hFig, 'Visible', 'on');
            uiwait(hFig); 
        end
    end
    % Function to handle the serial port selection.
    function selectPort(dropdown, fig)
        selectedIndex = dropdown.Value;
        if selectedIndex == 1 % GPT6A
            warning('M5Stack:InvalidSerialPort', 'Select a serial port rather than the placeholder.');
            return
        end
        selectedPort = dropdown.String{selectedIndex};
        disp(['Selected Serial Port: ', selectedPort]);
        assignin('base', 'M5SerialPort', selectedPort); % Assign to base workspace.
        close(fig); % Close the figure and resume the script.
    end
