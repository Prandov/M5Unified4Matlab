% M5Stack custom Arduino Add-On
% This .m file helps your MATLAB code interact with the c++ header file uploaded to the arduino.
%% Create MATLAB Wrapper
%The MATLAB add-on wrapper class that defines your library must inherit from matlabshared.addon.LibraryBase. 
% The "matlabshared.addon.LibraryBase" class defines several constant properties that you must override in your MATLAB class. 
% The class also contains internal utility functions that enable you to send and retrieve data from the server running on the Arduino board.
% You can access the library files from 'CreateFolderStructureExample/SDKExampleHelloWorld' folder downloaded in Create Folder Structure.
%Create a MATLAB class, and define the command ID for each command that is sent to the server on the board.
classdef M5Unified <  matlabshared.addon.LibraryBase & matlab.mixin.CustomDisplay
    % Create an DHT22 addon device object, which is connected to a specified pin on the Arduino hardware
    % sensor = addon(a,'Adafruit/DHT22', pin) creates a DHT22 device object.
    % Copyright 2019 The MathWorks, Inc.
    properties(Access = private, Constant = true)
        %CREATE_DHT22              = hex2dec('01')
        %DELETE_DHT22              = hex2dec('02')
        %READ_TEMPERATURE_DHT22    = hex2dec('03')
        %READ_HUMIDITY_DHT22       = hex2dec('04')
        M5Begin                   = hex2dec('01')
        M5LcdBegin            = hex2dec('02')
        M5LcdPrt              = hex2dec('21') 
        M5LcdPrtLn            = hex2dec('22') 

    end
    %Override constant properties in the class to specify the location of source header files.   
    %The support package auto-detects the class only if you have redefined all the properties. If you do not need a value, leave the field empty.
    properties(Access = protected, Constant = true)
        %LibraryName = 'Adafruit/DHT22'
        %DependentLibraries = {}
        %LibraryHeaderFiles = {'DHT/DHT.h'} % !Possibly 'DHT_sensor_library/DHT.h'
        %CppHeaderFile = fullfile(arduinoio.FilePath(mfilename('fullpath')), 'src', 'DHT22ML.h')
        %CppClassName = 'DHT22ML'
        LibraryName = 'M5Stack/M5Unified' %Your library name
        DependentLibraries = {}
        LibraryHeaderFiles = {'M5Unified/src/M5Unified.h'}
        CppHeaderFile = fullfile(arduinoio.FilePath(mfilename('fullpath')), 'src', 'M5UnifiedML.h')
        CppClassName = 'M5UnifiedML'
    end
    
    properties(Access = private)
        %SensorID;
        %ResourceOwner = 'Adafruit/DHT22';
        ResourceOwner = 'M5Stack/M5Unified';
    end
    
    properties(SetAccess = private)
        %Pin
    end
    % Define the class constructor, set the methods to call the class constructor, and set the parent property.
    % Constructor Method
    methods(Hidden, Access = public)
            %function obj = DHT22(parentObj, arduinoPin)
            function obj = M5Unified(parentObj)
                %Always assign the first input argument to obj.Parent.
                obj.Parent = parentObj;
            
            %DHT22 Connect to a DHT22 temperature and humidity sensor
            %   sensor = addon(a,'Adafruit/DHT22', arduinoPin)	Creates a
            %   connection to the DHT22 sensor where a is the Arduino
            %   object, 'Adafruit/DHT22' is the library, and arduinoPin is
            %   the pin on the Arduino the sensor is connected to.
            %
            %   Example:
            %       a = arduino('COM7','Uno','libraries','Adafruit/DHT22');
            %       sensor = addon(a,'Adafruit/DHT22', 'D2')
            %
            %   See also ARDUINO, ADDON, READTEMPERATURE, READHUMIDITY
            

            %try
            %    createM5(obj);

            %     %Get new ID for DHT22 sensor. Validate it.
            %     obj.SensorID = getResourceCount(obj.Parent, 'DHT22');
            %     if obj.SensorID >= obj.MAX_NUMBER_SENSORS
            %         error('Adafruit:DHT22:ValueError', 'Maximum supported number of DHT22 sensors (= %d) has been reached.', obj.MAX_NUMBER_SENSORS);
            %     end
            % 
            %     % Validate Uniqueness of Pin Resource
            %     terminal = getTerminalsFromPins(obj.Parent, arduinoPin);
            %     owner = getResourceOwner(obj.Parent, terminal);
            %     if ~isempty(owner)
            %         error('Adafruit:DHT22:DuplicatePin', 'Arduino pin %s is registered with %s object. Sharing of pin is not supported.', arduinoPin, owner);
            %     end
            % 
            %     % Initialize Property: Arduino Pin
            %     if ischar(arduinoPin) || isstring(arduinoPin)
            %         obj.Pin = char(arduinoPin);
            %     else
            %         error('Adafruit:DHT22:InvalidPin', 'arduinoPin argument expects a char or string but received %s.', class(arduinoPin));
            %     end
            % 
            %     % Setup the pin for use
            %     configurePinResource(obj.Parent, obj.Pin, obj.ResourceOwner, 'DigitalInput');
            %     % Increment current resource count
            %     incrementResourceCount(obj.Parent, 'DHT22');
            %     % Create DHT22
            %     createDHT22(obj);
                  % Create DHT22

            %catch e
               % throwAsCaller(e);
            %end
        end
    end
    
    % Destructor Method
    % methods(Access = protected)
    %     function delete(obj)
    %         try
    %             parentObj = obj.Parent;
    %             % configurePinResource(parentObj, obj.Pin, obj.ResourceOwner, 'Unset')
    %             % decrementResourceCount(obj.Parent, 'DHT22');
    %             % deleteDHT22(obj);
    %             deleteM5(obj)
    %         catch
    %             % Do not throw any errors
    %         end
    %     end
    % end
    
    methods(Access = public)
        % % Create DHT22 Sensor
        % function createDHT22(obj)
        %     cmdID = obj.CREATE_DHT22;
        %     terminal = getTerminalsFromPins(obj.Parent, obj.Pin);
        %     data = [obj.SensorID; terminal];
        %     sendCommand(obj, obj.LibraryName, cmdID, data);
        % end

    %% M5Unified core functions
        % M5.begin     /// Perform initialization process at startup.
        % M5.update 
        % M5.getBoard
        % M5.getUpdateMsec
        % M5.config
        % M5.getPin


        % Initialize the Hardware described in the M5 Unified Library 
        function begin(obj)
            cmdID = obj.M5Begin; %0x01
            % [dataOut, payloadSize] = sendCommand(obj, libName, commandID, dataIn, timeout)
            dataIn = 0x00;
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
        % Get the board type of the runtime environment. @return board type
        function getBoardType(obj)         %M5.getBoard()
            cmdID = 0x02;             
            dataIn = 0x00;
            [dataOut, payloadSize] = sendCommand(obj, obj.LibraryName, cmdID, dataIn);
            disp(payloadSize)
            sprintf('The board type is %d',dataOut);
        end        
        
        %% M5 Unified Instantiates the following objects
            % M5GFX Display;  // setPrimary
            % M5GFX &Lcd = Display; //Creates a pointer for LCD to Display
         
            % IMU_Class Imu;
            % Log_Class Log;
            % Power_Class Power;
            % RTC8563_Class Rtc;
            % Touch_Class Touch;

            % Button_Class BtnA;
            % Button_Class BtnB;
            % Button_Class BtnC;
            % Button_Class BtnEXT;  // CoreInk top button
            % Button_Class BtnPWR;  // CoreInk power button / AXP192 power button
            
            % I2C_Class& In_I2C = m5::In_I2C; //for internal I2C device
            % I2C_Class& Ex_I2C = m5::Ex_I2C; //for external I2C device (Port.A)

            % Speaker_Class Speaker;
            % Mic_Class Mic;
        
        
%% Power_Class   [22 functions]
    %           M5.Power.begin(void)
    %           M5.Power.deepSleep(std::uint64_t micro_seconds = 0, bool touch_wakeup = true);
    %           M5.Power.getExtOutput(void); /// Get power output of the external ports.
    % int32_t   M5.Power.getBatteryCurrent(void);
    % int32 =   M5.Power.getBatteryLevel(void);
    % int16_t   M5.Power.getBatteryVoltage(void);
    % uint8_t   M5.Power.getKeyState(void);
    % pmic_t    M5.Power.getType(void) const { return _pmic; }
    %           M5.Power.getUsbOutput(void);   /// Get power output of the main USB port.
    %           M5.Power.powerOff(void);        /// all power off.
    % is_charging_t M5.Power.isCharging(void);
    %           M5.Power.lightSleep(std::uint64_t micro_seconds = 0, bool touch_wakeup = true);
    %           M5.Power.setBatteryCharge(bool enable);
    %           M5.Power.setChargeCurrent(std::uint16_t max_mA);
    %           M5.Power.setChargeVoltage(std::uint16_t max_mV);
    %           M5.Power.setExtOutput(bool enable, ext_port_mask_t port_mask = (ext_port_mask_t)0xFF); /// Set power output of the external ports. 
    %           M5.Power.setLed(uint8_t brightness = 255); /// Turn on/off the power LED.
    %           M5.Power.setUsbOutput(bool enable); /// Set power output of the main USB port.
    %           M5.Power.setVibration(uint8_t level);
    %           M5.Power.timerSleep(int seconds);
    %           M5.Power.timerSleep(const rtc_time_t& time);
    %           M5.Power.timerSleep(const rtc_date_t& date, const rtc_time_t& time);

%% Real Time Clock
        % M5.Rtc.isEnabled();

%% LCD Display
         % !M5.LCD is a reference to M5.Display which is an M5GFX object inhereted from LGFX
         
         % M5.Display.begin();
         % M5.Display.clear();
         % M5.Display.width()
         % M5.Display.height()
         % M5.getDisplayCount()
         % M5.Display.getRotation()
         % M5.Display.display();
         % M5.Display.setBrightness(brightness)
         % M5.Display.setColorDepth(24);
         % M5.Display.setColorDepth(16); 
         % M5.Display.setRotation     
         % M5.Display.startWrite(); // using startWrite and endWrite before and after the drawing process suppresses bus allocation
         % M5.Display.endWrite();       


         % M5.Display.begin();
        function lcdBegin(obj) %NOT NEEDED
            cmdID = 0x20; 
            dataIn = 0x00; 
            sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
        %M5.Display.clear();
        function lcdClear(obj)
        cmdID = 0x21; 
        dataIn = 0x00; 
        sendCommand(obj, obj.LibraryName, cmdID, dataIn);
        end
         %% LCD Text functions

         % M5.Display.print("Hello, M5Stack!")
         % M5.Display.println(str);
         % M5.Display.println("Hello World!");
         % M5.Display.drawString(x, y, text, color, size)??
         % M5.Display.printf("Raw X:%03d  Y:%03d", tp[i].x, tp[i].y);
         % M5.Display.setTextColor(TFT_WHITE,TFT_BLACK);
         % M5.Display.setTextColor(TFT_BLACK);
         % M5.Display.setTextDatum(textdatum_t::bottom_center);	
         % M5.Display.setTextSize(1);
         % M5.Display.setFont(&fonts::Font0);
         % M5.Display.setFont(&fonts::Font2);
         % M5.Display.setCursor(16, 16 + i * 24);  
         % M5.Display.setCursor(0,0);
        function lcdPrint(obj, string)
            cmdID = 0x31; 
            sendCommand(obj,obj.LibraryName,cmdID,uint8(string)); 
        end
        function lcdPrintLn(obj,string)
            cmdID = 0x32; 
            sendCommand(obj,obj.LibraryName,cmdID,uint8(string)); 
        end
        function lcdDrawStr(obj,string) % M5.Display.drawString(x, y, text, color, size)

        % MATLAB AI:
        % Encode multiple values into a byte array
        x = 10;
        y = 20;
        text = 'Hello';
        color = [255, 0, 0];
        size = 12;
        
        % Convert values to byte arrays
        xBytes = typecast(int32(x), 'uint8');
        yBytes = typecast(int32(y), 'uint8');
        textBytes = uint8(text);
        colorBytes = uint8(color);
        sizeBytes = typecast(int32(size), 'uint8');
        
        % Concatenate byte arrays
        byteArray = [xBytes; yBytes; textBytes(:); colorBytes(:); sizeBytes];
        
        %%%
        
        % Decode the byte array to retrieve the individual values
        x = typecast(byteArray(1:4), 'int32');
        y = typecast(byteArray(5:8), 'int32');
        textLength = byteArray(9);
        text = char(byteArray(10:10+textLength-1)');
        color = reshape(typecast(byteArray(10+textLength:18+textLength), 'uint8'), 3, []);
        size = typecast(byteArray(19+textLength:22+textLength), 'int32');

%%%
            cmdID = 0x33;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(string)); 
        end
	
        function lcdTextColor(obj,varargin)
    % M5.Display.setTextColor(TFT_BLACK);
    % 0. TFT_BLACK       = 0x0000;      /*   0,   0,   0 */
    % 1. TFT_NAVY        = 0x000F;      /*   0,   0, 128 */
    % 2. TFT_DARKGREEN   = 0x03E0;      /*   0, 128,   0 */
    % 3. TFT_DARKCYAN    = 0x03EF;      /*   0, 128, 128 */
    % 4. TFT_MAROON      = 0x7800;      /* 128,   0,   0 */
    % 5. TFT_PURPLE      = 0x780F;      /* 128,   0, 128 */
    % 6. TFT_OLIVE       = 0x7BE0;      /* 128, 128,   0 */
    % 7. TFT_LIGHTGREY   = 0xD69A;      /* 211, 211, 211 */
    % 8. TFT_LIGHTGRAY   = 0xD69A;      /* 211, 211, 211 */
    % 9. TFT_DARKGREY    = 0x7BEF;      /* 128, 128, 128 */
    % 10.TFT_DARKGRAY    = 0x7BEF;      /* 128, 128, 128 */
    % 11.TFT_BLUE        = 0x001F;      /*   0,   0, 255 */
    % 12.TFT_GREEN       = 0x07E0;      /*   0, 255,   0 */
    % 13.TFT_CYAN        = 0x07FF;      /*   0, 255, 255 */
    % 14.TFT_RED         = 0xF800;      /* 255,   0,   0 */
    % 15.TFT_MAGENTA     = 0xF81F;      /* 255,   0, 255 */
    % 16.TFT_YELLOW      = 0xFFE0;      /* 255, 255,   0 */
    % 17.TFT_WHITE       = 0xFFFF;      /* 255, 255, 255 */
    % 18.TFT_ORANGE      = 0xFDA0;      /* 255, 180,   0 */
    % 19.TFT_GREENYELLOW = 0xB7E0;      /* 180, 255,   0 */
    % 20.TFT_PINK        = 0xFE19;      /* 255, 192, 203 */ //Lighter pink, was 0xFC9F
    % 21.TFT_BROWN       = 0x9A60;      /* 150,  75,   0 */
    % 22.TFT_GOLD        = 0xFEA0;      /* 255, 215,   0 */
    % 23.TFT_SILVER      = 0xC618;      /* 192, 192, 192 */
    % 24.TFT_SKYBLUE     = 0x867D;      /* 135, 206, 235 */
    % 25.TFT_VIOLET      = 0x915C;      /* 180,  46, 226 */
    % 26.TFT_TRANSPARENT = 0x0120;
            fColor = uint16(varargin{1});
            if nargin == 2 %Only Text Color
                fbColor = typecast(swapbytes(fColor),'uint8');
            elseif nargin == 3 % Text and Background Color
                bColor = uint16(varargin{2});
                fbColor = typecast(swapbytes([fColor,bColor]),'uint8');
            else
                % Code to execute when there are more than two input arguments
                disp('Invalid number of arguments');
            end
            cmdID = 0x34;
            sendCommand(obj,obj.LibraryName,cmdID,fbColor); 
        end

        % M5.Display.setTextDatum(textdatum_t::bottom_center);
        function lcdTextDatum(obj, datum)
            % 0:Top left (default) 1:Top Centre     2:Top Right
            % 4:Middle Left        
            % 8:Bottom Left    
            % 16:Baseline Left
            cmdID = 0x35;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(datum)); 
        end
        % M5.Display.setTextSize(1);
        function lcdTextSize(obj, size)
            cmdID = 0x36;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(size)); 
        end
        % M5.Display.setFont(&fonts::Font0);
        function lcdFont(obj, font)
            cmdID = 0x37;
            sendCommand(obj,obj.LibraryName,cmdID,uint8(font)); 
        end
        % M5.Display.setCursor(0,0);
        function lcdCursor(obj, xPos, yPos)
            xyPos = [uint16(xPos), uint16(yPos)];
            xyData = typecast(swapbytes(xyPos),'uint8');
            cmdID = 0x38;
            sendCommand(obj,obj.LibraryName,cmdID,xyData); 
        end

         %% LCD Shapes [17]
         % M5.Display.drawLine(x1, y1, x2, y2, color);
         % M5.Display.drawFastHLine(x + w/2, y + 19 + (i+1) * plot_height / 12, w*(3+(0==(i%5)))/16, TFT_BLACK);
         % M5.Display.drawFastVLine(x, 0, h, color2);
         % M5.Display.drawCircle(x0, y0, r, color)        
         % M5.Display.drawRect(x, y, width, height, color)
         % M5.Display.drawRect(1, 1, display.width()-2 , meter_height-2, TFT_BLACK);    
         % M5.Display.drawRoundRect(x0, y0, w, h, radius, color)
         % M5.Display.drawString(x, y, text, color, size)
         % M5.Display.drawTriangle(cx, cy - i, cx - i, cy + i, cx + i, cy + i,
         % M5.Display.fillArc(needle_x, needle_y, r1, r1, 225, 315, TFT_BLACK);
         % M5.Display.fillCircle(x, y, radius, color);
         % M5.Display.fillEllipseArc(display.width()>>1, display.height()>>1, 640, 480, 360, 270, i, i + 1, display.color888(255-(i*256/360), i*256/360, 255));
         % M5.Display.fillRect(0, 0, display.width()   , meter_height  , TFT_WHITE);   
         % M5.Display.fillRoundRect(cx-i2, cy-i2, i, i, i/8, display.color565(0, i, 0));
         % M5.Display.fillRoundRect(x0, y0, w, h, radius, color)
         % M5.Display.fillScreen(TFT_WHITE);
         % M5.Display.fillTriangle(cx, cy - i, cx - i, cy + i, cx + i, cy + i, display.color565(0, i, i));
         % M5.Display.writeFillRectPreclipped((x<<2)+xpos,ypos,1,1,TFT_BLACK);  
         %% LCD Images []
         % M5.Display.drawJpg(jpg_image, ~0u, 0, 0, display.width(), display.height(), 0, 0, 0.0f, -1.0f);
         % M5.Display.drawJpg(const uint8_t *jpg_data, size_t jpg_len, uint16_t x = 0, uint16_t y = 0, uint16_t maxWidth = 0, uint16_t maxHeight = 0, uint16_t offX = 0, uint16_t offY = 0, jpeg_div_t scale = JPEG_DIV_NONE);
         % M5.Display.drawPng(png_logo, ~0u, 0, 0, display.width(), display.height()*2/3, 0, 0, 1.0f, 0.0f, datum_t::middle_center);
         % M5.Display.drawJpg(data_pointer, data_length, 0, 0);
         % M5.Display.drawBmp(data_pointer, data_length, 0, 0);
         % M5.Display.drawPng(data_pointer, data_length, 0, 0);
         % M5.Display.drawJpgFile(SPIFFS, "/filename.jpg", 0, 0);
         % M5.Display.drawBmpFile(SPIFFS, "/filename.bmp", 0, 0);
         % M5.Display.drawPngFile(SPIFFS, "/filename.png", 0, 0);
         % M5.Display.drawJpgUrl("http://example.com/url.jpg", 0, 0);
         % M5.Display.drawBmpUrl("http://example.com/url.bmp", 0, 0);
         % M5.Display.drawPngUrl("http://example.com/url.png", 0, 0);


        
        function getDisplayCount(obj)
            cmdID = obj.M5getDisplayCount;
            % [dataOut, payloadSize] = sendCommand(obj, libName, commandID, dataIn, timeout)
            dataIn = 0x00;
            [numDisplays, payloadSize] = sendCommand(obj,obj.LibraryName,cmdID,dataIn);
        end  
        
     

        function displayJPG(obj) %NOT WORKING
            % display.drawJpg(jpg_image, ~0u, 0, 0, display.width(), display.height(), 0, 0, 0.0f, -1.0f);
            % drawJpg(const uint8_t *jpg_data, size_t jpg_len, uint16_t x = 0, uint16_t y = 0, uint16_t maxWidth = 0, uint16_t maxHeight = 0, uint16_t offX = 0, uint16_t offY = 0, jpeg_div_t scale = JPEG_DIV_NONE);
            cmdID = obj.M5DisplayJPG;
            imData = uint8(fileread('yorku-logo.jpg'));
            sendCommand(obj,obj.LibraryName,cmdID,imData);

            % % from chat
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


        % % Delete Sensor
        % function deleteDHT22(obj)
        %     cmdID = obj.DELETE_DHT22;
        %     sendCommand(obj, obj.LibraryName, cmdID, obj.sensorID);
        % end

        % Delete Sensor
        % function deleteM5(obj)
        %     cmdID = obj.DELETE_DHT22;
        %     sendCommand(obj, obj.LibraryName, cmdID, obj.sensorID);
        % end
    end
    
    % methods(Access = public)
    %     function val = readTemperature(obj)
    %         %READTEMPERATURE Measure temperature
    %         %   temperature = readTemperature(sensor) Get the temperature
    %         %   reading in degrees Celsius from the sensor
    %         %
    %         %   Example:
    %         %       a = arduino('COM7','Uno','libraries','Adafruit/DHT22');
    %         %       sensor = addon(a,'Adafruit/DHT22', 'D2');
    %         %       temperature = readTemperature(sensor);
    %         %
    %         %   See also ARDUINO, ADDON, READHUMIDITY
    % 
    %         cmdID = obj.READ_TEMPERATURE_DHT22;
    % 
    %         try
    %             % Send readTemperature cmdId and get temperature back
    %             val = sendCommand(obj, obj.LibraryName, cmdID, obj.SensorID);
    %             % Convert bytes to double
    %             val = double(typecast(uint8(val), 'single'));
    %         catch e
    %             throwAsCaller(e);
    %         end
    %     end
    % 
    %     function val = readHumidity(obj)
    %         %READHUMIDITY Measure humidity
    %         %   humidity = readHumidity(sensor) Get the humidity
    %         %   reading as a percentage from the sensor
    %         %
    %         %   Example:
    %         %       a = arduino('COM7','Uno','libraries','Adafruit/DHT22');
    %         %       sensor = addon(a,'Adafruit/DHT22', 'D2');
    %         %       humidity = readHumidity(sensor);
    %         %
    %         %   See also ARDUINO, ADDON, READTEMPERATURE
    % 
    %         cmdID = obj.READ_HUMIDITY_DHT22;
    % 
    %         try
    %             % Send readHumidity cmdId and get humidity back
    %             val = sendCommand(obj, obj.LibraryName, cmdID, obj.SensorID);
    %             % Convert bytes to double
    %             val = double(typecast(uint8(val), 'single'));
    %         catch e
    %             throwAsCaller(e);
    %         end
    %     end
    % end
    % 
    % methods (Access = protected)
    %     function displayScalarObject(obj)
    %         % Format for printing DHT22 Object.
    % 
    %         header = getHeader(obj);
    %         disp(header);
    % 
    %         % Display main options
    %         fprintf('          Pin: %s\n', obj.Pin   );
    %         fprintf('\n');
    % 
    %         % Allow for the possibility of a footer.
    %         footer = getFooter(obj);
    %         if ~isempty(footer)
    %             disp(footer);
    %         end
    %     end
    % end
end