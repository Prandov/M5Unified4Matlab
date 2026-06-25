%% Custom Arduino Add-On Library for the M5Unified Library by M5Stack
% ==================================================================================================
% M5Unified class
% Copyright 2024, Eric Prandovszky, Greatlove Bariboloka 
% Contact: prandov@yorku.ca, greatlebari@gmail.com
% Version: 0.4.7
% Date: Oct 23, 2024
% This .m file interacts with the M5UnifiedML.h C header file uploaded to an M5Stack device.
% ==================================================================================================

%% This Class creates an M5Unified add-on device object. 
% This allows you to communicate with the integrated peripherals on M5Stack Devices(IMU,LCD,MIC,PMU,SPKR,etc.)

% First initialize communication with the ESP32 inside the M5Stack. 
% Example:
%   esp = arduino('COM6','ESP32-WROOM-DevKitC','Libraries',{'I2C', 'M5Stack/M5Unified'},'Traceon', true);

% Then initialize this unified library. 
% Example:
%   m5u= addon(esp,'M5Stack/M5Unified');

% Use the 'arduino' object namespace to communicate with the ESP32.
% Example:
%  writeDigitalPin(esp,'D32',0); OR  esp.writeDigitalPin('D32',0);
%  readVoltage(esp,'D33');       OR  esp.readVoltage('D33');

% Use the 'addon' object namespace to communicate with the integrated peripherals.
% Example:
%   powerLED(m5u,255)  OR  m5u.powerLED(255);

%% References:
% CLASS DESCRIPTION: https://www.mathworks.com/help/matlab/arduinoio-custom-arduino-libraries.html
% CREATION STEPS: https://www.mathworks.com/help/matlab/supportpkg/create-custom-arduino-add-on-library.html
% EXAMPLE: https://www.mathworks.com/help/matlab/supportpkg/create-code-to-write-a-string.html

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

        M5Begin               = 0x01

        % LCD 0x20 to 0x4F
        
        M5LcdBegin            = 0x20
        M5LcdClear            = 0x23
        M5LcdPrt              = 0x2E 
        M5LcdPrtLn            = 0x2F 
        
        % IMU       0x50    %TODO
        % Log       0x60    %TODO
        % Power     0x70 //20 functions
        % RTC       0x80    %TODO
        % Touch     0x90    %TODO
        % Button    0xA0
        % Speaker   0xB0
        % Mic       0xC0    %TODO
        % pSRAM     0xD0    %TODO
        % SD        0xE0    %TODO
        % For now, most command ID's are set within their function.
    end
    properties(Access = public, Constant = true)
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
            'PINK'       ,   0xFE19, ...      % RGB888 255, 192, 203  //Lighter pink, was 0xFC9F
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
        % M5.begin     /// Perform initialization process at startup.
        % M5.update 
        % M5.getBoard
        % M5.getUpdateMsec
        % M5.config
        % M5.getPin
% begin-------------------------------------------------------------------------------------
        % M5.begin Instantiates the following when you call it
        function begin(obj)
        % M5.begin Instantiates the following when you call it
            %    M5GFX Display;  // setPrimary
            %    M5GFX &Lcd = Display; //Creates a pointer for LCD to Display
            %    IMU_Class Imu;
            %    Log_Class Log;
            %    Power_Class Power;
            %    RTC8563_Class Rtc;
            %    Touch_Class Touch;
            %    Button_Class BtnA;
            %    Button_Class BtnB;
            %    Button_Class BtnC;
            %    Button_Class BtnEXT;  // CoreInk top button
            %    Button_Class BtnPWR;  // CoreInk power button / AXP192 power button
            %    I2C_Class& In_I2C = m5::In_I2C; //for internal I2C device
            %    I2C_Class& Ex_I2C = m5::Ex_I2C; //for external I2C device (Port.A)
            %    Speaker_Class Speaker;
            %    Mic_Class Mic;

            cmdID = obj.M5Begin; %0x01
            dataIn = 0x00;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% getBoardType-------------------------------------------------------------------------------------
        %M5.getBoard()
        function boardName = getM5Type(obj)
        % boardName = getM5Type() gets the board type of the runtime environment. @return board type
            cmdID = 0x02;             
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
            % [heapSize, heapFree, psramSize, psramFree] = memoryStatus()
            %    returns the size of the heap memory, amount of free heap,
            %    size of PSRAM, and amount of free PSRAM respectively
            %    Index the result to access each value.
            cmdID = 0x03;
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
        % delay(n) delays the M5 for a specified duration n between 0 and
        %    255 ms, where n can also be a fraction.
            durBytes = uint8(dur);
            cmdID = 0x04;
            dataIn = durBytes;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
%% M5 LCD Display [12]
% M5.LCD is a reference to M5.Display which is an M5GFX object inhereted from LGFX
% lcdBegin-------------------------------------------------------------------------------------
         % 1. M5.Display.begin();
         function lcdBegin(obj) %Not really needed since M5.begin calls this
         % lcdBegin initializes the M5 lcd.
         % Implicitly called by M5.begin
            cmdID = 0x20; 
            dataIn = 0x00; 
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
         end
%------------------------------------------------------------------------------------- 
        % 2. M5.Display.startWrite(); % using startWrite and endWrite before and after the drawing process suppresses bus allocation
        % 3. M5.Display.endWrite(); 
% lcdClear-------------------------------------------------------------------------------------
        % 4. M5.Display.clear();
        function lcdClear(obj)
        % lcdClear clears the M5 lcd
            cmdID = 0x23; 
            dataIn = 0x00; 
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
%-------------------------------------------------------------------------------------
        % 5. M5.Display.display();
        function lcdDisplay(obj)
            cmdID = 0x24;
            % [dataOut, payloadSize] = sendCommand(obj, libName, commandID, dataIn, timeout)
            dataIn = 0x00;
            sendCommand(obj,obj.LibraryName,cmdID,dataIn);
        end   
%-------------------------------------------------------------------------------------
        % 6. M5.Display.height()
        function height = lcdGetHeight(obj)
        % height = lcdGetHeight() returns the height of the lcd
            cmdID = 0x25;
            % [dataOut, payloadSize] = sendCommand(obj, libName, commandID, dataIn, timeout)
            dataIn = 0x00;
            dataOut = sendCommand(obj,obj.LibraryName,cmdID,dataIn);
            height = typecast(cast(dataOut,'uint8'),'uint16');
        end   
%-------------------------------------------------------------------------------------
        % 7. M5.Display.width()
        function width = lcdGetWidth(obj) 
        % width = lcdGetWidth() returns the width of the lcd
            cmdID = 0x26;
            % [dataOut, payloadSize] = sendCommand(obj, libName, commandID, dataIn, timeout)
            dataIn = 0x00;
            dataOut = sendCommand(obj,obj.LibraryName,cmdID,dataIn);
            width = typecast(cast(dataOut,'uint8'),'uint16');
        end   
% getDisplayCount-------------------------------------------------------------------------------------
        % 8. M5.getDisplayCount()
        function count = lcdGetDisplays(obj)
        % count = lcdGetDisplays() returns the number of displays connected to the M5
            cmdID = 0x27;
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
        % lcdBrightness(brightness) adjusts the display backlight to the
        % specified brightness between 0(Off) and 255 (Full)
            cmdID = 0x2A; 
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
        % lcdPrint(string) displays the specified string on the display a
        %     the current cursor location
            cmdID = 0x2E;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(char(string))); 
        end
% lcdPrintLn-------------------------------------------------------------------------------------
        % 2. M5.Display.println(text);
        function lcdPrintLn(obj,string)
        % lcdPrintLn(string) displays the specified string on the display
        %     on a new line
            cmdID = 0x2F; 
            sendCommand(obj,obj.LibraryName,cmdID,uint8(char(string))); 
        end
% lcdDrawStr-------------------------------------------------------------------------------------
        % 3. M5.Display.drawString(text, x, y);
        function lcdDrawStr(obj,x,y,string) %Font and Colour Not Working
        % lcdDrawStr(x,y,string) draws a character at position (x,y)
            xybytes = typecast(swapbytes([uint16(x), uint16(y)]),'uint8');
            text = uint8(char(string));
            xytextData = [xybytes,text];
            cmdID = 0x30;
            sendCommand(obj,obj.LibraryName,cmdID,xytextData);
        end
% lcdTextColor-------------------------------------------------------------------------------------
        % 4. M5.Display.setTextColor(textColor)
        % 4. M5.Display.setTextColor(textColor, bgColor);
        function lcdTextColor(obj,textColor,bgColor)
        % lcdTextColor(color) sets the text color and background color 
        %    if only one argument is supplied, only text color will be set
        %    if two arguments are passed, both text and bg colors will be set
            fgColor = uint16(textColor);
            if nargin == 2 %Only Text Color
                fbColor = typecast(swapbytes(fgColor),'uint8');
            elseif nargin == 3 % Text and Background Color
                fbColor = typecast(swapbytes([fgColor,uint16(bgColor)]),'uint8');
            else
                % Code to execute when there are more than two input arguments
                disp('Invalid number of arguments');
            end
            cmdID = 0x31;
            sendCommand(obj,obj.LibraryName,cmdID,fbColor); 
        end
% lcdTextDatum-------------------------------------------------------------------------------------
        % 5. M5.Display.setTextDatum(textdatum_t::bottom_center);
        function lcdTextDatum(obj, datum)
        % lcdTextDatum(datum) sets the text position reference datum
            % 0:Top left (default)  1:Top Centre        2:Top Right
            % 4:Middle Left         5:Middle Centre     6:Middle Right         
            % 8:Bottom Left         9:Bottom Centre     10:Bottom Right
            % 16:Baseline Left      17:Baseline Centre  18:Baseline Right
            cmdID = 0x32;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(datum)); 
        end
% lcdTextSize-------------------------------------------------------------------------------------
        % 6. M5.Display.setTextSize(size); %setTextSize is a float
        function lcdTextSize(obj, size)
        % lcdTextSize(size) sets the text size, where size can be a fraction
            cmdID = 0x33;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(size)); 
        end
% lcdFont-------------------------------------------------------------------------------------
        % Working but needs improvement, the function is marked as depreciated in the M5Unified Library
        % 7. M5.Display.setTextFont(font);
        function lcdFont(obj, font)
        % lcdFont(font) sets a font type from 0-8
        %     Font Types: 0.ft_unknown   1.ft_glcd  2.ft_bmp  3. ft_rle  4. ft_gfx  
        %     5. ft_bdf  6. ft_vlw  7. ft_u8g2  8. ft_ttf   7. 
            cmdID = 0x34;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(font)); 
        end
% lcdCursor-------------------------------------------------------------------------------------
        % 8. M5.Display.setCursor(x, y);
        function lcdCursor(obj, xPos, yPos)
        % lcdCursor(xPos, yPos) sets the cursor at the positiion (xPos, yPos)
            xyPos = [uint16(xPos), uint16(yPos)];
            xyData = typecast(swapbytes(xyPos),'uint8');
            cmdID = 0x35;
            sendCommand(obj,obj.LibraryName,cmdID,xyData); 
        end
%% LCD Shapes [25+]
%-------------------------------------------------------------------------------------
        % 1. DrawPixel
        function lcdDrawPixel(obj, x, y, color)
        % lcdDrawPixel(x, y, color) draws a point at position (x, y) in color
        % if color is left empty, the function will use whatever color was used last
            if nargin > 3
            xyc = [uint16(x), uint16(y),uint16(color)];
            else
            xyc = [uint16(x), uint16(y)];
            end
            xycData = typecast(swapbytes(xyc),'uint8');
            cmdID = 0x36;
            sendCommand(obj,obj.LibraryName,cmdID,xycData); 
        end
%-------------------------------------------------------------------------------------
% lcdDrawLine-------------------------------------------------------------------------------------       
        % 2. M5.Display.drawLine(x1, y1, x2, y2, color);
        function lcdDrawLine(obj, x1, y1, x2, y2, color)
        % lcdDrawLine(x1, y1, x2, y2, color) draws a line from point
        %     (x1,y1) to point (x2,y2) in color
            xyxyc = [uint16(x1), uint16(y1), uint16(x2), uint16(y2),uint16(color)];
            xyxycData = typecast(swapbytes(xyxyc),'uint8');
            cmdID = 0x37;
            sendCommand(obj,obj.LibraryName,cmdID,xyxycData); 
        end
%-------------------------------------------------------------------------------------
         % 3. M5.Display.drawFastHLine(x, 0, h, color);
%-------------------------------------------------------------------------------------
         % 4. M5.Display.drawFastVLine(x, 0, h, color);
% lcdDrawFillRect-------------------------------------------------------------------------------------
         % 5. M5.Display.fillRect(x0, y0, w, h, color)
         function lcdDrawFillRect(obj, x, y, width, height, color)
         % lcdDrawFillRect(x, y, width, height, color) draws a rectangle
         %     at point (x,y) with the specified width, height and color fill.
         %     if color is left empty, the function will use whatever color was used last
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
         % lcdDrawRect(x, y, width, height, color) draws a rectangle
         %     at point (x,y) with the specified width, height and color.
         %     if color is left empty, the function will use whatever color was used last        
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
         % lcdDrawRoundRect(x, y, width, height, radius, color) draws a rounded rectangle
         %     at point (x,y) with the specified width, height, radius and color.
         %     if color is left empty, the function will use whatever color was used last
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
         % lcdDrawFillRoundRect(x, y, width, height, radius, color) draws a rounded rectangle
         %     at point (x,y) with the specified width, height, radius and color fill.
         %     if color is left empty, the function will use whatever color was used last
            if nargin < 7
                rectype = 0b0000011; %Bitmask bit2(colored),bit1(rounded),bit0(filled)
                lcdDrawAllRectangle(obj, rectype, x, y, width, height, radius) 
            else
                rectype = 0b0000111; %Colored
                lcdDrawAllRectangle(obj, rectype, x, y, width, height, radius, color) 
            end
        end
%% lcdDrawAllRectangle-------------------------------------------------------------------------------------
        function lcdDrawAllRectangle(obj, rectype, x, y, width, height, varargin)
            % lcdDrawAllRectangle(rectype, x, y, width, height, varargin) 
            % rectype is read as a Bitmask: bit2(colored),bit1(rounded),bit0(filled)
            % Usually this function would be called by one of the other rectangle functions, 
            % but you can also call it directly if you wish
            xywhrc = [uint16(x), uint16(y), uint16(width), uint16(height)];
            if (bitand(rectype, 2)) %Rounded
                xywhrc = [xywhrc, uint16(varargin{1})]; %Add the radius
            end
            if (bitand(rectype, 4)) %Colored 
                xywhrc = [xywhrc, uint16(varargin{end})]; %Add the color
            end
            dataOut = typecast(swapbytes(xywhrc),'uint8');
            cmdID = 0x3A;
            sendCommand(obj,obj.LibraryName,cmdID,[rectype,dataOut]); 
        end
%-------------------------------------------------------------------------------------
         % 9. M5.Display.drawCircle(x, y, r, fill[true/false],color[rgb565])
          function lcdDrawCircle(obj, x, y, radius, fill, color)
         % lcdDrawCircle(x, y, radius, fill, color) draws a circle at point (x,y)
         %     with the specified color fill.
         %     fill = 0(false) or 1(true)
         %     if color is left empty, the function will use whatever color was last set               
            xyrfc = [uint16(x), uint16(y), uint16(radius)];
            xyrfc = [typecast(swapbytes(xyrfc),'uint8'),uint8(fill)];
            if nargin > 5
                xyrfc = [xyrfc, typecast(swapbytes(uint16(color)),'uint8')];
            end
            cmdID = 0x3C;
            sendCommand(obj,obj.LibraryName,cmdID,xyrfc); 
        end
%-------------------------------------------------------------------------------------
         % 10. M5.Display.fillCircle(x, y, radius, color);
         function lcdFillCircle(obj, x, y, radius, color)
         % lcdFillCircle(x, y, radius, color) draws a filled circle at point (x,y)
         %     with the specified color fill.
         %     if color is left empty, the function will use whatever color was last set            
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
            cmdID = 0x4B;
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
            cmdID = 0x4A;
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
%% M5 Real Time Clock Class-------------------------------------------------------------------------------------
        % M5.Rtc.isEnabled();
%% M5 Power Class [20 functions]------------------------------------------------------------------------------------
% M5PowerBegin------------------------------------------------------------------------------------
        % 1. M5.Power.begin(void)
        function powerBegin(obj) %Not really needed since M5.begin calls this
            cmdID = 0x70;
            dataIn = 0x00;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
%-------------------------------------------------------------------------------------
        % 2. M5.Power.setExtOutput(bool enable, ext_port_mask_t port_mask = (ext_port_mask_t)0xFF); /// Set power output of the external ports. 
%-------------------------------------------------------------------------------------
        % 3. M5.Power.getExtOutput(void); /// Get power output of the external ports.
%-------------------------------------------------------------------------------------
        % 4. M5.Power.setUsbOutput(bool enable); /// Set power output of the main USB port.
%-------------------------------------------------------------------------------------
        % 5. M5.Power.getUsbOutput(void);   /// Get power output of the main USB port.
% M5PowerLED------------------------------------------------------------------------------------
        % 6. M5.Power.setLed(uint8_t brightness)
        function powerLED(obj, brightness)
        % powerLED(brightness) sets the intensity of the power LED
        %     brightness = 0(off) to 255(Full Intensity)
            cmdID = 0x73;
            dataIn = uint8(brightness);
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% M5PwrOff------------------------------------------------------------------------------------
        % 7. M5.Power.powerOff(void);
        function powerOff(obj)
        % powerOff turn all M5 power off.
            cmdID = 0x74;
            dataIn = 0x00;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            M5UnifiedDelete(obj);
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
        % 11. int32 = M5.Power.getBatteryLevel(void);
        function battLevel = powerGetBatteryLevel(obj)
        % battLevel = powerGetBatteryLevel returns the current battery level
            cmdID = 0x76;
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
        % battVoltage = powerGetBatteryVoltaget() returns the amount of
        %     voltage in the M5 battery            
            cmdID = 0x7B;
            dataIn = 0x00;
            dataOut = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            battVoltage = typecast(cast(dataOut,'uint8'),'uint16');
        end
% GetBatteryCurrent------------------------------------------------------------------------------------
        % 17.  int32_t = M5.Power.getBatteryCurrent(void);
        function battCurrent = powerGetBatteryCurrent(obj)
        % battCurrent = powerGetBatteryCurrent() returns the amount of current
        %     in the M5 battery
            cmdID = 0x7C;
            dataIn = 0x00;
            dataOut = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            battCurrent = typecast(cast(dataOut,'uint8'),'uint32');
        end
% M5PwrGetKeyState------------------------------------------------------------------------------------
        % 18.  uint8_t = M5.Power.getKeyState(void);
        function keystate = powerGetKeyState(obj)
        % keystate = powerGetKeyState() returns whether the power key was pressed
        %    keystate = 0=none / 1=long pressed / 2=short clicked / 3=both
            cmdID = 0x7D;
            dataIn = 0x00;
            keystate = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% vibrationMotor(obj, level)----------------------------------------------------------------------
        % 19. M5.Power.setVibration(uint8_t level);
        function vibrationMotor(obj, level)
        % vibrationMotor(level) sets the motor to the specified intensity
        %     level = 0 to 255
            cmdID = 0x7E;
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
            % [pwrButton,buttonA,buttonB,buttonC] = buttonUpdate(obj) checks whether
            %     the Power Button, Button A, Button B or Button C were pressed. 
            %     Index for the button whose state you want to check.
                    cmdID = 0xA0;
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
            cmdID = 0xB0;
            dataIn = 0x00;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% SpeakerStop-------------------------------------------------------------------------------------        
        % 2. M5.Speaker.stop();
        function speakerStop(obj)
        % speakerStop() Stops speaker output
            cmdID = 0xB1; 
            dataIn = 0x00; 
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% SpeakerTone-------------------------------------------------------------        
        % 3. M5.Speaker.tone(float frequency, uint32_t duration = UINT32_MAX, 
            % int channel = -1, bool stop_current_sound = true));
        function speakerTone(obj, freq, dur, channel, stop_current_sound)
        % speakerTone(freq, dur, channel, stop_current_sound) plays a tone
        %     freq - Tone frequency (Hz) 0 to 4,294,967,295. Can be a fraction
        %     dur - Tone duration in milliseconds. 0 to 4,294,967,295. Can be a fraction
        %     channel - Virtual channel: 0-7
        %     stop_current_sound - 0(No) or 1(Yes)

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

            cmdID = 0xB2;
            dataIn = toneData;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
% SpeakerSetVolume-------------------------------------------------------------------------------------
        % 4. M5.Speaker.setVolume(int direction, int diff);
            %direction: 1=up or 0=down
            %diff: how much increment/decrement to apply to volume
        function speakerSetVolume(obj, dir, diff)
        % speakerSetVolume(dir, diff) sets the volume of the speaker
        %     dir - 0(reduce) or 1(increase)
        %     diff - 0(None) to 255(Full)

            % Convert arguments to byte arrays
            dirBytes = typecast(int8(dir), 'uint8');
            diffBytes = typecast(int8(diff), 'uint8');
            
            % Concatenate byte arrays
            setVolData = [dirBytes, diffBytes];
        
            cmdID = 0xB3;
            dataIn = setVolData;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
%% M5 Microphone Class
% micBegin-----------------------------------------------------------------------------------
        function micBegin(obj) %Not really needed since M5.begin calls this
            cmdID = 0xC1;
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
    end
end %of M5Unified Class
