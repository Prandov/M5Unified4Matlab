%% Custom Arduino Add-On Library for the M5Unified Library by M5Stack
% ==================================================================================================
% M5Unified class
% Copyright 2024, Eric Prandovszky, Greatlove Bariboloka 
% Contact: prandov@yorku.ca, greatlebari@gmail.com
% Version: 0.4.9
% Date: Nov 4, 2024
% This .m file interacts with the M5UnifiedML.h C header file uploaded to an M5Stack device.
% ==================================================================================================

%% This Class creates an M5Unified add-on device object. 
% This allows you to communicate with the integrated peripherals on M5Stack Devices(IMU,LCD,MIC,PMU,SPKR,etc.)

% First initialize communication with the ESP32 inside the M5Stack. 
%   Example:
%       esp = arduino('COM6','ESP32-WROOM-DevKitC','Libraries',{'I2C', 'M5Stack/M5Unified'},'Traceon', true);

% Then initialize this unified library. 
%   Example:
%       m5u= addon(esp,'M5Stack/M5Unified');

% Use the 'arduino' object namespace to communicate with the ESP32.
%   Example:
%       writeDigitalPin(esp,'D32',0); OR  esp.writeDigitalPin('D32',0);
%       readVoltage(esp,'D33');       OR  esp.readVoltage('D33');

% Use the 'addon' object namespace to communicate with the integrated peripherals.
%   Example:
%       powerLED(m5u,255)  OR  m5u.powerLED(255);

%% References:
% CLASS DESCRIPTION: https://www.mathworks.com/help/matlab/arduinoio-custom-arduino-libraries.html
%   CREATION STEPS: https://www.mathworks.com/help/matlab/supportpkg/create-custom-arduino-add-on-library.html
%   EXAMPLE: https://www.mathworks.com/help/matlab/supportpkg/create-code-to-write-a-string.html

%% This File is Step 3 in the custom addon guide: Create a MATLAB Wrapper
% The MATLAB add-on wrapper class that defines your library must inherit from matlabshared.addon.LibraryBase. 
% The "matlabshared.addon.LibraryBase" class defines several constant properties that you must override in your MATLAB class. 
% The class also contains internal utility functions that enable you to send and retrieve data from the server running on the Arduino board.
% You can access the library files from 'CreateFolderStructureExample/SDKExampleHelloWorld' folder downloaded in Create Folder Structure.
% Create a MATLAB class, and define the command ID for each command that is sent to the server on the board.

classdef M5Unified <  matlabshared.addon.LibraryBase & matlab.mixin.CustomDisplay
    % M5Unified Summary of M5Unified

    properties(Access = private, Constant = true)
    % Command ID's
    % Main Commands 0x00 to 0x1f
        M5Begin                 = 0x01    %1
        M5BoardType             = 0x02    %2
        M5GetMemoryStatus       = 0x03    %3
        M5Delay                 = 0x04    %4
    % LCD Display Commands 0x20 to 0x4F   
    % LCD Control [14]
        M5LcdBegin              = 0x20    %1
        M5LcdStartWrite         = 0x21    %2
        M5LcdEndWrite           = 0x22    %3
        M5LcdClear              = 0x23    %4
        M5LcdDisplay            = 0x24    %5
        M5LcdgetHeight          = 0x25    %6
        M5LcdgetWidth           = 0x26    %7
        M5LcdgetDispCount       = 0x27    %8
        M5LcdgetRotation        = 0x28    %9
        M5LcdsetRotation        = 0x29    %10
        M5LcdsetBrightness      = 0x2A    %11
        M5LcdsetColorDepth      = 0x2B    %12
        M5LcdAllocateMem        = 0x2C    %13
        M5LcdFreeMem            = 0x2D    %14
    % LCD Text      [8]
        M5LcdPrint              = 0x2E    %1
        M5LcdPrintLn            = 0x2F    %2
        M5LcdDrawString         = 0x30    %3
        M5LcdTextColor          = 0x31    %4
        M5LcdTextDatum          = 0x32    %5
        M5LcdTextSize           = 0x33    %6
        M5LcdTextFont           = 0x34    %7
        M5LcdSetCursor          = 0x35    %8
    % LCD Shapes    [25+]
        M5LcdDrawPixel          = 0x36    %1
        M5LcdDrawLine           = 0x37    %2
        M5LcdDrawFastVLine      = 0x38    %3
        M5LcdDrawFastHLine      = 0x39    %4
        M5LcdDrawRectFOR        = 0x3A    
        %M5LcdFillRect           = 0X3A    %5
        %M5LcdDrawRect           = 0X3A    %6
        %M5LcdDrawRoundRect      = 0X3B    %7
        %M5LcdFillRoundRect      = 0X3B    %8
        M5LcdDrawCircleFO       = 0x3C
        % M5LcdDrawCircle                 %9
        % M5LcdFillCircle                 %10
        M5LcdDrawEllipseFO      = 0x3D  
        % M5LcdDrawEllipse                %11
        % M5LcdFillEllipse                %12
        M5LcdDrawTriangleFO     = 0x3E
        % M5LcdDrawTriangle               %13
        % M5LcdFillTriangle               %14
        M5LcdDrawBezier         = 0x3F    %15
        M5LcdDrawEllipseArcFO   = 0x40
        % M5LcdDrawEllipseArc             %16
        % M5LcdFillEllipseArc             %17
        M5LcdDrawArcFO          = 0x41    
        % M5LcdfillArc                    %18
        % M5LcdDrawArc                    %19
        M5LcdDrawCircleHelper   = 0x42    %20
        M5LcdFillCircleHelper   = 0x43    %21
        M5LcdFloodFill          = 0x44    %22
        M5LcdPaint              = 0x45    %23
        M5LcdFillAffine         = 0x46    %24
        M5LcdDrawGradientLine   = 0x47    %25
    % LCD Images
        M5LcdDrawDrawBMP        = 0x48
        M5LcdDrawDrawJPG        = 0x49
        M5LcdDrawDrawPNG        = 0x50
    % IMU       0x50    %TODO
    % Log       0x60    %TODO
    % Power     0x70    [20]
        M5PwrBegin              = 0x70   %1
        M5PwrSetExtPwr          = 0x71    %2
        M5PwrGetExtOut          = 0x72    %3
        % M5PwrSetUSBOut                  %CoreS3Only
        % M5PwrGetUSBOut                  %CoreS3Only         
        M5PwrSetLED             = 0x73    %6
        M5PwrOff                = 0x74    %7
        % M5PwrTimerSleep             
        % M5PwrDeepSleep              
        % M5PwrLightSleep             
        M5PwrGetBatteryLvl      = 0x76    %11
        M5PwrSetBatteryChg      = 0x77    %12
        M5PwrSetChargeCurr      = 0x78    %13
        M5PwrSetChargeVolt      = 0x79    %14
        M5PwrIsCharging         = 0x7A    %15
        M5PwrGetBatteryVolt     = 0x7B    %16
        M5PwrGetBatteryCurr     = 0x7C    %17
        M5PwrGetKeyState        = 0x7D    %18
        M5PwrSetVibration       = 0x7E    %19
        M5PwrGetType            = 0x7F    %20
    % RTC       0x80    %TODO
    % Touch     0x90    %TODO
    % Button    0xA0
        M5ButtonUpdate          = 0xA0
    % Speaker   0xB0    [6]
        M5SpeakerBegin          = 0xB0    %1 
        M5SpeakerStop           = 0xB1    %2
        M5SpeakerTone           = 0xB2    %3
        M5SpeakerSetVolume      = 0xB3    %4
        M5SpeakerGetVolume      = 0xB5    %5
        M5SpeakerPlayRaw        = 0xB7    %6
    % Mic       0xC0    %TODO
        M5MicBegin              = 0xC0
    % pSRAM     0xD0    %TODO
        % The Current ESP32 supported in MATLAB does not include PSRAM (DevKit-C)
    % SD        0xE0    %TODO
    end
    properties(Access = public, Constant = true)
        % lcdColor declares readyto-use color values for the LCD
        % run m5u.lcdColor for the full list of color strings available eg.'BlACK'
        % where m5u is the M5Unified addon object
        lcdColor = struct(...
            'BLACK'      ,   0x0000, ...      % RGB888   0,   0,   0 
            'NAVY'       ,   0x000F, ...      % RGB888   0,   0, 128 
            'DARKGREEN'  ,   0x03E0, ...      % RGB888   0, 128,   0 
            'DARKCYAN'   ,   0x03EF, ...      % RGB888   0, 128, 128 
            'MAROON'     ,   0x7800, ...      % RGB888 128,   0,   0 
            'PURPLE'     ,   0x780F, ...      % RGB888 128,   0, 128 
            'OLIVE'      ,   0x7BE0, ...      % RGB888 128, 128,   0 
            'LIGHTGREY'  ,   0xD69A, ...      % RGB888 211, 211, 211 
            'LIGHTGRAY'  ,   0xD69A, ...      % RGB888 211, 211, 211 
            'DARKGREY'   ,   0x7BEF, ...      % RGB888 128, 128, 128 
            'DARKGRAY'   ,   0x7BEF, ...      % RGB888 128, 128, 128 
            'BLUE'       ,   0x001F, ...      % RGB888   0,   0, 255 
            'GREEN'      ,   0x07E0, ...      % RGB888   0, 255,   0 
            'CYAN'       ,   0x07FF, ...      % RGB888   0, 255, 255 
            'RED'        ,   0xF800, ...      % RGB888 255,   0,   0 
            'MAGENTA'    ,   0xF81F, ...      % RGB888 255,   0, 255 
            'YELLOW'     ,   0xFFE0, ...      % RGB888 255, 255,   0 
            'WHITE'      ,   0xFFFF, ...      % RGB888 255, 255, 255 
            'ORANGE'     ,   0xFDA0, ...      % RGB888 255, 180,   0 
            'GREENYELLOW',   0xB7E0, ...      % RGB888 180, 255,   0 
            'PINK'       ,   0xFE19, ...      % RGB888 255, 192, 203  %Lighter pink, was 0xFC9F
            'BROWN'      ,   0x9A60, ...      % RGB888 150,  75,   0 
            'GOLD'       ,   0xFEA0, ...      % RGB888 255, 215,   0 
            'SILVER'     ,   0xC618, ...      % RGB888 192, 192, 192 
            'SKYBLUE'    ,   0x867D, ...      % RGB888 135, 206, 235 
            'VIOLET'     ,   0x915C, ...      % RGB888 180,  46, 226 
            'TRANSPARENT',   0x0120 ...
        ); 
    end

    properties(SetAccess = private,GetAccess=public)
        m5Type;
        lcdResolution;
        batteryLevel;
    end
    %Override constant properties in the class to specify the location of source header files.   
    %The support package auto-detects the class only if you have redefined all the properties. If you do not need a value, leave the field empty.
    properties(Access = protected, Constant = true)
        LibraryName = 'M5Stack/M5Unified'
        DependentLibraries = {} % Other add-on libraries required by your add-on as a cell array of strings: {'i2c'};
        LibraryHeaderFiles = {'M5Unified/src/M5Unified.h'}  % C++ header files needed by your add-on
        CppHeaderFile = fullfile(arduinoio.FilePath(mfilename('fullpath')), 'src', 'M5UnifiedML.h') % Full path and name of your add-on C++ header file as a string.
        CppClassName = 'M5UnifiedML' % Name of the class in your C++ header file as a string.
    end
    
    properties(Access = private)
        ResourceOwner = 'M5Stack/M5Unified';
    end
    
    % Define the class constructor, set the methods to call the class constructor, and set the parent property.
    % Constructor Method
    methods(Hidden, Access = public)
        function obj = M5Unified(parentObj)
                obj.Parent = parentObj;
            try
                %Check if M5Unified object has already been initialized
                count = getResourceCount(obj.Parent, 'M5Unified');
                if count >0
                    error('M5Unified library has already been initialized for this arduino object ');
                end
                %obj.begin; %moved to void setup in the header
                %pause(0.001);
                obj.lcdPrintLn('M5Stack is now connected to MATLAB');
                obj.m5Type = obj.getM5Type;
                obj.lcdResolution = [obj.lcdGetHeight,obj.lcdGetWidth];
                obj.batteryLevel = obj.powerGetBatteryLevel;
            catch e
                throwAsCaller(e);
            end
        end
    end
    %% Destructor Method 
    % *Not sure if this is needed since everything we interact with using the 
    %  M5Unified library is integral to the M5Stack.
    % methods(Access = protected)
    %     function delete(obj)
    %         try
    %             parentObj = obj.Parent;
    %             decrementResourceCount(obj.Parent, 'M5Unified');
    %             deleteM5(obj)
    %         catch
    %             % Do not throw any errors
    %         end
    %     end
    % end
    
    methods(Access = public)
    %% M5Unified basic functions
        % M5.begin     % Perform initialization process at startup.
        % M5.update 
        % M5.getBoard
        % M5.getUpdateMsec
        % M5.config
        % M5.getPin
% begin-------------------------------------------------------------------------------------
        % M5.begin Instantiates the following when you call it
        function begin(obj)
        % M5.begin Instantiates the following when you call it
            %    M5GFX Display;  % setPrimary
            %    M5GFX &Lcd = Display; %Creates a pointer for LCD to Display
            %    IMU_Class Imu;
            %    Log_Class Log;
            %    Power_Class Power;
            %    RTC8563_Class Rtc;
            %    Touch_Class Touch;
            %    Button_Class BtnA;
            %    Button_Class BtnB;
            %    Button_Class BtnC;
            %    Button_Class BtnEXT;  % CoreInk top button
            %    Button_Class BtnPWR;  % CoreInk power button / AXP192 power button
            %    I2C_Class& In_I2C = m5::In_I2C; %for internal I2C device
            %    I2C_Class& Ex_I2C = m5::Ex_I2C; %for external I2C device (Port.A)
            %    Speaker_Class Speaker;
            %    Mic_Class Mic;

            cmdID = obj.M5Begin;
            dataIn = 0x00;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% getBoardType-------------------------------------------------------------------------------------
        %M5.getBoard()
        function boardName = getM5Type(obj)
            % boardName = getM5Type(m5u) gets the board type of the runtime environment
            %
            % Syntax
            %     boardName = getM5Type(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %
            % Output Arguments
            %     boardName - the board type of the runtime environment
            %       character vector
            cmdID = obj.M5BoardType;             
            dataIn = 0x00;
            [dataOut, ~] = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            BoardType = cast(dataOut,'uint8');
            switch BoardType
                case 0
                    boardName = 'Unknown';
                case 1
                    boardName = 'M5 Stack';
                case 2
                    boardName = 'M5 Stack Core 2';
                case 3
                    boardName = 'M5 Stick-C';
                case 4
                    boardName = 'M5 Stick-C Plus';
                case 5
                    boardName = 'M5 Stick-C Plus 2';
                case 10
                    boardName = 'M5 Stack Core S3';
                case 17
                    boardName = 'M5 Stack Core S3 SE';
                otherwise
                    boardName = 'Other Unidentified board type';
            end
            fprintf('The board type is %s.\n', boardName)
        end  
% memoryStatus-------------------------------------------------------------------------------------
        function [heapSize, heapFree, psramSize, psramFree] = memoryStatus(obj)
            % [heapSize, heapFree, psramSize, psramFree] = memoryStatus(m5u)
            %    returns the size of the heap memory, amount of free heap,
            %    size of PSRAM, and amount of free PSRAM respectively
            %    Index the result to access each value.
            %
            % Syntax
            %     [heapSize, heapFree, psramSize, psramFree] = memoryStatus(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %
            % Output Arguments
            %     [heapSize, heapFree, psramSize, psramFree] - an array of the Heap Size, 
            %        Free Heap memory, PSRAM Size, and Free PSRAM
            %       array of uint32 values
            cmdID = obj.M5GetMemoryStatus;
            val = sendCommand(obj, obj.LibraryName, cmdID, 0x00);
            val = uint8(val);
            heapSize = typecast(val(1:4),'uint32');
            heapFree = typecast(val(5:8),'uint32');
            psramSize = typecast(val(9:12),'uint32');
            psramFree = typecast(val(13:16),'uint32');
            %heapUsed = heapSize-heapFree;
            %psramUsed = psramSize-psramFree;
            %sprintf('Heap Size: %d \n Heap Used: %d \n Free Heap: %d', heapSize, heapUsed, heapFree)
            %sprintf('PSRAM Size: %d \n PSRAM Used: %d \n Free PSRAM: %d', psramSize, psramUsed, psramFree)
        end
 % delay------------------------------------------------------------------------------------- 
        %M5.delay(dur);
        function delay(obj, dur)
        % delay(m5u, dur) delays the M5 for a specified duration dur between 0 and
        %    255 ms, where dur can also be a fraction.
            % 
            % Syntax
            %     delay(m5u, dur)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     dur - duration of delay between 0 and 255
            %       uint8
            durBytes = uint8(dur);
            cmdID = obj.M5Delay;
            dataIn = durBytes;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
%% M5 LCD Display [14]
% M5.LCD is a reference to M5.Display which is an M5GFX object inhereted from LGFX
% lcdBegin-------------------------------------------------------------------------------------
         % 1. M5.Display.begin();
         function lcdBegin(obj) %Not really needed since M5.begin calls this
         % lcdBegin(m5u) initializes the M5 lcd.
         % Implicitly called by M5.begin
            % 
            % Syntax
            %     lcdBegin(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            cmdID = obj.M5LcdBegin; 
            dataIn = 0x00; 
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
         end
%------------------------------------------------------------------------------------- 
        % 2. M5.Display.startWrite(); % using startWrite and endWrite before and after the drawing process suppresses bus allocation
        % 3. M5.Display.endWrite(); 
% lcdClear-------------------------------------------------------------------------------------
        % 4. M5.Display.clear();
        function lcdClear(obj)
        % lcdClear(m5u) clears the M5 lcd
            % 
            % Syntax
            %     lcdClear(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            cmdID = obj.M5LcdClear; 
            dataIn = 0x00; 
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
%-------------------------------------------------------------------------------------
        % 5. M5.Display.display();
        function lcdDisplay(obj)
            cmdID = obj.M5LcdDisplay;
            % [dataOut, payloadSize] = sendCommand(obj, libName, commandID, dataIn, timeout)
            dataIn = 0x00;
            sendCommand(obj,obj.LibraryName,cmdID,dataIn);
        end   
%-------------------------------------------------------------------------------------
        % 6. M5.Display.height()
        function height = lcdGetHeight(obj)
        % height = lcdGetHeight(m5u) returns the height of the lcd
        % 
            % Syntax
            %     height = lcdGetHeight(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            % Output Arguments
            %     height - lcd height
            %       uint16
            cmdID = obj.M5LcdgetHeight;
            % [dataOut, payloadSize] = sendCommand(obj, libName, commandID, dataIn, timeout)
            dataIn = 0x00;
            dataOut = sendCommand(obj,obj.LibraryName,cmdID,dataIn);
            height = typecast(cast(dataOut,'uint8'),'uint16');
        end   
%-------------------------------------------------------------------------------------
        % 7. M5.Display.width()
        function width = lcdGetWidth(obj) 
        % width = lcdGetWidth(m5u) returns the width of the lcd
            % 
            % Syntax
            %     width = lcdGetWidth(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            % Output Arguments
            %     width - lcd width
            %       uint16
            cmdID = obj.M5LcdgetWidth;
            % [dataOut, payloadSize] = sendCommand(obj, libName, commandID, dataIn, timeout)
            dataIn = 0x00;
            dataOut = sendCommand(obj,obj.LibraryName,cmdID,dataIn);
            width = typecast(cast(dataOut,'uint8'),'uint16');
        end   
% getDisplayCount-------------------------------------------------------------------------------------
        % 8. M5.getDisplayCount()
        function count = lcdGetDisplays(obj)
        % count = lcdGetDisplays(m5u) returns the number of displays connected to the M5
        % 
            % Syntax
            %     count = lcdGetDisplays(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            % Output Arguments
            %     count - number of displays connected to the M5
            %       uint8
            cmdID = obj.M5LcdgetDispCount;
            % [dataOut, payloadSize] = sendCommand(obj, libName, commandID, dataIn, timeout)
            dataIn = 0x00;
            count = sendCommand(obj,obj.LibraryName,cmdID,dataIn);
            % = typecast(cast(dataOut,'uint8'),'uint32');
        end   
%-------------------------------------------------------------------------------------
        % 9. M5.Display.getRotation()
%-------------------------------------------------------------------------------------
        % 10.M5.Display.setRotation  
%-------------------------------------------------------------------------------------
        % 11. M5.Display.setBrightness(brightness)
        function lcdBrightness(obj,brightness)
        % lcdBrightness(m5u, brightness) adjusts the display backlight to the
        % specified brightness between 0(Off) and 255 (Full)
        % 
            % Syntax
            %     lcdBrightness(m5u, brightness)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     brightness - value to set the display backlight to. 0-255.
            %       uint8
            cmdID = obj.M5LcdsetBrightness; 
            dataIn = uint8(brightness); 
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
         end
%-------------------------------------------------------------------------------------        
        % 12. M5.Display.setColorDepth(24);         
        % 12. M5.Display.setColorDepth(16); 
%-------------------------------------------------------------------------------------        
 
%-------------------------------------------------------------------------------------
%% LCD Text [8]
% lcdPrint-------------------------------------------------------------------------------------
        % 1. M5.Display.print(text);
        function lcdPrint(obj, string)
        % lcdPrint(m5u, string) displays the specified string on the display a
        %     the current cursor location
        % 
            % Syntax
            %     lcdPrint(m5u, string)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     string - text to print to the display
            %       string
            cmdID = obj.M5LcdPrint;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(char(string))); 
        end
% lcdPrintLn-------------------------------------------------------------------------------------
        % 2. M5.Display.println(text);
        function lcdPrintLn(obj,string)
        % lcdPrintLn(m5u,string) displays the specified string on the display
        %     on a new line
        % 
            % Syntax
            %     lcdPrintLn(m5u, string)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     string - text to print to the display
            %       string
            cmdID = obj.M5LcdPrintLn; 
            sendCommand(obj,obj.LibraryName,cmdID,uint8(char(string))); 
        end
% lcdDrawStr-------------------------------------------------------------------------------------
        % 3. M5.Display.drawString(text, x, y);
        function lcdDrawStr(obj,x,y,string) %Font and Colour Not Working
        % lcdDrawStr(m5u,x,y,string) draws a character at position (x,y)
        % 
            % Syntax
            %     lcdDrawStr(m5u,x,y,string)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     x - horizontal cursor location
            %       uint16
            %     y - vertical cursor location
            %       uint16
            %     string - text to print to the display
            %       string
            cmdID = 0x2F; 
            xybytes = typecast(swapbytes([uint16(x), uint16(y)]),'uint8');
            text = uint8(char(string));
            xytextData = [xybytes,text];
            cmdID = obj.M5LcdDrawString;
            sendCommand(obj,obj.LibraryName,cmdID,xytextData);
        end
% lcdTextColor-------------------------------------------------------------------------------------
        % 4. M5.Display.setTextColor(textColor)
        % 4. M5.Display.setTextColor(textColor, bgColor);
        function lcdTextColor(obj,textColor,bgColor)
        % lcdTextColor(m5u,color) sets the text color and background color 
        %    if only one argument is supplied, only text color will be set
        %    if two arguments are passed, both text and bg colors will be set
        % 
            % Syntax
            %     lcdTextColor(m5u,color)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     color - color to set
            %       uint16 | string
            % 
            % Examples
            %     lcdTextColor(m5u, 0x9A60); %brown
            %     lcdTextColor(m5u, m5u.lcdColor.BROWN); %brown
            % 
            % Run m5u.lcdColor for preset colors
            
            fgColor = uint16(textColor);
            if nargin == 2 %Only Text Color
                fbColor = typecast(swapbytes(fgColor),'uint8');
            elseif nargin == 3 % Text and Background Color
                fbColor = typecast(swapbytes([fgColor,uint16(bgColor)]),'uint8');
            else
                % Code to execute when there are more than two input arguments
                disp('Invalid number of arguments');
            end
            cmdID = obj.M5LcdTextColor;
            sendCommand(obj,obj.LibraryName,cmdID,fbColor); 
        end
% lcdTextDatum-------------------------------------------------------------------------------------
        % 5. M5.Display.setTextDatum(textdatum_t::bottom_center);
        function lcdTextDatum(obj, datum)
        % lcdTextDatum(m5u, datum) sets the text position reference datum
            % 
            % Syntax
            %     lcdTextDatum(m5u, datum)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     datum - value of reference datum. Possible Values:
            %        0:Top left (default)  1:Top Centre        2:Top Right
            %        4:Middle Left         5:Middle Centre     6:Middle Right         
            %        8:Bottom Left         9:Bottom Centre     10:Bottom Right
            %        16:Baseline Left      17:Baseline Centre  18:Baseline Right
            %       uint8
            cmdID = obj.M5LcdTextDatum;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(datum)); 
        end
% lcdTextSize-------------------------------------------------------------------------------------
        % 6. M5.Display.setTextSize(size); %setTextSize is a float
        function lcdTextSize(obj, size)
        % lcdTextSize(m5u,size) sets the text size, where size can be a fraction
        % 
            % Syntax
            %     lcdTextSize(m5u, size)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     size - text size to set
            %       uint8
            cmdID = obj.M5LcdTextSize;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(size)); 
        end
% lcdFont-------------------------------------------------------------------------------------
        % Working but needs improvement, the function is marked as depreciated in the M5Unified Library
        % 7. M5.Display.setTextFont(font);
        function lcdFont(obj, font)
        % lcdFont(m5u,font) sets a font type from 0-8
        %     Font Types: 0.ft_unknown   1.ft_glcd  2.ft_bmp  3. ft_rle  4. ft_gfx  
        %     5. ft_bdf  6. ft_vlw  7. ft_u8g2  8. ft_ttf   7. 
        % 
            % Syntax
            %     lcdFont(m5u,font)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     font - value representing font type. Possible Values: 0-8.
            %        Font Types: 0.ft_unknown   1.ft_glcd  2.ft_bmp  3. ft_rle  4. ft_gfx  
            %        5. ft_bdf  6. ft_vlw  7. ft_u8g2  8. ft_ttf   7.
            %       uint8
            cmdID = obj.M5LcdTextFont;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(font)); 
        end
% lcdCursor-------------------------------------------------------------------------------------
        % 8. M5.Display.setCursor(x, y);
        function lcdCursor(obj, xPos, yPos)
        % lcdCursor(m5u, xPos, yPos) sets the cursor at the positiion (xPos, yPos)
        % 
            % Syntax
            %     lcdCursor(m5u, xPos, yPos)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     xPos - horizontal cursor location
            %       uint16
            %     yPos - vertical cursor location
            %       uint16
            xyPos = [uint16(xPos), uint16(yPos)];
            xyData = typecast(swapbytes(xyPos),'uint8');
            cmdID = obj.M5LcdSetCursor;
            sendCommand(obj,obj.LibraryName,cmdID,xyData); 
        end
%% LCD Shapes [25+]
%-------------------------------------------------------------------------------------
        % 1. DrawPixel
        function lcdDrawPixel(obj, x, y, color)
        % lcdDrawPixel(m5u, x, y, color) draws a point at position (x, y) in color
        % if color is left empty, the function will use whatever color was used last
        % 
            % Syntax
            %     lcdDrawPixel(m5u, x, y, color)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     x - horizontal cursor location
            %       double
            %     y - vertical cursor location
            %       double
            %     color - color to set as a hexadecimal or string.
            %       uint16 | string
            % 
            % Examples
            %     lcdDrawPixel(m5u, 1, 1, 0x9A60); %brown
            %     lcdDrawPixel(m5u, 1, 12, m5u.lcdColor.BROWN); %brown
            % 
            % Run m5u.lcdColor for preset colors
            if nargin > 3
            xyc = [uint16(x), uint16(y),uint16(color)];
            else
            xyc = [uint16(x), uint16(y)];
            end
            xycData = typecast(swapbytes(xyc),'uint8');
            cmdID = obj.M5LcdDrawPixel;
            sendCommand(obj,obj.LibraryName,cmdID,xycData); 
        end
%-------------------------------------------------------------------------------------
% lcdDrawLine-------------------------------------------------------------------------------------       
        % 2. M5.Display.drawLine(x1, y1, x2, y2, color);
        function lcdDrawLine(obj, x1, y1, x2, y2, color)
        % lcdDrawLine(m5u, x1, y1, x2, y2, color) draws a line from point
        %     (x1,y1) to point (x2,y2) in color
        % 
            % Syntax
            %     lcdDrawLine(m5u, x1, y1, x2, y2, color)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     x1 - horizontal cursor location for the start point
            %       double
            %     y1 - vertical cursor location for the start point
            %       double
            %     x2 - horizontal cursor location for the end point
            %       double
            %     y2 - vertical cursor location for the end point
            %       double
            %     color - color to set as a hexadecimal or string.
            %       uint16 | string
            % 
            % Examples
            %     lcdDrawLine(m5u, 1, 1, 2, 2, 0x9A60); %brown
            %     lcdDrawLine(m5u, 1, 1, 2, 2, m5u.lcdColor.BROWN); %brown
            % 
            % Run m5u.lcdColor for preset colors
            xyxyc = [uint16(x1), uint16(y1), uint16(x2), uint16(y2),uint16(color)];
            xyxycData = typecast(swapbytes(xyxyc),'uint8');
            cmdID = obj.M5LcdDrawLine;
            sendCommand(obj,obj.LibraryName,cmdID,xyxycData); 
        end
%-------------------------------------------------------------------------------------
         % 3. M5.Display.drawFastHLine(x, 0, h, color);
%-------------------------------------------------------------------------------------
         % 4. M5.Display.drawFastVLine(x, 0, h, color);
% lcdDrawFillRect-------------------------------------------------------------------------------------
         % 5. M5.Display.fillRect(x0, y0, w, h, color)
         function lcdDrawFillRect(obj, x, y, width, height, color)
         % lcdDrawFillRect(m5u, x, y, width, height, color) draws a rectangle
         %     at point (x,y) with the specified width, height and color fill.
         %     if color is left empty, the function will use whatever color was used last
         % 
            % Syntax
            %     lcdDrawFillRect(m5u, x, y, width, height, color)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     x - horizontal cursor location
            %       double
            %     y - vertical cursor location
            %       double
            %     width - width for rectangle
            %       double
            %     height - height for rectangle
            %       double
            %     color - color to set as a hexadecimal or string (optional)
            %       uint16 | string
            % 
            % Examples
            %     lcdDrawFillRect(m5u, 1, 1, 5, 5, 0x9A60); %brown
            %     lcdDrawFillRect(m5u, 1, 1, 5, 5, m5u.lcdColor.BROWN); %brown
            % 
            % Run m5u.lcdColor for preset colors
            if nargin < 6
                rectype = 0b0000001; %Bitmask bit2(colored),bit1(rounded),bit0(filled)
                lcdDrawAllRectangle(obj, rectype, x, y, width, height) 
            else
                rectype = 0b0000101; %Colored
                lcdDrawAllRectangle(obj, rectype, x, y, width, height, color) 
            end
        end 
% lcdDrawRect-------------------------------------------------------------------------------------
        % 6. M5.Display.drawRect(x0, y0, width, height, color)
        function lcdDrawRect(obj, x, y, width, height, color)
         % lcdDrawRect(m5u, x, y, width, height, color) draws a rectangle
         %     at point (x,y) with the specified width, height and color.
         %     if color is left empty, the function will use whatever color was used last
         % 
            % Syntax
            %     lcdDrawRect(m5u, x, y, width, height, color)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     x - horizontal cursor location
            %       double
            %     y - vertical cursor location
            %       double
            %     width - width for rectangle
            %       double
            %     height - height for rectangle
            %       double
            %     color - color to set as a hexadecimal or string (optional)
            %       uint16 | string
            % 
            % Examples
            %     lcdDrawRect(m5u, 1, 1, 5, 5, 0x9A60); %brown
            %     lcdDrawRect(m5u, 1, 1, 5, 5, m5u.lcdColor.BROWN); %brown
            % 
            % Run m5u.lcdColor for preset colors
            if nargin < 6
                rectype = 0b0000000; %Bitmask bit2(colored),bit1(rounded),bit0(filled)
                lcdDrawAllRectangle(obj, rectype, x, y, width, height) 
            else
                rectype = 0b0000100; %Colored
                lcdDrawAllRectangle(obj, rectype, x, y, width, height, color) 
            end
        end
% lcdDrawRoundRect-------------------------------------------------------------------------------------
        % 7. M5.Display.drawRoundRect(x0, y0, w, h, radius, color)
        function lcdDrawRoundRect(obj, x, y, width, height, radius, color)
         % lcdDrawRoundRect(m5u, x, y, width, height, radius, color) draws a rounded rectangle
         %     at point (x,y) with the specified width, height, radius and color.
         %     if color is left empty, the function will use whatever color was used last
         % 
            % Syntax
            %     lcdDrawRoundRect(m5u, x, y, width, height, radius, color)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     x - horizontal cursor location
            %       double
            %     y - vertical cursor location
            %       double
            %     width - width for rectangle
            %       double
            %     height - height for rectangle
            %       double
            %     radius - radius for rectangle vertices
            %       double
            %     color - color to set as a hexadecimal or string (optional)
            %       uint16 | string
            % 
            % Examples
            %     lcdDrawRect(m5u, 1, 1, 5, 5, 3, 0x9A60); %brown
            %     lcdDrawRect(m5u, 1, 1, 5, 5, 3, m5u.lcdColor.BROWN); %brown
            % 
            % Run m5u.lcdColor for preset colors
            if nargin < 7
                rectype = 0b0000010; %Bitmask bit2(colored),bit1(rounded),bit0(filled)
                lcdDrawAllRectangle(obj, rectype, x, y, width, height, radius) 
            else
                rectype = 0b0000110; %Colored
                lcdDrawAllRectangle(obj, rectype, x, y, width, height, radius, color) 
            end
        end
% lcdDrawFillRoundRect-------------------------------------------------------------------------------------
      % 8. M5.Display.fillRoundRect(x0, y0, w, h, radius, color)
        function lcdDrawFillRoundRect(obj, x, y, width, height, radius, color)
         % lcdDrawFillRoundRect(m5u, x, y, width, height, radius, color) draws a rounded rectangle
         %     at point (x,y) with the specified width, height, radius and color fill.
         %     if color is left empty, the function will use whatever color was used last
         % 
            % Syntax
            %     lcdDrawFillRoundRect(m5u, x, y, width, height, radius, color)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     x - horizontal cursor location
            %       double
            %     y - vertical cursor location
            %       double
            %     width - width for rectangle
            %       double
            %     height - height for rectangle
            %       double
            %     radius - radius for rectangle vertices
            %       double
            %     color - color to set as a hexadecimal or string (optional)
            %       uint16 | string
            % 
            % Examples
            %     lcdDrawRect(m5u, 1, 1, 5, 5, 3, 0x9A60); %brown
            %     lcdDrawRect(m5u, 1, 1, 5, 5, 3, m5u.lcdColor.BROWN); %brown
            % 
            % Run m5u.lcdColor for preset colors
            if nargin < 7
                rectype = 0b0000011; %Bitmask bit2(colored),bit1(rounded),bit0(filled)
                lcdDrawAllRectangle(obj, rectype, x, y, width, height, radius) 
            else
                rectype = 0b0000111; %Colored
                lcdDrawAllRectangle(obj, rectype, x, y, width, height, radius, color) 
            end
        end
%-------------------------------------------------------------------------------------
         % 9. M5.Display.drawCircle(x, y, r, fill[true/false],color[rgb565])
          function lcdDrawCircle(obj, x, y, radius, fill, color)
         % lcdDrawCircle(m5u, x, y, radius, fill, color) draws a circle at point (x,y)
         %     with the specified color fill.
         %     fill = 0(false) or 1(true)
         %     if color is left empty, the function will use whatever color was last set
         % 
            % Syntax
            %     lcdDrawCircle(m5u, x, y, radius, fill, color)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     x - horizontal cursor location
            %       double
            %     y - vertical cursor location
            %       double
            %     radius - radius for circle
            %       double
            %     fill - indicate if circle should be filled with color: 0(false) or 1(true)
            %       double
            %     color - color to set as a hexadecimal or string (optional)
            %       uint16 | string
            % 
            % Examples
            %     lcdDrawCircle(m5u, 1, 1, 5, 1, 0x9A60); %brown
            %     lcdDrawCircle(m5u, 1, 1, 5, 1, m5u.lcdColor.BROWN); %brown
            % 
            % Run m5u.lcdColor for preset colors
            xyrfc = [uint16(x), uint16(y), uint16(radius)];
            xyrfc = [typecast(swapbytes(xyrfc),'uint8'),uint8(fill)];
            if nargin > 5
                xyrfc = [xyrfc, typecast(swapbytes(uint16(color)),'uint8')];
            end
            cmdID = obj.M5LcdDrawCircleFO;
            sendCommand(obj,obj.LibraryName,cmdID,xyrfc); 
        end
%-------------------------------------------------------------------------------------
         % 10. M5.Display.fillCircle(x, y, radius, color);
         function lcdFillCircle(obj, x, y, radius, color)
         % lcdFillCircle(m5u, x, y, radius, color) draws a filled circle at point (x,y)
         %     with the specified color fill.
         %     if color is left empty, the function will use whatever color was last set
         % 
            % Syntax
            %     lcdFillCircle(m5u, x, y, radius, color)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     x - horizontal cursor location
            %       double
            %     y - vertical cursor location
            %       double
            %     radius - radius for circle
            %       double
            %     color - color to set as a hexadecimal or string (optional)
            %       uint16 | string
            % 
            % Examples
            %     lcdFillCircle(m5u, 1, 1, 5, 0x9A60); %brown
            %     lcdFillCircle(m5u, 1, 1, 5, m5u.lcdColor.BROWN); %brown
            % 
            % Run m5u.lcdColor for preset colors
             fill = true;
             if nargin > 4
             lcdDrawCircle(obj, x, y, radius, fill, color);
             else
                 lcdDrawCircle(obj, x, y, radius, fill);
             end
         end
         % 11.drawEllipse
% 12.fillEllipse

%-------------------------------------------------------------------------------------
         % 13. M5.Display.drawTriangle(cx, cy - i, cx - i, cy + i, cx + i, cy + i,
%-------------------------------------------------------------------------------------
         % 14. M5.Display.fillTriangle(cx, cy - i, cx - i, cy + i, cx + i, cy + i, display.color565(0, i, i));
% 15.drawBezier
% 16.drawEllipseArc

%-------------------------------------------------------------------------------------
         % 17. M5.Display.fillEllipseArc(display.width()>>1, display.height()>>1, 640, 480, 360, 270, i, i + 1, display.color888(255-(i*256/360), i*256/360, 255));
%------------------------------------------------------------------------------------- 
        % 18.drawArc
%------------------------------------------------------------------------------------- 
         % 19. M5.Display.fillArc(needle_x, needle_y, r1, r1, 225, 315, TFT_BLACK);
%------------------------------------------------------------------------------------- 
        % 20.drawCircleHelper
%------------------------------------------------------------------------------------- 
        % 21.fillCircleHelper
%------------------------------------------------------------------------------------- 
        % 22.floodFill
%------------------------------------------------------------------------------------- 
        % 23.paint
%------------------------------------------------------------------------------------- 
        % 24.fillAffine
%-------------------------------------------------------------------------------------         
        % 25.drawGradientLine
%-------------------------------------------------------------------------------------
         % ?. M5.Display.fillScreen(TFT_WHITE);
%-------------------------------------------------------------------------------------
         % ?. M5.Display.writeFillRectPreclipped((x<<2)+xpos,ypos,1,1,TFT_BLACK);  
         
%% LCD Images [9]
%-------------------------------------------------------------------------------------
        % 1. M5.Display.drawJpg(jpg_image, ~0u, 0, 0, display.width(), display.height(), 0, 0, 0.0f, -1.0f);
        % 1. M5.Display.drawJpg(const uint8_t *jpg_data, size_t jpg_len, uint16_t x = 0, uint16_t y = 0, uint16_t maxWidth = 0, uint16_t maxHeight = 0, uint16_t offX = 0, uint16_t offY = 0, jpeg_div_t scale = JPEG_DIV_NONE);
        % 1. M5.Display.drawJpg(data_pointer, data_length, 0, 0);
%-------------------------------------------------------------------------------------
        % 2. M5.Display.drawPng(png_logo, ~0u, 0, 0, display.width(), display.height()*2/3, 0, 0, 1.0f, 0.0f, datum_t::middle_center);
        % 2. M5.Display.drawPng(data_pointer, data_length, 0, 0);
%-------------------------------------------------------------------------------------
        % 3. M5.Display.drawBmp(data_pointer, data_length, 0, 0);
%-------------------------------------------------------------------------------------
        % 4. M5.Display.drawJpgFile(SPIFFS, "/filename.jpg", 0, 0);
%-------------------------------------------------------------------------------------
        % 5. M5.Display.drawBmpFile(SPIFFS, "/filename.bmp", 0, 0);
%-------------------------------------------------------------------------------------
        % 6. M5.Display.drawPngFile(SPIFFS, "/filename.png", 0, 0);
%-------------------------------------------------------------------------------------
        % 7. M5.Display.drawJpgUrl("http://example.com/url.jpg", 0, 0);
%-------------------------------------------------------------------------------------
        % 8. M5.Display.drawBmpUrl("http://example.com/url.bmp", 0, 0);
%-------------------------------------------------------------------------------------
        % 9. M5.Display.drawPngUrl("http://example.com/url.png", 0, 0);
%-------------------------------------------------------------------------------------      
% displayJPG -------------------------------------------------------------------------------------
% NOT WORKING/UNTESTED
% Image must be broken up into multiple 720 byte packets and buffered before calling drawjpg
        function displayJPG(obj) 
            % display.drawJpg(jpg_image, ~0u, 0, 0, display.width(), display.height(), 0, 0, 0.0f, -1.0f);
            % drawJpg(const uint8_t *jpg_data, size_t jpg_len, uint16_t x = 0, uint16_t y = 0, uint16_t maxWidth = 0, uint16_t maxHeight = 0, uint16_t offX = 0, uint16_t offY = 0, jpeg_div_t scale = JPEG_DIV_NONE);
            cmdID = obj.M5DrawJPG;
            imData = uint8(fileread('yorku-logo.jpg'));
            sendCommand(obj,obj.LibraryName,cmdID,imData);

            % % from ai:
            % % Read the .jpg file
            % imageData = imread('yorku-logo.jpg');
            % % Convert the image data into a byte vector
            % byteVector = reshape(imageData, [], 1);
            % % Find the length of the byte vector
            % vectorLength = length(byteVector);
            % % Convert vectorLength to a 16-bit integer
            % int16VectorLength = int16(vectorLength);
            % % Convert the 16-bit integer to two 8-bit bytes
            % byte1 = bitshift(int16VectorLength, -8);
            % byte2 = bitand(int16VectorLength, 255);
            % % Add the first two bytes to the front of the byte vector
            % newByteVector = cat(1, byte1, byte2, byteVector);
        end
% drawBitmap-------------------------------------------------------------------------------------
%NOT WORKING/UNTESTED
        function drawBitmap(obj, bitmap)
            %  Write a 320x240 RGB bitmap using multiple send commands
            cmdID = obj.M5DrawBitmap;
            % Convert the bitmap to a byte vector
            byteVector = reshape(bitmap, [], 1);
            % Calculate the number of send commands needed
            nPackets = ceil(length(byteVector) / maxPacketSize);
            % Loop through each send command
            for i = 1:nPackets
                % Calculate the start and end indices for the current command
                startIndex = (i - 1) * maxPacketSize + 1;
                endIndex = min(i * maxPacketSize, length(byteVector));

                % Get the data for the current command, add the packet number and total number of packets ot the beginning
                data = [typecast(uint16(i), 'uint8'), typecast(uint16(nPackets), 'uint8'), byteVector(startIndex:endIndex)];

                % Send the command to the M5Stack display
                
                sendCommand(obj, obj.LibraryName, cmdID, data);
            end
        end
% drawPNG-------------------------------------------------------------------------------------
%NOT WORKING - Yorku-iconXS.png is 491 bytes, but doesn't buffer/render correctly
         function lcdDrawPNG(obj)
            fileID = fopen('York-iconXS.png', 'rb');
            pngData = fread(fileID, inf, '*uint8');
            %pngData = uint8(fileread('York-iconXS.png'));
            cmdID = obj.M5LcdDrawDrawPNG;
            sendCommand(obj,obj.LibraryName,cmdID,byteVector); 
         end


%% M5 Real Time Clock Class-------------------------------------------------------------------------------------
        % M5.Rtc.isEnabled();
%% M5 Power Class [20 functions]------------------------------------------------------------------------------------
% M5PowerBegin------------------------------------------------------------------------------------
        % 1. M5.Power.begin(void)
        function powerBegin(obj) %Not really needed since M5.begin calls this
            cmdID = obj.M5PwrBegin;
            dataIn = 0x00;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
%-------------------------------------------------------------------------------------
        % 2. M5.Power.setExtOutput(bool enable, ext_port_mask_t port_mask = (ext_port_mask_t)0xFF); % Set power output of the external ports. 
%-------------------------------------------------------------------------------------
        % 3. M5.Power.getExtOutput(void); % Get power output of the external ports.
%-------------------------------------------------------------------------------------
        % 4. M5.Power.setUsbOutput(bool enable); % Set power output of the main USB port.
%-------------------------------------------------------------------------------------
        % 5. M5.Power.getUsbOutput(void);   % Get power output of the main USB port.
% M5PowerLED------------------------------------------------------------------------------------
        % 6. M5.Power.setLed(uint8_t brightness)
        function powerLED(obj, brightness)
        % powerLED(m5u, brightness) sets the intensity of the power LED
        %     brightness = 0(off) to 255(Full Intensity)
        % 
            % Syntax
            %     powerLED(m5u, brightness)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     brightness - value of LED intensity to set. 0-255.
            %       double
            cmdID = obj.M5PwrSetLED;
            dataIn = uint8(brightness);
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% M5PwrOff------------------------------------------------------------------------------------
        % 7. M5.Power.powerOff(void);
        function powerOff(obj)
        % powerOff(m5u) turn all M5 power off
            cmdID = obj.M5PwrOff;
            dataIn = 0x00;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            M5UnifiedSelfDistruct(obj);
        end
%-------------------------------------------------------------------------------------
        % 8. M5.Power.timerSleep(int seconds);
        % 8. M5.Power.timerSleep(const rtc_time_t& time);
        % 8. M5.Power.timerSleep(const rtc_date_t& date, const rtc_time_t& time);
%-------------------------------------------------------------------------------------
        % 9. M5.Power.deepSleep(std::uint64_t micro_seconds = 0, bool touch_wakeup = true);
%-------------------------------------------------------------------------------------
        % 10. M5.Power.lightSleep(std::uint64_t micro_seconds = 0, bool touch_wakeup = true);
% GetBatteryLevel------------------------------------------------------------------------------------
        % 11. int32 = M5.Power.getBatteryLevel();
        function battLevel = powerGetBatteryLevel(obj)
        % battLevel = powerGetBatteryLevel(m5u) returns the current battery level
        %
            % Syntax
            %     battLevel = powerGetBatteryLevel(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %
            % Output Arguments
            %     battLevel - the current battery level
            %       uint32
            cmdID = obj.M5PwrGetBatteryLvl;
            dataIn = 0x00;
            dataOut = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            battLevel = typecast(cast(dataOut,'uint8'),'uint32');
        end
%-------------------------------------------------------------------------------------
        % 12. M5.Power.setBatteryCharge(bool enable);
%-------------------------------------------------------------------------------------
        % 13. M5.Power.setChargeCurrent(std::uint16_t max_mA);
%-------------------------------------------------------------------------------------
        % 14. M5.Power.setChargeVoltage(std::uint16_t max_mV);
%-------------------------------------------------------------------------------------
        % 15. is_charging_t = M5.Power.isCharging(void);
% GetBatteryVoltage------------------------------------------------------------------------------------
        % 16. int16_t = M5.Power.getBatteryVoltage(void);
        function battVoltage = powerGetBatteryVoltage(obj)
        % battVoltage = powerGetBatteryVoltaget() returns the M5 battery voltage in mV            
        %
            % Syntax
            %     battVoltage = powerGetBatteryVoltaget(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %
            % Output Arguments
            %     battVoltage - the amount of voltage in the M5 battery
            %       uint16
            cmdID = obj.M5PwrGetBatteryVolt;
            dataIn = 0x00;
            dataOut = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            battVoltage = typecast(cast(dataOut,'uint8'),'int16');
        end
% GetBatteryCurrent------------------------------------------------------------------------------------
        % 17.  int32_t = M5.Power.getBatteryCurrent(void);
        function battCurrent = powerGetBatteryCurrent(obj)
        % battCurrent = powerGetBatteryCurrent() returns M5 battery current flow in mA
        %
            % Syntax
            %     battCurrent = powerGetBatteryCurrent(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %
            % Output Arguments
            %     battVoltage - the amount of current in the M5 battery
            %       uint32
        % positive value charging/negative value discharging 
            cmdID = obj.M5PwrGetBatteryCurr;
            dataIn = 0x00;
            dataOut = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            battCurrent = typecast(cast(dataOut,'uint8'),'int32');
        end
% M5PwrGetKeyState------------------------------------------------------------------------------------
        % 18.  uint8_t = M5.Power.getKeyState(void);
        function keystate = powerGetKeyState(obj)
        % keystate = powerGetKeyState(m5u) returns whether the power key was pressed
        %
            % Syntax
            %     keystate = powerGetKeyState(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %
            % Output Arguments
            %     keystate - the state of the power key. Possible values:
            %        0=none / 1=long pressed / 2=short clicked / 3=both
            %       uint8
            cmdID = obj.M5PwrGetKeyState;
            dataIn = 0x00;
            keystate = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% vibrationMotor(obj, level)----------------------------------------------------------------------
        % 19. M5.Power.setVibration(uint8_t level);
        function vibrationMotor(obj, level)
        % vibrationMotor(m5u, level) sets the motor to the specified intensity
        %     level = 0 to 255
        %
            % Syntax
            %     vibrationMotor(m5u, level)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     level - vibration intensity of the motor. 0-255.
            %       uint8
            cmdID = obj.M5PwrSetVibration;
            dataIn = uint8(level);
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
%-------------------------------------------------------------------------------------
        % 20. pmic_t = M5.Power.getType(void) const { return _pmic; }
%-------------------------------------------------------------------------------------
%% M5 Button Class
% buttonUpdate-------------------------------------------------------------------------------
    % Working, but not reliably
        function [pwrButton,buttonA,buttonB,buttonC] = buttonUpdate(obj)
            % [pwrButton,buttonA,buttonB,buttonC] = buttonUpdate(m5u) checks whether
            %     the Power Button, Button A, Button B or Button C were pressed. 
            %     Index for the button whose state you want to check.
            % Syntax
            %     [pwrButton,buttonA,buttonB,buttonC] = buttonUpdate(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %
            % Output Arguments
            %     [pwrButton,buttonA,buttonB,buttonC] - an array of the states of the 
            %        Power Button, Button A, Button B and Button C.
            %        Possible states: {'Idle','Held', 'Clicked', 'Pressed', 'Released', 'Multiple Clicks'}
            %       array of character vectors
                    cmdID = obj.M5ButtonUpdate;
                    dataIn = 0x00;
                    % Print out the button names with their state information
                    %buttonNames = {'Power Button', 'Button A', 'Button B', 'Button C'};
                    buttonStates = {'Idle','Held', 'Clicked', 'Pressed', 'Released', 'Multiple Clicks'};
                    val = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
                    val = uint8(val);
                    pwrButton = buttonStates{val(4)+1};
                    buttonA = buttonStates{val(3)+1};
                    buttonB = buttonStates{val(2)+1};
                    buttonC = buttonStates{val(1)+1};
                    
                    % For debug:
                    % fprintf('Button States:\n');
                    % fprintf('--------------\n');
                    % fprintf('Power Button: %s\n', pwrButton);
                    % fprintf('Button A: %s\n', buttonA);
                    % fprintf('Button B: %s\n',buttonB);
                    % fprintf('Button C: %s\n',buttonC);
        end
%% M5 Speaker Class [4]
% SpeakerBegin-------------------------------------------------------------------------------------
        % 1. M5.Speaker.begin();
        function speakerBegin(obj) %Not really needed since M5.begin calls this
            cmdID = obj.M5SpeakerBegin;
            dataIn = 0x00;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% SpeakerStop-------------------------------------------------------------------------------------        
        % 2. M5.Speaker.stop();
        function speakerStop(obj)
        % speakerStop(m5u) Stops speaker output
            cmdID = obj.M5SpeakerStop; 
            dataIn = 0x00; 
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% SpeakerTone-------------------------------------------------------------        
        % 3. M5.Speaker.tone(float frequency, uint32_t duration = UINT32_MAX, 
            % int channel = -1, bool stop_current_sound = true));
        function speakerTone(obj, freq, dur, channel, stop_current_sound)
        % speakerTone(m5u, freq, dur, channel, stop_current_sound) plays a tone
        %     at the specifiec frequency, channel and for the duration.
            % 
            % Syntax
            %     speakerTone(m5u, freq, dur, channel, stop_current_sound)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     freq - Tone frequency (Hz) 0 to 4,294,967,295. Can be a fraction
            %       double
            %     dur - Tone duration in milliseconds. 0 to 4,294,967,295. Can be a fraction
            %       double
            %     channel - Virtual channel to play the tone at: 0-7
            %       uint16
            %     stop_current_sound - indicate whether to stop the current tone. 0(No) or 1(Yes)
            %       uint16
            % Example
            %     speakerTone(m5u, 1000, 2000, 1, 1);

            % Convert arguments to byte arrays
            freqBytes = num2hex(freq);
            durBytes = num2hex(dur);
            chnlBytes = uint16(channel);
            stopCurSndBytes = uint16(stop_current_sound);
        
            toneData(1) = chnlBytes;
            toneData(2) = stopCurSndBytes;

            % assign 16 indices for frequency bits and the following 16 for duration
            counter = 1;
            for i = 3:18
                toneData(i) = freqBytes(counter);
                toneData(i+16) = durBytes(counter);
                counter = counter+1;
            end

            cmdID = obj.M5SpeakerTone;
            dataIn = toneData;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% SpeakerSetVolume-------------------------------------------------------------------------------------
        % 4. M5.Speaker.setVolume(int vol);
            %vol: volume to set the speaker at
        function speakerSetVolume(obj, vol)
        % speakerSetVolume(m5u, vol) sets the volume of the speaker
        %     vol - 0(None) to 255(Full)
        %     Volume inputs > 255 will remain at 255. < 0 will remain at 0.
        % 
            % Syntax
            %     speakerSetVolume(m5u, vol)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            %     vol - Speaker volume. 0-255.
            %       uint8

            min_volume = 0;
            max_volume = 255;
            
            % Check for out of bounds volume
            if vol < min_volume
                vol = 0;
            elseif vol > max_volume
                vol = 255;
            end

            % Convert arguments to byte arrays
            volBytes = cast(vol, 'uint8');
            disp(volBytes)
            cmdID = obj.M5SpeakerSetVolume;
            dataIn = volBytes;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end

% SpeakerGetVolume-------------------------------------------------------------------------------------
        % 4. M5.Speaker.speakerGetVolume();
        function vol = speakerGetVolume(obj)
        % speakerGetVolume(m5u) returns the volume of the speaker
        % 
            % Syntax
            %     speakerGetVolume(m5u)
            %
            % Input Arguments
            %     m5u - Arduino hardware connection with M5Unified addon
            %       object
            % Output Arguments
            %     vol - current speaker volume. 0-255.
            %       uint8
            cmdID = obj.M5SpeakerGetVolume; %5
            dataIn = 0x00;
            [dataOut, ~] = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            vol = cast(dataOut,'uint8');
        end
%% M5 Microphone Class
% micBegin-----------------------------------------------------------------------------------
        function micBegin(obj) %Not really needed since M5.begin calls this
            cmdID = obj.M5MicBegin;
            val = sendCommand(obj, obj.LibraryName, cmdID, 0x00);
            disp(val)
        end
    end %of Public Methods

    methods(Access = private)
        function M5UnifiedDelete(~)

            % Remove arduino and M5Unified objects from the workspace
            
            % Get all variables in the base workspace
            vars = evalin('base', 'whos');
            
            % Initialize an array to hold names of Arduino objects
            arduinoObjNames = {};
            M5UnifiedObjNames = {};
            
            % Loop through the variables and check their class
            for i = 1:length(vars)
                varName = vars(i).name;
                % Check if the variable is of class 'arduino'
                if strcmp(evalin('base', ['class(', varName, ')']), 'arduino')
                    arduinoObjNames{end+1} = varName; % Add to the list
                elseif strcmp(evalin('base', ['class(', varName, ')']), 'arduinoioaddons.M5Stack.M5Unified')
                    M5UnifiedObjNames{end+1} = varName; % Add to the list
                end
            end
            %disp(arduinoObjNames);
            %disp(M5UnifiedObjNames);
            expression = strjoin(['clear' string(M5UnifiedObjNames) string(arduinoObjNames)],' ');
            evalin('base', expression);
        end
        %% lcdDrawAllRectangle-------------------------------------------------------------------------------------
        function lcdDrawAllRectangle(obj, rectype, x, y, width, height, varargin)
            % lcdDrawAllRectangle(rectype, x, y, width, height, varargin) 
            % rectype is read as a Bitmask: bit2(colored),bit1(rounded),bit0(filled)
            xywhrc = [uint16(x), uint16(y), uint16(width), uint16(height)];
            if (bitand(rectype, 2)) %Rounded
                xywhrc = [xywhrc, uint16(varargin{1})]; %Add the radius
            end
            if (bitand(rectype, 4)) %Colored 
                xywhrc = [xywhrc, uint16(varargin{end})]; %Add the color
            end
            dataOut = typecast(swapbytes(xywhrc),'uint8');
            cmdID = obj.M5LcdDrawRectFOR;
            sendCommand(obj,obj.LibraryName,cmdID,[rectype,dataOut]); 
        end
    end
end %of M5Unified Class