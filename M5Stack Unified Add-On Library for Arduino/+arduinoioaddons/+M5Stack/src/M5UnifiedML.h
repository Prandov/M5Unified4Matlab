/**
 * @file M5UnifiedML.h
 *
 * Class definition for M5Stack class that wraps APIs of the M5Unified library
 * https://github.com/m5stack/M5Unified. Based on the example DHT22 add-on library.
 *
 * Version 0.1
 * Initial proof of concept: implemented the M5 Begin and LCD text functions only. 
 * @copyright Copyright 2024 Eric Prandovszky prandov@yorku.ca
 *
 */

#include "LibraryBase.h"
#include "M5Unified.h"

//#define MAX_NUMBER_SENSORS 1

// Command ID's
#define M5Begin                 0x01
#define M5BoardType             0x02

#define M5DisplayBegin          0x20
#define M5LcdClear              0x21
#define M5DisplayPrintHW        0x30
#define M5LcdPrint              0x31
#define M5LcdPrintLn            0x32
#define M5LcdDrawString         0x33
#define M5LcdTextColor          0x34
#define M5LcdTextDatum          0x35
#define M5LcdTextSize           0x36
#define M5LcdTextFont           0x37
#define M5LcdSetCursor          0x38

#define M5DisplayJPG            0x49

// Debug Strings
const char MSG_M5Begin[]            PROGMEM = "M5 Begin\n";
const char MSG_GetBrdType[]         PROGMEM = "M5 GetBoardType\n";
//LCD
const char MSG_M5DisplayBegin[]     PROGMEM = "M5 Display Begin\n";
const char MSG_M5LcdClear[]         PROGMEM = "M5.Display.clear();\n";
const char MSG_M5DisplayPrintHw[]   PROGMEM = "M5 Display: 'Hello World'\n";
const char MSG_M5LcdPrint[]         PROGMEM = "M5 Display: Print\n";
const char MSG_M5LcdPrintLine[]     PROGMEM = "M5 Display: PrintLine\n";
const char MSG_M5LcdDrawString[]    PROGMEM = "M5 Display: Draw String\n";
const char MSG_M5LcdTextColor[]     PROGMEM = "M5 Display: Text Color\n";
const char MSG_M5LcdTextDatum[]     PROGMEM = "M5 Display: Text Datum\n";
const char MSG_M5LcdTextSize[]      PROGMEM = "M5 Display: Text Size\n";
const char MSG_M5LcdTextFont[]      PROGMEM = "M5 Display: Text Font\n";
const char MSG_M5LcdSetCursor[]     PROGMEM = "M5 Display: Set Cursor\n";

const char MSG_M5DisplayJPG[]       PROGMEM = "M5 Display .jpg'\n";

const char MSG_UNKNOWN_CMD[]    PROGMEM = "M5[%d]->Unknown Command\n";
// Debug Strings
// const char MSG_CREATE_DHT22[]            PROGMEM = "DHT22[%d] = new DHT(%d, DHT);\n";
// const char MSG_DELETE_DHT22[]            PROGMEM = "delete DHT22[%d];\n";
// const char MSG_READ_TEMPERATURE_DHT22[]  PROGMEM = "DHT22[%d]->readTemperature() --> %s;\n";
// const char MSG_READ_HUMIDITY_DHT22[]     PROGMEM = "DHT22[%d]->readHumidity() --> %s;\n";
// const char MSG_UNKNOWN_CMD[]             PROGMEM = "DHT22[%d]->Unknown Command\n";

/*
The M5 Unified library provides access to the built-in hardware of M5Stack controllers. The library functionality is available through the m5 namespace and includes the following
    0: Begin
    1: LCD display access, fonts, and graphical primitives: This is done in conjunction with M5GFX.
    2: Touchscreen and hardware button access: This allows you to interact with the device’s touchscreen and hardware buttons.
    3: Speaker and microphone access: This gives you control over the device’s speaker and microphone.
    4: Power and battery charging control: This lets you manage the device’s power and battery charging.
    5: Accelerometer, gyroscope, magnetometer access: This provides access to the device’s accelerometer, gyroscope, and magnetometer.
*/
/* 0: Begin
auto cfg = M5.config(); // Assign a structure for initializing M5Stack 
  cfg.serial_baudrate = 115200 // default=115200 uint32_t	USB serial baud rate Arduino-esp32 only
  cfg.clear_display = true;  // default=true. clear the screen when begin.
  cfg.output_power  = true;  // default=true. use external port 5V output.
  cfg.internal_imu  = true;  // default=true. use internal IMU.
  cfg.internal_rtc  = true;  // default=true. use internal RTC.
  cfg.internal_spk  = true;  // default=true. use internal speaker.
  cfg.internal_mic  = true;  // default=true. use internal microphone.
  cfg.external_imu  = false;  // default=false. use Unit Accel & Gyro.
  cfg.external_rtc  = false;  // default=false. use Unit RTC.
  cfg.led_brightness = 64;   // default= 0. system LED brightness (0=off / 255=max) (※ not NeoPixel)

   M5.begin(cfg);                        // initialize M5 device

*/

// Saves floating point number and byte array in same memory location
typedef union{
    float number;
    byte bytes[4];
}VALUE;

class M5UnifiedML : public LibraryBase
{
    public:
    // Constructor
        M5UnifiedML(MWArduinoClass& a)
    {
        // Define the library name
        //libName = "Adafruit/DHT22";
        libName = "M5Stack/M5Unified";
        // Register the library to the server
        a.registerLibrary(this);
    }
    
public:
    void commandHandler(byte cmdID, byte* dataIn, unsigned int payload_size)
    {
        switch (cmdID){
            // case M5Begin    0x01
            case M5Begin:{
                // M5 = new M5Unified();
                // M5->begin();
                 // begin M5Unified.
                M5.begin();
                // Print debug string and pin
                debugPrint(MSG_M5Begin);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }            
            // case getBoardType 0x02
            case M5BoardType: {
                // Get the board type
                uint8_t boardType = M5.getBoard();
                byte* response = reinterpret_cast<byte*>(&boardType);
                //uint16_t respLen = sizeof(boardType);
                // Print debug string
                debugPrint(MSG_GetBrdType);
                // Send response
                // sendResponseMsg(byte commandID, byte* dataOut, unsigned int payloadSize)
                sendResponseMsg(cmdID, response, 1);
                break;
            }
            // case M5DisplayBegin    0x20
            case M5DisplayBegin: {
                M5.Display.begin();
                // Print debug string and pin
                debugPrint(MSG_M5DisplayBegin);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
             // case M5LcdClear 0x21
            case M5LcdClear: {
                M5.Display.clear();
                // Print debug string
                debugPrint(MSG_M5LcdClear);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5DisplayPrintHW 0x30
            case M5DisplayPrintHW: {
                 M5.Display.setTextColor(TFT_WHITE,TFT_BLACK);	display.setTextSize(1);
                 M5.Display.println("Hello World!");
                // Print debug string and pin
                debugPrint(MSG_M5DisplayPrintHw);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
             // case M5LcdPrint 0x31
            case M5LcdPrint: {
                //char* text = reinterpret_cast<char*>(dataIn);
                // Convert the dataIn byte array to a string
                char* text = reinterpret_cast<char*>(dataIn); // \r\n
                text[payload_size] = '\0'; // Append a null character to text
                //M5.Display.setTextColor(TFT_WHITE,TFT_BLACK);	
                //M5.Display.setTextSize(1);
                 M5.Display.print(text);
                // Print debug string
                debugPrint(MSG_M5LcdPrint);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5LcdPrintLine 0x32
            case M5LcdPrintLn: {
                // Extract the text from dataIn
                char* text = reinterpret_cast<char*>(dataIn);
                text[payload_size] = '\0'; // Append a null character to text
                // Print the text
                M5.Display.println(text);
                // Print debug string
                debugPrint(MSG_M5LcdPrintLine);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            //case M5LcdDrawString 0x33
            case M5LcdDrawString: {
                // We will use drawString(char,  x,  y ) and not worry abut any overloads for now        
                // Extract the x, y, and text from dataIn
                uint16_t x = (dataIn[0] << 8) | dataIn[1];
                uint16_t y = (dataIn[2] << 8) | dataIn[3];
                char* text = reinterpret_cast<char*>(dataIn + 4);
                // Draw the string
                M5.Display.drawString(text, x, y);
                // Print debug string
                debugPrint(MSG_M5LcdDrawString);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5LcdTextColor 0x34 (overload else if to include background color) 
            case M5LcdTextColor: {
                // Extract the text color from dataIn
                uint16_t textColor = (dataIn[0] << 8) | dataIn[1];
                // Check the length of dataIn
                if (payload_size == 2) {
                    // Set the text color
                    M5.Display.setTextColor(textColor);
                } else if (payload_size == 4 ) {
                    // Extract the background color from dataIn
                    uint16_t bgColor = (dataIn[2] << 8) | dataIn[3];
                    // Set the text color and background color
                    M5.Display.setTextColor(textColor, bgColor); //(overload)
                }
                    // Print debug string
                    debugPrint(MSG_M5LcdTextColor);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5LcdTextDatum 0x35
                case M5LcdTextDatum: {
                    // Extract the text datum from dataIn
                    uint16_t datum = (dataIn[0] << 8) | dataIn[1];
                    // Set the text datum
                    M5.Display.setTextDatum(datum);
                    // Print debug string
                    debugPrint(MSG_M5LcdTextDatum);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5LcdTextSize 0x36
                case M5LcdTextSize: {
                    // Extract the text size from dataIn
                    //uint16_t size = (dataIn[0] << 8) | dataIn[1];
                    uint16_t size = dataIn[0];
                    // Set the text size
                    M5.Display.setTextSize(size); //setTextSize is a float
                    // Print debug string
                    debugPrint(MSG_M5LcdTextSize);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5LcdTextFont 0x37
                //   Font Types: 0.ft_unknown   1.ft_glcd     2.ft_bmp    3. ft_rle    4. ft_gfx    5. ft_bdf    6. ft_vlw    7. ft_u8g2    8. ft_ttf
                case M5LcdTextFont: {
                    // Extract the text font from dataIn
                    //uint16_t font = (dataIn[0] << 8) | dataIn[1];
                    //uint16_t font = reinterpret_cast<uint16_t>(dataIn);
                    uint16_t font = dataIn[0];
                    // Set the text font
                    M5.Display.setTextFont(font);
                    // Print debug string
                    debugPrint(MSG_M5LcdTextFont);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }        
                // case M5LcdSetCursor 0x38
                case M5LcdSetCursor: {
                    // Extract the x and y from dataIn
                    uint16_t x = (dataIn[0] << 8) | dataIn[1];
                    uint16_t y = (dataIn[2] << 8) | dataIn[3];
                    // Set the cursor
                    M5.Display.setCursor(x, y);
                    // Print debug string
                    debugPrint(MSG_M5LcdSetCursor);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
            // case M5DisplayJPG 0x49
            case M5DisplayJPG: {
             // display.drawJpg(jpg_image, ~0u, 0, 0, display.width(), display.height(), 0, 0, 0.0f, -1.0f);
             // drawJpg(const uint8_t *jpg_data, size_t jpg_len, uint16_t x = 0, uint16_t y = 0, uint16_t maxWidth = 0, uint16_t maxHeight = 0, uint16_t offX = 0, uint16_t offY = 0, jpeg_div_t scale = JPEG_DIV_NONE);
                uint16_t x = 0;
                uint16_t y = 0;
                uint16_t maxWidth = 0; 
                uint16_t maxHeight = 0; 
                uint16_t offX = 0;
                uint16_t offY = 0;
                jpeg_div_t scale = M5.Display.JPEG_DIV_NONE;
                jpgData = dataIn;
                jpgLength = jpgData.sizeof();
                M5.Display.drawJpg(dataIn, jpgLength, x, y,maxWidth, maxHeight, offX, offY, scale);
                // Print debug string
                debugPrint(MSG_M5DisplayJPG);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }

            // case CREATE_DHT22: {
            //     // Get sensor ID from dataIn
            //     byte sensorID = dataIn[0];
            //     // Get pin from dataIn
            //     byte pin = dataIn[1];
            //     // Create new DHT22 sensor at pin
            //     sensors[sensorID] = new DHT(pin, DHT22);
            //     // Initialize DHT22
            //     sensors[sensorID]->begin();
            //     // Print debug string and pin
            //     debugPrint(MSG_CREATE_DHT22, sensorID, pin);
            //     // Send response
            //     sendResponseMsg(cmdID, 0, 0);
            //     break;
            // }

            // case DELETE_DHT22: {
            //     // Get sensor ID from dataIn
            //     byte sensorID = dataIn[0];
            //     // Make NULL
            //     sensors[sensorID] = NULL;
            //     // Print debug string
            //     debugPrint(MSG_DELETE_DHT22, sensorID);
            //     // Send response
            //     sendResponseMsg(cmdID, 0, 0);
            //     break;
            // }
            
            // case READ_TEMPERATURE_DHT22: {
            //     // Get sensor ID from dataIn
            //     byte sensorID = dataIn[0];
            //     VALUE value;
            //     // Call readtemperature() method from Adafruit Libary
            //     value.number = sensors[sensorID]->readTemperature();
            //     // Convert float to string for debugPrint
            //     String buffer;
            //     buffer = String(value.number);
            //     // Print debug string and temperature
            //     debugPrint(MSG_READ_TEMPERATURE_DHT22, sensorID, buffer.c_str());
            //     // Send response
            //     sendResponseMsg(cmdID, value.bytes, 4);
            //     break;
            // }
            
            // case READ_HUMIDITY_DHT22: {
            //     // Get sensor ID from dataIn
            //     byte sensorID = dataIn[0];
            //     VALUE value;
            //     // Call readtemperature() method from Adafruit Libary
            //     value.number = sensors[sensorID]->readHumidity();
            //     // Convert float to String for debugPrint
            //     String buffer;
            //     buffer = String(value.number);
            //     // Print debug string and humidity
            //     debugPrint(MSG_READ_HUMIDITY_DHT22, sensorID, buffer.c_str());
            //     // Send response
            //     sendResponseMsg(cmdID, value.bytes, 4);
            //     break;
            // }
            
            default: {
                // Print debug string
                debugPrint(MSG_UNKNOWN_CMD);
                break;
            }
        }
    }
};