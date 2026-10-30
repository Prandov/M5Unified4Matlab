/**
 * @file M5UnifiedML.h
 *
 * Class definition for M5Stack class that wraps APIs of the M5Unified library.
 * https://github.com/m5stack/M5Unified. Based on the example DHT22 add-on library.
 * Banner Comments created: https://patorjk.com/software/taag BigMoney, Bright, Contrast
 * @copyright 2024, Eric Prandovszky prandov@yorku.ca, Greatlove Bariboloka greatlebari@gmail.com
 * Contact: prandov@yorku.ca, greatlebari@gmail.com
 * Version: 0.4.9.2
 * Date: Oct 30, 2026
 * This .h file interacts with the M5Unified.m class in MATLAB.
 */

/*
The M5 Unified library provides access to the built-in hardware of M5Stack controllers. The library functionality 
is available through the m5 namespace and includes the following:
    0: Base: Commands for congiguration and info on the connected M5Stack: Board Type, Memory.
    1: LCD: Controls the LCD configuration, text, and graphical primitives: This is done in conjunction with M5GFX.
    2: IMU: Access to the device’s inertial measurement unit: accelerometer, gyroscope, and magnetometer if present.
    3: Log: Logging features built into the M5Unified Library. 
    4: Power: This lets you manage the device’s power and battery charging.
    5: RTC: Connect to and control the M5Stack's Real Time Clock.
    6: Touchscreen and Button: Aallows you to interact with the device’s touchscreen and hardware or software buttons.
    7: Speaker and Microphone: Access the device’s speaker and microphone.
*/
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#include "LibraryBase.h"
#include "M5Unified.h"
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  ..####...##...##..#####...........######..#####.....##.....####..
//  .##..##..###.###..##..##............##....##..##....##....##.....
//  .##......##.#.##..##..##............##....##..##.....#.....####..
//  .##..##..##...##..##..##............##....##..##..............##.
//  ..####...##...##..#####...........######..#####............####..
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Main Commands 0x00 to 0x1f
#define M5Begin             0x01
#define M5BoardType         0x02
#define getMemoryStatus     0x03

// LCD Display Commands 0x20 to 0x4F
//LCD Display [14]
#define M5LcdBegin              0x20    //1
#define M5LcdStartWrite         0x21    //2
#define M5LcdEndWrite           0x22    //3
#define M5LcdClear              0x23    //4
#define M5LcdDisplay            0x24    //5
#define M5LcdgetHeight          0x25    //6
#define M5LcdgetWidth           0x26    //7
#define M5LcdgetDispCount       0x27    //8
#define M5LcdgetRotation        0x28    //9
#define M5LcdsetRotation        0x29    //10
#define M5LcdsetBrightness      0x2A    //11
#define M5LcdsetColorDepth      0x2B    //12
#define M5LcdAllocateMem        0x2C    //13
#define M5LcdFreeMem            0x2D    //14
//LCD Text [8]
#define M5LcdPrint              0x2E    //1
#define M5LcdPrintLn            0x2F    //2
#define M5LcdDrawString         0x30    //3
#define M5LcdTextColor          0x31    //4
#define M5LcdTextDatum          0x32    //5
#define M5LcdTextSize           0x33    //6
#define M5LcdTextFont           0x34    //7
#define M5LcdSetCursor          0x35    //8
//LCD Shapes [25+]
#define M5LcdDrawPixel          0x36    //1
#define M5LcdDrawLine           0x37    //2
#define M5LcdDrawFastVLine      0x38    //3
#define M5LcdDrawFastHLine      0x39    //4
#define M5LcdDrawRectFOR        0x3A    
//#define M5LcdFillRect         0X3A    //5
//#define M5LcdDrawRect         0X3A    //6
//#define M5LcdDrawRoundRect    0X3B    //7
//#define M5LcdFillRoundRect    0X3B    //8
#define M5LcdDrawCircleFO       0x3C
//#define M5LcdDrawCircle               //9
//#define M5LcdFillCircle               //10
#define M5LcdDrawEllipseFO      0x3D  
//#define M5LcdDrawEllipse              //11
//#define M5LcdFillEllipse              //12
#define M5LcdDrawTriangleFO     0x3E
//#define M5LcdDrawTriangle             //13
//#define M5LcdFillTriangle             //14
#define M5LcdDrawBezier         0x3F    //15
#define M5LcdDrawEllipseArcFO   0x40
//#define M5LcdDrawEllipseArc           //16
//#define M5LcdFillEllipseArc           //17
#define M5LcdDrawArcFO          0x41    
//#define M5LcdfillArc                  //18
//#define M5LcdDrawArc                  //19
#define M5LcdDrawCircleHelper   0x42    //20
#define M5LcdFillCircleHelper   0x43    //21
#define M5LcdFloodFill          0x44    //22
#define M5LcdPaint              0x45    //23
#define M5LcdFillAffine         0x46    //24
#define M5LcdDrawGradientLine   0x47    //25
// LCD Images
#define M5LcdDrawBmp            0x48
#define M5LcdDrawJpg            0x49
#define M5LcdDrawPng            0x50
//IMU       0x50  //29 functions
//Log       0x60
#define M5LogSetLevel           0x60
#define M5LogGetLevel           0x61
#define M5LogSetEnableColor     0x62
#define M5LogGetEnableColor     0x63
#define M5LogSetSuffix          0x64
#define M5LogSetCallback        0x66 
#define M5LogSetDisplay         0x66
#define M5LogDump               0x67
//Power     0x70 //20 functions
#define M5PwrBegin              0x70    //1
#define M5PwrSetExtPwr          0x71    //2
#define M5PwrGetExtOut          0x72    //3
#define M5PwrSetUSBOut                  //CoreS3Only
#define M5PwrGetUSBOut                  //CoreS3Only         
#define M5PwrSetLED             0x73    //6
#define M5PwrOff                0x74    //7
#define M5PwrTimerSleep             
#define M5PwrDeepSleep              
#define M5PwrLightSleep             
#define M5PwrGetBatteryLvl      0x76    //11
#define M5PwrSetBatteryChg      0x77    //12
#define M5PwrSetChargeCurr      0x78    //13
#define M5PwrSetChargeVolt      0x79    //14
#define M5PwrIsCharging         0x7A    //15
#define M5PwrGetBatteryVolt     0x7B    //16
#define M5PwrGetBatteryCurr     0x7C    //17
#define M5PwrGetKeyState        0x7D    //18
#define M5PwrSetVibration       0x7E    //19
#define M5PwrGetType            0x7F    //20
//RTC       0x80 //14 functions
//Touch     0x90 //27 functions
#define M5TouchBegin            0x90
#define M5TouchGetCount         0x91
#define M5TouchGetDetail        0x92
#define M5TouchIsPressed        0x93
#define M5TouchGetX             0x94
#define M5TouchGetY             0x95
#define M5TouchGetRawX          0x96
#define M5TouchGetRawY          0x97
#define M5TouchGetPressure      0x98
#define M5TouchGetCount         0x99
//Button    0xA0
#define M5ButtonUpdate          0xA0
//Speaker   0xB0
#define SpeakerBegin            0xB0 
#define SpeakerStop             0xB1  
#define SpeakerTone             0xB2
#define SpeakerSetVolume        0xB3
#define SpeakerSetChVolume      0xB4
#define SpeakerGetVolume        0xB5
#define SpeakerPlayRaw          0xB7
//Mic       0xC0
#define MicConfig               0xC0
#define MicBegin                0xC1
#define MicEnd                  0xC2
#define MicIsRunning            0xC3
#define MicIsEnabled            0xC4
#define MicIsRecording          0xC5
#define MicSetSampleRate        0xC6
#define MicRecord               0xC7
#define MicSetGain              0xC8
// pSRAM    0xD0
#define M5PsramBegin            0xD0
#define M5PsramWriteByte        0xD1
#define M5PsramReadByte         0xD2
#define M5PsramWriteBytes       0xD3
#define M5PsramReadBytes        0xD4
#define M5PsramEraseSector      0xD5
#define M5PsramEraseAll         0xD6
//SD        0xE0

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  .#####...######..#####...##..##...####............####...######..#####..
//  .##..##..##......##..##..##..##..##..............##........##....##..##.
//  .##..##..####....#####...##..##..##.###...........####.....##....#####..
//  .##..##..##......##..##..##..##..##..##..............##....##....##..##.
//  .#####...######..#####....####....####............####.....##....##..##.
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//const char M5UNIFIED4ML_VERSION[]   PROGMEM = "v0.4.9";
const char MSG_M5Begin[]            PROGMEM = "M5 Begin\n";
const char MSG_GetBrdType[]         PROGMEM = "M5 GetBoardType\n";
const char MSG_MemUseChk[]          PROGMEM = "M5 MemoryStatusChk\n";
//LCD
const char MSG_M5LcdBegin[]         PROGMEM = "M5 Display Begin\n";
const char MSG_M5LcdStartWrite[]    PROGMEM = "M5 Display Start Write\n";
const char MSG_M5LcdEndWrite[]      PROGMEM = "M5 Display End Write\n";
const char MSG_M5LcdClear[]         PROGMEM = "M5.Display.clear();\n";
const char MSG_M5LcdDisplay[]       PROGMEM = "M5 Display Display\n";
const char MSG_M5LcdgetHeight[]     PROGMEM = "M5 Display Get Height\n";
const char MSG_M5LcdgetWidth[]      PROGMEM = "M5 Display Get Width\n";
const char MSG_M5LcdgetDispCount[]  PROGMEM = "M5 Display Get Display Count\n";
const char MSG_M5LcdgetRotation[]   PROGMEM = "M5 Display Get Rotation\n";
const char MSG_M5LcdsetRotation[]   PROGMEM = "M5 Display Set Rotation\n";
const char MSG_M5LcdsetBrightness[] PROGMEM = "M5 Display Set Brightness\n";
const char MSG_M5LcdsetColorDepth[] PROGMEM = "M5 Display Set Color Depth\n";
//LCD Text
const char MSG_M5LcdPrint[]         PROGMEM = "M5 Display: Print\n";
const char MSG_M5LcdPrintLine[]     PROGMEM = "M5 Display: PrintLine\n";
const char MSG_M5LcdDrawString[]    PROGMEM = "M5 Display: Draw String\n";
const char MSG_M5LcdTextColor[]     PROGMEM = "M5 Display: Text Color\n";
const char MSG_M5LcdTextDatum[]     PROGMEM = "M5 Display: Text Datum\n";
const char MSG_M5LcdTextSize[]      PROGMEM = "M5 Display: Text Size\n";
const char MSG_M5LcdTextFont[]      PROGMEM = "M5 Display: Text Font\n";
const char MSG_M5LcdSetCursor[]     PROGMEM = "M5 Display: Set Cursor\n";
//LCD Shapes
const char MSG_M5LcdDrawPixel[]     PROGMEM = "M5 Display: Draw Pixel\n";
const char MSG_M5LcdDrawLine[]      PROGMEM = "M5 Display: Draw Line\n";
const char MSG_M5LcdDrawRect[]      PROGMEM = "M5 Display: Draw Rect\n";
const char MSG_M5LcdFillRect[]      PROGMEM = "M5 Display: Fill Rect\n";
const char MSG_M5LcdDrawCircle[]    PROGMEM = "M5 Display: Draw Circle\n";
const char MSG_M5LcdFillCircle[]    PROGMEM = "M5 Display: Fill Circle\n";
const char MSG_M5LcdDrawTriangle[]  PROGMEM = "M5 Display: Draw Triangle\n";
const char MSG_M5LcdFillTriangle[]  PROGMEM = "M5 Display: Fill Triangle\n";
const char MSG_M5LcdDrawArc[]       PROGMEM = "M5 Display: Draw Arc\n";
const char MSG_M5LcdFillArc[]       PROGMEM = "M5 Display: Fill Arc\n";
const char MSG_M5LcdDrawEllipse[]   PROGMEM = "M5 Display: Draw Ellipse\n";
const char MSG_M5LcdFillEllipse[]   PROGMEM = "M5 Display: Fill Ellipse\n";
const char MSG_M5LcdDrawRoundRect[] PROGMEM = "M5 Display: Draw Round Rect\n";
const char MSG_M5LcdFillRoundRect[] PROGMEM = "M5 Display: Fill Round Rect\n";
const char MSG_M5LcdDrawFastHLine[] PROGMEM = "M5 Display: Draw Fast HLine\n";
const char MSG_M5LcdDrawFastVLine[] PROGMEM = "M5 Display: Draw Fast VLine\n";
const char MSG_M5LcdAllocateMem[]   PROGMEM = "M5 Display: Allocate Memory\n";
//LCD Images
const char MSG_M5LcdDrawJPG[]       PROGMEM = "M5 Display .jpg\n";
const char MSG_M5LcdDrawPNG[]       PROGMEM = "M5 Display .png\n";
const char MSG_M5LcdDrawBmp[]       PROGMEM = "M5 Display .bmp\n";
//Touch
const char MSG_M5TouchBegin[]       PROGMEM = "M5 Touch Begin\n";
const char MSG_M5TouchGetCount[]    PROGMEM = "M5 Touch Get Count\n";
const char MSG_M5TouchGetDetail[]   PROGMEM = "M5 Touch Get Detail\n";
const char MSG_M5TouchIsPressed[]   PROGMEM = "M5 Touch Is Pressed\n";
const char MSG_M5TouchGetX[]        PROGMEM = "M5 Touch Get X\n";
const char MSG_M5TouchGetY[]        PROGMEM = "M5 Touch Get Y\n";
const char MSG_M5TouchGetRawX[]     PROGMEM = "M5 Touch Get Raw X\n";
const char MSG_M5TouchGetRawY[]     PROGMEM = "M5 Touch Get Raw Y\n";
const char MSG_M5TouchGetPressure[] PROGMEM = "M5 Touch Get Pressure\n";
//Button
const char MSG_M5ButtonUpdate[]     PROGMEM = "M5 Button Update\n";
//Speaker
const char MSG_SpeakerBegin[]       PROGMEM = "M5 Speaker Begin\n";
const char MSG_SpeakerStop[]        PROGMEM = "M5 Speaker Stop\n";
const char MSG_SpeakerTone[]        PROGMEM = "M5 Speaker Tone\n";
const char MSG_SpeakerSetVolume[]   PROGMEM = "M5 Speaker Set Volume\n";
const char MSG_SpeakerGetVolume[]   PROGMEM = "M5 Speaker Get Volume\n";
const char MSG_SpeakerPlayRaw[]     PROGMEM = "M5 Speaker Play Raw\n";
//Mic
const char MSG_MicConfig[]          PROGMEM = "M5 Mic Config\n";
const char MSG_MicBegin[]           PROGMEM = "M5 Mic Begin\n";
const char MSG_MicEnd[]             PROGMEM = "M5 Mic End\n";
const char MSG_MicSetSampleRate[]   PROGMEM = "M5 Mic Set Sample Rate\n";
const char MSG_MicRecord[]          PROGMEM = "M5 Mic Record\n";
const char MSG_MicRecErr[]          PROGMEM = "M5 Mic Record Error\n";
const char MSG_MicIsRunning[]       PROGMEM = "M5 Mic Is Running\n";
const char MSG_MicIsEnabled[]       PROGMEM = "M5 Mic Is Enabled\n";
const char MSG_MicIsRecording[]     PROGMEM = "M5 Mic Is Recording\n";
const char MSG_MicSetGain[]         PROGMEM = "M5 Mic Set Gain\n";
//Power
const char MSG_M5PwrBegin[]         PROGMEM = "M5 Power Begin\n";
const char MSG_M5PwrSetExtPwr[]     PROGMEM = "M5 Power Set External Power\n";
const char MSG_M5PwrGetExtOut[]     PROGMEM = "M5 Power Get External Output\n";
const char MSG_M5PwrSetUSBOut[]     PROGMEM = "M5 Power Set USB Output\n";
const char MSG_M5PwrGetUSBOut[]     PROGMEM = "M5 Power Get USB Output\n";
const char MSG_M5PwrSetLED[]        PROGMEM = "M5 Power Set LED\n";
const char MSG_M5PwrOff[]           PROGMEM = "M5 Power Off\n";
const char MSG_M5PwrTimerSleep[]    PROGMEM = "M5 Power Timer Sleep\n";
const char MSG_M5PwrDeepSleep[]     PROGMEM = "M5 Power Deep Sleep\n";
const char MSG_M5PwrLightSleep[]    PROGMEM = "M5 Power Light Sleep\n";
const char MSG_M5PwrGetBatteryLvl[] PROGMEM = "M5 Power Get Battery Level\n";
const char MSG_M5PwrSetBatteryChg[] PROGMEM = "M5 Power Set Battery Charge\n";
const char MSG_M5PwrSetChargeCurr[] PROGMEM = "M5 Power Set Charge Current\n";
const char MSG_M5PwrSetChargeVolt[] PROGMEM = "M5 Power Set Charge Voltage\n";
const char MSG_M5PwrIsCharging[]    PROGMEM = "M5 Power Is Charging\n";
const char MSG_M5PwrGetBatteryVolt[]PROGMEM = "M5 Power Get Battery Voltage\n";
const char MSG_M5PwrGetBatteryCurr[]PROGMEM = "M5 Power Get Battery Current\n";
const char MSG_M5PwrGetKeyState[]   PROGMEM = "M5 Power Get Key State\n";
const char MSG_M5PwrSetVibration[]  PROGMEM = "M5 Power Set Vibration\n";
const char MSG_M5PwrGetType[]       PROGMEM = "M5 Power Get Type\n";
//Default
const char MSG_M5UNKNOWN_CMD[]      PROGMEM = "M5[%d]->Unknown Command\n";

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Speaker Variables
static constexpr const size_t max_volume = 255;
static constexpr const size_t min_volume = 0;
//Mic Variables
static constexpr const size_t record_number = 256;
static constexpr const size_t record_length = 200;
static constexpr const size_t record_size = record_number * record_length;
static constexpr const size_t record_samplerate = 16000;
static int16_t prev_y[record_length];
static int16_t prev_h[record_length];
static size_t rec_record_idx = 2;
static size_t draw_record_idx = 0;
static int16_t *rec_data;
//PSRAM testing
int n_elements = 1000;
unsigned char * acc_data_all;

// Global variables to store image data
    byte* pngData;
    std::vector<uint8_t> imageData; 

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
        libName = "M5Stack/M5Unified";
        // Register the library to the server
        a.registerLibrary(this);
    }

public:
    void setup()
    {
        M5.begin();
        M5.Display.setCursor(0, 10);
        M5.Display.setTextSize(2);
        M5.Display.println("<- Power Off (Hold 5s)");
        M5.Display.setCursor(0, 50);
        M5.Display.setTextSize(1.5);
        M5.Display.println("MATLAB Support Package for Arduino");
        M5.Display.println("using the: M5Unified Add-On Library");
        M5.Display.print("IO Server Version: ");
        M5.Display.println(BOARD_IO_VERSION);
        M5.Display.print("M5Unified Library Version: ");
        M5.Display.println(" 0.4.9");
        M5.Display.print("Libraries: ");
        M5.Display.println(LIBNAMES);
        //Allocate for a PNG 
            pngData = (byte*)malloc(720);
        //Try to get PSRAM working
        acc_data_all = (unsigned char *) ps_malloc (n_elements * sizeof (unsigned char)); 
        if(psramInit()){
        M5.Display.println("\nPSRAM is correctly initialized");
        }else{
        M5.Display.println("PSRAM not available");
        }
        
    }
public:
    void loop() {

        M5.delay(1); //ms
        M5.update();
        //TODO:
        //When there is no active connection to MATLAB, run some demo code. 
        //Checking for !Serial or Serial.available()=0 both don't work.
      /* 
      if (Serial) {
          M5.Display.print("Serial Connection to MATLAB");
          int cursor_y = M5.Display.getCursorY();
          M5.Display.setCursor(0, cursor_y);
     }else{
          M5.Display.print("No Connection to MATLAB");
          int cursor_y = M5.Display.getCursorY();
          M5.Display.setCursor(0, cursor_y);
        //------------------- Button.ino Example
        /// List of available buttons:
        //  M5Stack BASIC/GRAY/GO/FIRE:  BtnA,BtnB,BtnC
        //  M5Stack Core2:               BtnA,BtnB,BtnC,BtnPWR
        //  M5Stick C/CPlus:             BtnA,BtnB,     BtnPWR
        //  M5Stick CoreInk:             BtnA,BtnB,BtnC,BtnPWR,BtnEXT
        //  M5Paper:                     BtnA,BtnB,BtnC
        //  M5Station:                   BtnA,BtnB,BtnC,BtnPWR
        //  M5Tough:                                    BtnPWR
        //  M5Atom M5AtomU:              BtnA
        //  M5Stamp Pico/C3/C3U:         BtnA
        //
          static constexpr const int colors[] = { TFT_WHITE, TFT_CYAN, TFT_RED, TFT_YELLOW, TFT_BLUE, TFT_GREEN };
          static constexpr const char* const names[] = { "none", "wasHold", "wasClicked", "wasPressed", "wasReleased", "wasDeciedCount" };
        
          int w = M5.Display.width() / 3;
          int h = M5.Display.height() / 5;
          M5.Display.startWrite();
        
          /// BtnPWR: "wasClicked"/"wasHold"  can be use.
          /// BtnPWR of CoreInk: "isPressed"/"wasPressed"/"isReleased"/"wasReleased"/"wasClicked"/"wasHold"/"isHolding"  can be use.
          int state = M5.BtnPWR.wasHold() ? 1
                    : M5.BtnPWR.wasClicked() ? 2
                    : M5.BtnPWR.wasPressed() ? 3
                    : M5.BtnPWR.wasReleased() ? 4
                    : M5.BtnPWR.wasDecideClickCount() ? 5
                    : 0;
        
          if (state)
            {
                M5_LOGI("BtnPWR:%s  count:%d", names[state], M5.BtnPWR.getClickCount());
                M5.Display.fillRect(0, 0, w-1, h, colors[state]);
            }
            /// BtnA,BtnB,BtnC,BtnEXT: "isPressed"/"wasPressed"/"isReleased"/"wasReleased"/"wasClicked"/"wasHold"/"isHolding"  can be use.
                state = M5.BtnA.wasHold() ? 1
                    : M5.BtnA.wasClicked() ? 2
                    : M5.BtnA.wasPressed() ? 3
                    : M5.BtnA.wasReleased() ? 4
                    : M5.BtnA.wasDecideClickCount() ? 5
                    : 0;
            if (state)
            {
                M5_LOGI("BtnA:%s  count:%d", names[state], M5.BtnA.getClickCount());
                M5.Display.fillRect(0, h*4, w-1, h, colors[state]);
            }
                state = M5.BtnB.wasHold() ? 1
                    : M5.BtnB.wasClicked() ? 2
                    : M5.BtnB.wasPressed() ? 3
                    : M5.BtnB.wasReleased() ? 4
                    : M5.BtnB.wasDecideClickCount() ? 5
                    : 0;
            if (state)
            {
                M5_LOGI("BtnB:%s  count:%d", names[state], M5.BtnB.getClickCount());
                M5.Display.fillRect(w*1, h*4, w-1, h, colors[state]);
            }
                state = M5.BtnC.wasHold() ? 1
                    : M5.BtnC.wasClicked() ? 2
                    : M5.BtnC.wasPressed() ? 3
                    : M5.BtnC.wasReleased() ? 4
                    : M5.BtnC.wasDecideClickCount() ? 5
                    : 0;
            if (state)
            {
                M5_LOGI("BtnC:%s  count:%d", names[state], M5.BtnC.getClickCount());
                M5.Display.fillRect(w*2, h*4, w-1, h, colors[state]);
            }
            state = M5.BtnEXT.wasHold() ? 1
                : M5.BtnEXT.wasClicked() ? 2
                : M5.BtnEXT.wasPressed() ? 3
                : M5.BtnEXT.wasReleased() ? 4
                : M5.BtnEXT.wasDecideClickCount() ? 5
                : 0;
            if (state)
            {
            M5_LOGI("BtnEXT:%s  count:%d", names[state], M5.BtnEXT.getClickCount());
            M5.Display.fillRect(w*2, 0, w-1, h, colors[state]);
            }
            M5.Display.endWrite();
        } //if(Serial.available)
        */
    } //void loop()
    
//---------------------------------------------------------------------------------------------------------------------
//  ..####...##...##..#####...........##..##..##..##..#####...##......#####..
//  .##..##..###.###..##..##..........##..##..###.##..##..##..##......##..##.
//  .##......##.#.##..##..##..........######..##.###..##..##..##......#####..
//  .##..##..##...##..##..##..........##..##..##..##..##..##..##......##..##.
//  ..####...##...##..#####...........##..##..##..##..#####...######..##..##. 
//---------------------------------------------------------------------------------------------------------------------
public:
    void commandHandler(byte cmdID, byte* dataIn, unsigned int payload_size)
    {
        switch (cmdID){
// Main Commands
            case M5Begin:{
            /* 0: Begin. Starts with the default configuration unless you write the cfg file when you call begin.
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
                M5.begin();
                // Print debug string
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
            // case check available memory 0x03
            case getMemoryStatus: {
                // Get the available memory    
                uint32_t getHeap = ESP.getHeapSize();
                uint32_t getFreeHeap = ESP.getFreeHeap();
                uint32_t getPsram = ESP.getPsramSize();
                uint32_t getFreePsram = ESP.getFreePsram();
                // Save the available memory in a byte array
                byte availableMemory[16];

                memcpy(availableMemory, &getHeap, 4);
                memcpy(availableMemory + 4, &getFreeHeap, 4);
                memcpy(availableMemory + 8, &getPsram, 4);
                memcpy(availableMemory + 12, &getFreePsram, 4);
                // Print debug string
                // log_d("Total heap: %d", ESP.getHeapSize());
                // log_d("Free heap: %d", ESP.getFreeHeap());
                // log_d("Total PSRAM: %d", ESP.getPsramSize());
                // log_d("Free PSRAM: %d", ESP.getFreePsram());
                // Print debug string
                debugPrint(MSG_MemUseChk);
                // Send response
                //sendResponseMsg(cmdID, (byte*)&availableMemory, 16);
                //byte* byteData = reinterpret_cast<byte*>(availableMemory); // from  micRecord
                sendResponseMsg(cmdID, availableMemory, 16);
                break;
            }
//---------------------------------------------------------------------------------------------------------------------
//  $$\       $$$$$$\  $$$$$$$\  
//  $$ |     $$  __$$\ $$  __$$\ 
//  $$ |     $$ /  \__|$$ |  $$ |
//  $$ |     $$ |      $$ |  $$ |
//  $$ |     $$ |      $$ |  $$ |
//  $$ |     $$ |  $$\ $$ |  $$ |
//  $$$$$$$$\\$$$$$$  |$$$$$$$  |
//  \________|\______/ \_______/
//---------------------------------------------------------------------------------------------------------------------
            // case M5LcdBegin    0x20
            case M5LcdBegin: {
                M5.Display.begin();
                // Print debug string and pin
                debugPrint(MSG_M5LcdBegin);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5LcdStartWrite 0x21
            case M5LcdStartWrite: {
                M5.Display.startWrite();
                // Print debug string
                debugPrint(MSG_M5LcdStartWrite);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5LcdEndWrite 0x22
            case M5LcdEndWrite: {
                M5.Display.endWrite();
                // Print debug string
                debugPrint(MSG_M5LcdEndWrite);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5LcdClear 0x23
            case M5LcdClear: {
                M5.Display.clear();
                // Print debug string
                debugPrint(MSG_M5LcdClear);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5LcdDisplay 0x24
            case M5LcdDisplay: {
                M5.Display.display();
                // Print debug string
                debugPrint(MSG_M5LcdDisplay);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5LcdgetHeight 0x25
            case M5LcdgetHeight: {
                uint16_t height = M5.Display.height(); //Height is an int16_t cast to an int32_t
                //byte* response = reinterpret_cast<byte*>(&height);
                //uint16_t respLen = sizeof(height);
                // Print debug string
                debugPrint(MSG_M5LcdgetHeight);
                // Send response
                sendResponseMsg(cmdID, (byte*)&height, 2);
                // sendResponseMsg(cmdID, (byte*)&chargeCurrent, 4);
                break;
            }
            // case M5LcdgetWidth 0x26
            case M5LcdgetWidth: {
                uint16_t width = M5.Display.width();
                //byte* response = reinterpret_cast<byte*>(&width);
                //uint16_t respLen = sizeof(width);
                // Print debug string
                debugPrint(MSG_M5LcdgetWidth);
                // Send response
                sendResponseMsg(cmdID, reinterpret_cast<byte*>(&width), 2);
                break;
            }
            // case M5LcdgetDispCount 0x27
            case M5LcdgetDispCount: {
                uint8_t dispCount = M5.getDisplayCount();
                byte* response = reinterpret_cast<byte*>(&dispCount);
                //uint16_t respLen = sizeof(dispCount);
                // Print debug string
                debugPrint(MSG_M5LcdgetDispCount);
                // Send response
                sendResponseMsg(cmdID, response, 1);
                break;
            }
            // case M5LcdgetRotation 0x28
            case M5LcdgetRotation: {
                uint8_t rotation = M5.Display.getRotation();
                byte* response = reinterpret_cast<byte*>(&rotation);
                //uint16_t respLen = sizeof(rotation);
                // Print debug string
                debugPrint(MSG_M5LcdgetRotation);
                // Send response
                sendResponseMsg(cmdID, response, 1);
                break;
            }
            // case M5LcdsetRotation 0x29
            case M5LcdsetRotation: {
                // Extract the rotation from dataIn
                uint8_t rotation = dataIn[0];
                M5.Display.setRotation(rotation);
                // Print debug string
                debugPrint(MSG_M5LcdsetRotation);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5LcdsetBrightness 0x2A
            case M5LcdsetBrightness: {
                // Extract the brightness from dataIn
                uint8_t brightness = dataIn[0];
                M5.Display.setBrightness(brightness);
                // Print debug string
                debugPrint(MSG_M5LcdsetBrightness);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            // case M5LcdAllocateMem 0x22
            // Allocate memory to receive image data 
            case M5LcdAllocateMem: {
                // Extract the image size from dataIn
                uint16_t imageSize = (dataIn[0] << 8) | dataIn[1];

                // Allocate memory for the image data
                //byte* imageData = new byte[imageSize];
                imageData.resize(imageSize);

                // Print debug string
                debugPrint(MSG_M5LcdAllocateMem);

                // Send response
                sendResponseMsg(cmdID, 0, 0);

                break;
            }
//----------------------------------------------------------------------------------------------------------------------
// $$\       $$$$$$\  $$$$$$$\        $$$$$$$$\ $$$$$$$$\ $$\   $$\ $$$$$$$$\ 
// $$ |     $$  __$$\ $$  __$$\       \__$$  __|$$  _____|$$ |  $$ |\__$$  __|
// $$ |     $$ /  \__|$$ |  $$ |         $$ |   $$ |      \$$\ $$  |   $$ |   
// $$ |     $$ |      $$ |  $$ |         $$ |   $$$$$\     \$$$$  /    $$ |   
// $$ |     $$ |      $$ |  $$ |         $$ |   $$  __|    $$  $$<     $$ |   
// $$ |     $$ |  $$\ $$ |  $$ |         $$ |   $$ |      $$  /\$$\    $$ |   
// $$$$$$$$\\$$$$$$  |$$$$$$$  |         $$ |   $$$$$$$$\ $$ /  $$ |   $$ |   
// \________|\______/ \_______/          \__|   \________|\__|  \__|   \__|   
//----------------------------------------------------------------------------------------------------------------------
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

/*
1. drawString:
[[deprecated("use IFont")]]
void drawString(const char *string, int32_t x, int32_t y, uint8_t font);
NEW
  display.setFont(&fonts::Font2); // Set the font
  display.setTextColor(TFT_WHITE, TFT_BLACK); // Set text color and background color
  display.drawText("Hello, World!", 10, 10); // Draw text at coordinates (10, 10)
2. setTextDatum:
[[deprecated("use IFont")]]
void setTextDatum(uint8_t datum);
NEW
#include <Fonts/FreeMonoBoldOblique12pt7b.h>
display.setFont(&FreeMonoBoldOblique12pt7b);
display.setTextDatum(textdatum_t::middle_center);

3. setTextPadding:
[[deprecated("use IFont")]]
void setTextPadding(uint16_t x_width);
NEW
#include <Fonts/FreeMonoBoldOblique12pt7b.h>
display.setFont(&FreeMonoBoldOblique12pt7b);
display.setTextPadding(10);

4. setTextColor:
[[deprecated("use IFont")]]
void setTextColor(uint16_t color);
NEW
#include <Fonts/FreeMonoBoldOblique12pt7b.h>
display.setFont(&FreeMonoBoldOblique12pt7b);
display.setTextColor(TFT_WHITE);

5.setTextSize:
[[deprecated("use IFont")]]
void setTextSize(uint8_t size);
NEW
#include <Fonts/FreeMonoBoldOblique12pt7b.h>
display.setFont(&FreeMonoBoldOblique12pt7b);
display.setTextSize(2);
*/

            //case M5LcdDrawString 0x33
            case M5LcdDrawString: {
                // We will use drawString(char,  x,  y ) and not worry abut any overloads for now
                //OverLoads
                //[[deprecated("use IFont")]]
                //  inline size_t drawString(const char *string, int32_t x, int32_t y, uint8_t      font) { return draw_string(string, x, y, _text_style.datum, fontdata[font]); }
                //  inline size_t drawString(const char *string, int32_t x, int32_t y                   ) { return draw_string(string, x, y, _text_style.datum); }
                //  inline size_t drawString(const char *string, int32_t x, int32_t y, const IFont* font) { return draw_string(string, x, y, _text_style.datum, font); }
                //  inline size_t drawString(const String& string, int32_t x, int32_t y, uint8_t      font) { return draw_string(string.c_str(), x, y, _text_style.datum, fontdata[font]); }
                //  inline size_t drawString(const String& string, int32_t x, int32_t y, const IFont* font) { return draw_string(string.c_str(), x, y, _text_style.datum,          font ); }
                //  inline size_t drawString(const String& string, int32_t x, int32_t y                   ) { return draw_string(string.c_str(), x, y, _text_style.datum); }
                
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
//----------------------------------------------------------------------------------------------------------------------
//  $$\       $$$$$$\  $$$$$$$\         $$$$$$\  $$\   $$\  $$$$$$\  $$$$$$$\  $$$$$$$$\  $$$$$$\  
//  $$ |     $$  __$$\ $$  __$$\       $$  __$$\ $$ |  $$ |$$  __$$\ $$  __$$\ $$  _____|$$  __$$\ 
//  $$ |     $$ /  \__|$$ |  $$ |      $$ /  \__|$$ |  $$ |$$ /  $$ |$$ |  $$ |$$ |      $$ /  \__|
//  $$ |     $$ |      $$ |  $$ |      \$$$$$$\  $$$$$$$$ |$$$$$$$$ |$$$$$$$  |$$$$$\    \$$$$$$\  
//  $$ |     $$ |      $$ |  $$ |       \____$$\ $$  __$$ |$$  __$$ |$$  ____/ $$  __|    \____$$\ 
//  $$ |     $$ |  $$\ $$ |  $$ |      $$\   $$ |$$ |  $$ |$$ |  $$ |$$ |      $$ |      $$\   $$ |
//  $$$$$$$$\\$$$$$$  |$$$$$$$  |      \$$$$$$  |$$ |  $$ |$$ |  $$ |$$ |      $$$$$$$$\ \$$$$$$  |
//  \________|\______/ \_______/        \______/ \__|  \__|\__|  \__|\__|      \________| \______/ 
//----------------------------------------------------------------------------------------------------------------------
/* From LGFXbase.hpp
1. drawPixel
2. drawLine
3. drawFastVLine
4. drawFastHLine
5. fillRect x
6. drawRect x
7. drawRoundRect x
8. fillRoundRect x
9. drawCircle
10. fillCircle
11.drawEllipse
12.fillEllipse
13.drawTriangle
14.fillTriangle
15.drawBezier
16.drawEllipseArc
17.fillEllipseArc
18.drawArc
19.fillArc
20.drawCircleHelper
21.fillCircleHelper
22.floodFill
23.paint
24.fillAffine
25.drawGradientLine
*/
                // case drawPixel 0x39 #1.
                case M5LcdDrawPixel: {
                    // Extract the x, y, and color from dataIn
                    uint16_t x = (dataIn[0] << 8) | dataIn[1];
                    uint16_t y = (dataIn[2] << 8) | dataIn[3];
                    if (payload_size > 4) {
                        uint16_t color = (dataIn[4] << 8) | dataIn[5];
                        M5.Display.drawPixel(x, y, color);
                    } else {
                        M5.Display.drawPixel(x, y);
                    }
                    // Print debug string
                    debugPrint(MSG_M5LcdDrawPixel);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                                // case M5LcdDrawLine 0x39 12.drawLine
                case M5LcdDrawLine: {
                    // Draw a line with option to set color
                    // Extract the x0, y0, x1, y1, and color from dataIn
                    uint16_t x0 = (dataIn[0] << 8) | dataIn[1];
                    uint16_t y0 = (dataIn[2] << 8) | dataIn[3];
                    uint16_t x1 = (dataIn[4] << 8) | dataIn[5];
                    uint16_t y1 = (dataIn[6] << 8) | dataIn[7];
                    if (payload_size > 9) {
                        uint16_t color = (dataIn[8] << 8) | dataIn[9];
                        M5.Display.drawLine(x0, y0, x1, y1, color);
                    } else {
                        M5.Display.drawLine(x0, y0, x1, y1);
                    }
                    // Print debug string
                    debugPrint(MSG_M5LcdDrawLine);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                //case drawFastVLine 0x3A #2.
                case M5LcdDrawFastVLine: {
                    // Extract the x, y, height, and color from dataIn
                    uint16_t x = (dataIn[0] << 8) | dataIn[1];
                    uint16_t y = (dataIn[2] << 8) | dataIn[3];
                    uint16_t height = (dataIn[4] << 8) | dataIn[5];
                    if (payload_size > 6) {
                        uint16_t color = (dataIn[6] << 8) | dataIn[7];
                        M5.Display.drawFastVLine(x, y, height, color);
                    } else {
                        M5.Display.drawFastVLine(x, y, height);
                    }
                    // Print debug string
                    debugPrint(MSG_M5LcdDrawFastVLine);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case drawFastHLine 0x3B #3.
                case M5LcdDrawFastHLine: {
                    // Extract the x, y, width, and color from dataIn
                    uint16_t x = (dataIn[0] << 8) | dataIn[1];
                    uint16_t y = (dataIn[2] << 8) | dataIn[3];
                    uint16_t width = (dataIn[4] << 8) | dataIn[5];
                    if (payload_size > 6) {
                        uint16_t color = (dataIn[6] << 8) | dataIn[7];
                        M5.Display.drawFastHLine(x, y, width, color);
                    } else {
                        M5.Display.drawFastHLine(x, y, width);
                    }
                    // Print debug string
                    debugPrint(MSG_M5LcdDrawFastHLine);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
/*                 // case drawRectangles 0x??
                case drawRectangles: {
                    // Extract the x, y, width, height, and color from dataIn
                    uint16_t x = (dataIn[0] << 8) | dataIn[1];
                    uint16_t y = (dataIn[2] << 8) | dataIn[3];
                    uint16_t width = (dataIn[4] << 8) | dataIn[5];
                    uint16_t height = (dataIn[6] << 8) | dataIn[7];
                    uint16_t color = (dataIn[8] << 8) | dataIn[9];
                    // Draw the rectangle
                    M5.Display.fillRect(x, y, width, height, color);
                    // Print debug string
                    debugPrint(MSG_DRAW_RECTANGLES);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                } */
                
                // case M5LcdDrawRect 0x3C #4.SquareFilled #5.SquareUnfilled #6.RoundedUnfilled #7.RoundedFilled 
                case M5LcdDrawRectFOR: {
                    // Draw a Rectangel with options for Color, Fill, Outline, Rounded 
                    // Extract the rectangle type from dataIn
                    uint8_t rectType = dataIn[0];
                    // Extract the x, y, width, height from dataIn
                    uint16_t x = (dataIn[1] << 8) | dataIn[2];
                    uint16_t y = (dataIn[3] << 8) | dataIn[4];
                    uint16_t width = (dataIn[5] << 8) | dataIn[6];
                    uint16_t height = (dataIn[7] << 8) | dataIn[8];

                    // Determine filled/unfilled, square/rounded, color/uncolored
                    bool filled = rectType & 0x01; // 1st bit
                    bool rounded = rectType & 0x02; // 2nd bit
                    bool useColor = rectType & 0x04; // 3rd bit

                    if (useColor) {
                        uint16_t color = (dataIn[payload_size - 2] << 8) | dataIn[payload_size - 1]; // Extract color if available
                        M5.Display.setColor(color); //The overloads of the below functions use setColor so we set it here instead of in the function
                    }

                    if (rounded) {
                         // Rounded rectangle
                         uint16_t radius = (dataIn[9] << 8) | dataIn[10]; // Extract radius                        
                        if (filled) {
                            //M5.Display.fillRoundRect(x, y, width, height, radius, useColor ? color : 0);
                            M5.Display.fillRoundRect(x, y, width, height, radius);
                            debugPrint(MSG_M5LcdFillRoundRect);
                        } else {
                            //M5.Display.drawRoundRect(x, y, width, height, radius, useColor ? color : 0);
                            M5.Display.drawRoundRect(x, y, width, height, radius);
                            debugPrint(MSG_M5LcdDrawRoundRect);
                        }
                    } else {
                        // Regular Rectangle
                        if (filled) {
                            // M5.Display.fillRect(x, y, width, height, useColor ? color : 0);
                            M5.Display.fillRect(x, y, width, height);
                            debugPrint(MSG_M5LcdFillRect);
                        } else {
                            //M5.Display.drawRect(x, y, width, height, useColor ? color : 0);
                            M5.Display.drawRect(x, y, width, height);
                            debugPrint(MSG_M5LcdDrawRect);
                        }
                    }
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case drawCircle  8. drawCircle 9. fillCircle
                case M5LcdDrawCircleFO: {
                    // Extract the x, y, radius, filled status, and color from dataIn
                    uint16_t x = (dataIn[0] << 8) | dataIn[1];
                    uint16_t y = (dataIn[2] << 8) | dataIn[3];
                    uint16_t radius = (dataIn[4] << 8) | dataIn[5];
                    uint8_t filled = dataIn[6]; // 0 for unfilled, 1 for filled
                    uint16_t color = (payload_size > 7) ? (dataIn[7] << 8) | dataIn[8] : 0;
                    // Draw the circle
                    if (filled) {
                        if (payload_size > 7) {
                            M5.Display.fillCircle(x, y, radius, color);
                        } else {
                            M5.Display.fillCircle(x, y, radius);
                        }
                    } else {
                        if (payload_size > 7) {
                            M5.Display.drawCircle(x, y, radius, color);
                        } else {
                            M5.Display.drawCircle(x, y, radius);
                        }
                    }
                    // Print debug string
                    debugPrint(MSG_M5LcdDrawCircle);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }

//----------------------------------------------------------------------------------------------------------------------
//  $$\       $$$$$$\  $$$$$$$\        $$$$$$\ $$\      $$\  $$$$$$\   $$$$$$\  $$$$$$$$\  $$$$$$\  
//  $$ |     $$  __$$\ $$  __$$\       \_$$  _|$$$\    $$$ |$$  __$$\ $$  __$$\ $$  _____|$$  __$$\ 
//  $$ |     $$ /  \__|$$ |  $$ |        $$ |  $$$$\  $$$$ |$$ /  $$ |$$ /  \__|$$ |      $$ /  \__|
//  $$ |     $$ |      $$ |  $$ |        $$ |  $$\$$\$$ $$ |$$$$$$$$ |$$ |$$$$\ $$$$$\    \$$$$$$\  
//  $$ |     $$ |      $$ |  $$ |        $$ |  $$ \$$$  $$ |$$  __$$ |$$ |\_$$ |$$  __|    \____$$\ 
//  $$ |     $$ |  $$\ $$ |  $$ |        $$ |  $$ |\$  /$$ |$$ |  $$ |$$ |  $$ |$$ |      $$\   $$ |
//  $$$$$$$$\\$$$$$$  |$$$$$$$  |      $$$$$$\ $$ | \_/ $$ |$$ |  $$ |\$$$$$$  |$$$$$$$$\ \$$$$$$  |
//  \________|\______/ \_______/       \______|\__|     \__|\__|  \__| \______/ \________| \______/ 
//----------------------------------------------------------------------------------------------------------------------

           /* To allocate memory for bmpBuffer in C++, you have a few options:
            1. Using new (Dynamic Memory Allocation):
                bmpBuffer = new byte[desiredSize];
            2. Using std::vector (Recommended):
                std::vector<byte> bmpBuffer; // Declare a vector
                bmpBuffer.resize(desiredSize); // Later, allocate memory:
            3. Using malloc and realloc (C-style)
                bmpBuffer = static_cast<byte*>(malloc(desiredSize * sizeof(byte)));
                // Later, reallocate if needed:
                bmpBuffer = static_cast<byte*>(realloc(bmpBuffer, newDesiredSize * sizeof(byte))); 
           */

           /*for the case M5LCDdrawBitmap, the data received in packtes over multiple commands, the first 2 bytes of 
           dataIn are the packet number, the second 2 bytes are the total number of packtes. store the data in a buffer 
           until it's the final packet, then display the image*/
        /*
        // case M5LcdDrawBmp: {
            static byte* bmpBuffer = nullptr;
            static uint16_t packetSize = 0;
            static uint16_t bmpPacketNumber = 0;
            static uint16_t bmpTotalPackets = 0;

            // Extract the packet number and total packets from dataIn
            uint16_t packetNumber = (dataIn[0] << 8) | dataIn[1];
            uint16_t totalPackets = (dataIn[2] << 8) | dataIn[3];

            // If it's the first packet, allocate memory for the buffer
            if (packetNumber == 0) {
                packetSize = payload_size - 4;
                bmpBuffer = new byte[packetSize * totalPackets];
                bmpPacketNumber = 0;
                bmpTotalPackets = totalPackets;
                
                imageData.resize(packetSize * totalPackets); // Resize imageData to match the total data received
            }

            // Copy the data to the buffer
            memcpy(bmpBuffer + (packetSize * packetNumber), dataIn + 4, payload_size - 4);

            // If it's the final packet, display the image
            if (packetNumber == totalPackets - 1) {
                // Copy the data from bmpBuffer to imageData
                memcpy(imageData.data(), bmpBuffer, packetSize * totalPackets);

                // Draw the BMP image
                M5.Display.drawBmp(imageData.data(), x0, y0, packetSize * totalPackets);

                // Print debug string
                debugPrint(MSG_M5LcdDrawBmp);

                // Send response
                sendResponseMsg(cmdID, 0, 0);

                // Free the buffer memory
                delete[] bmpBuffer;
                bmpBuffer = nullptr;
                packetSize = 0;
                bmpPacketNumber = 0;
                bmpTotalPackets = 0;
            }

            break; */
            case M5LcdDrawBmp: {
                    
                    static uint16_t packetSize = payload_size - 4; //renamed from bmpBufferSize
                    static uint16_t bmpPacketNumber = 0;
                    static uint16_t bmpTotalPackets = 0;
                    static uint16_t imageSize = 0;

                    // Extract the packet number and total packets from dataIn
                    uint16_t packetNumber = (dataIn[0] << 8) | dataIn[1];
                    uint16_t totalPackets = (dataIn[2] << 8) | dataIn[3];

                    // If it's the first packet, allocate memory for the buffer
                    if (packetNumber == 0) {
                        imageData.resize(imageSize);                       
                    }
                    // Copy the data to the imageData buffer
                    memcpy(imageData.data() + (packetSize * packetNumber), dataIn + 4, payload_size - 4);
                    // If it's the final packet, display the image
                    if (packetNumber == totalPackets - 1) {
                        // Draw the BMP image
                        M5.Display.drawBmp(reinterpret_cast<const uint8_t*>(imageData.data()), packetSize * totalPackets);

                        // Print debug string
                        debugPrint(MSG_M5LcdDrawBmp);

                        // Send response
                        sendResponseMsg(cmdID, 0, 0);

                        // Clear the imageData buffer
                        imageData.clear();
                        }

                    break;
                }
            
            
            // case M5DisplayJPG 0x49
            case M5LcdDrawJpg: {
             // display.drawJpg(jpg_image, ~0u, 0, 0, display.width(), display.height(), 0, 0, 0.0f, -1.0f);
             // drawJpg(const uint8_t *jpg_data, size_t jpg_len, uint16_t x = 0, uint16_t y = 0, uint16_t maxWidth = 0, uint16_t maxHeight = 0, uint16_t offX = 0, uint16_t offY = 0, jpeg_div_t scale = JPEG_DIV_NONE);
                byte* jpgData = dataIn;
                size_t dataInSize = payload_size;
                // Extract the size of dataIn
                    //uint16_t jpgLength = (dataIn[0] << 8) | dataIn[1];
                // Increment the dataIn pointer to point to the start of jpgData
                    //dataIn += 2;
                uint16_t x = 0;
                uint16_t y = 0;
                uint16_t maxWidth = 0; 
                uint16_t maxHeight = 0; 
                uint16_t offX = 0;
                uint16_t offY = 0;
                //jpeg_div_t scale = JPEG_DIV_NONE;
                float scale = 1.0f;
                  
                // Draw the JPG image
                M5.Display.drawJpg(dataIn, dataInSize, x, y, maxWidth, maxHeight, offX, offY, scale);
                // Print debug string
                debugPrint(MSG_M5LcdDrawJPG);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;

            }
            case M5LcdDrawPng: {
                pngData = dataIn;
                // Draw the PNG image
                M5.Display.drawPng(pngData, payload_size, 130, 50);
                  // Print debug string
                debugPrint(MSG_M5LcdDrawPNG);
                // Send response
                sendResponseMsg(cmdID, 0, 0);
                break;
            }

//----------------------------------------------------------------------------------------------------------------------
// $$$$$$\ $$\      $$\ $$\   $$\ 
// \_$$  _|$$$\    $$$ |$$ |  $$ |
//   $$ |  $$$$\  $$$$ |$$ |  $$ |
//   $$ |  $$\$$\$$ $$ |$$ |  $$ |
//   $$ |  $$ \$$$  $$ |$$ |  $$ |
//   $$ |  $$ |\$  /$$ |$$ |  $$ |
// $$$$$$\ $$ | \_/ $$ |\$$$$$$  |
// \______|\__|     \__| \______/ 
//---------------------------------------------------------------------------------------------------------------------
/*
1.  begin()
2.  update()
3.  getAccel(float* ax, float* ay, float* az)
4.  getGyro(float* gx, float* gy, float* gz)
5.  getMag(float* mx, float* my, float* mz)
6.  getTemp(float* temp)
7.  getAccelAdc(int16_t* ax, int16_t* ay, int16_t* az)
8.  getGyroAdc(int16_t* gx, int16_t* gy, int16_t* gz)
9.  getMagAdc(int16_t* mx, int16_t* my, int16_t* mz)
10. getAccelData(float* ax, float* ay, float* az)
11. getGyroData(float* gx, float* gy, float* gz)
12. getMagData(float* mx, float* my, float* mz)
13. getTempData(float* temp)
14. getAccelOffset(float* ax, float* ay, float* az)
15. getGyroOffset(float* gx, float* gy, float* gz)
16. getMagOffset(float* mx, float* my, float* mz)
17. setAccelOffset(float ax, float ay, float az)
18. setGyroOffset(float gx, float gy, float gz)
19. setMagOffset(float mx, float my, float mz)
20. getAccelScale(float* ax, float* ay, float* az)
21. getGyroScale(float* gx, float* gy, float* gz)
22. getMagScale(float* mx, float* my, float* mz)
23. setAccelScale(float ax, float ay, float az)
24. setGyroScale(float gx, float gy, float gz)
25. setMagScale(float mx, float my, float mz)
26. getType()
27. getOffsetData(int index)
28. loadOffsetFromNVS()
29. saveOffsetToNVS()
*/

//---------------------------------------------------------------------------------------------------------------------
//  $$$$$$$$\  $$$$$$\  $$\   $$\  $$$$$$\  $$\   $$\ 
//  \__$$  __|$$  __$$\ $$ |  $$ |$$  __$$\ $$ |  $$ |
//     $$ |   $$ /  $$ |$$ |  $$ |$$ /  \__|$$ |  $$ |
//     $$ |   $$ |  $$ |$$ |  $$ |$$ |      $$$$$$$$ |
//     $$ |   $$ |  $$ |$$ |  $$ |$$ |      $$  __$$ |
//     $$ |   $$ |  $$ |$$ |  $$ |$$ |  $$\ $$ |  $$ |
//     $$ |    $$$$$$  |\$$$$$$  |\$$$$$$  |$$ |  $$ |
//     \__|    \______/  \______/  \______/ \__|  \__|
//---------------------------------------------------------------------------------------------------------------------                /*
                /*
                // case M5TouchBegin 0x90
                case M5TouchBegin: {
                    //M5.Touch.begin(M5.Lcd);
                    // Print debug string
                    debugPrint(MSG_M5TouchBegin);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5TouchGetCount 0x91
                case M5TouchGetCount: {
                    // Get the number of touches
                    uint16_t count = M5.Touch.getTouchCount();
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&count, 2);
                    break;
                }
                // case M5TouchGetDetail 0x92
                case M5TouchGetDetail: {
                    // Get the touch detail
                    M5.TouchPoint_t touch = M5.Touch.getTouchDetail();
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&touch, sizeof(M5.TouchPoint_t));
                    break;
                }
                */
                /*
                // case M5TouchIsPressed 0x93
                case M5TouchIsPressed: {
                    // Get the touch state
                    bool isPressed = M5.Touch.ispressed();
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&isPressed, 1);
                    break;
                }
                // case M5TouchGetX 0x94
                case M5TouchGetX: {
                    // Get the touch x coordinate
                    uint16_t x = M5.Touch.getX();
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&x, 2);
                    break;
                }
                // case M5TouchGetY 0x95
                case M5TouchGetY: {
                    // Get the touch y coordinate
                    uint16_t y = M5.Touch.getY();
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&y, 2);
                    break;
                }
                // case M5TouchGetRawX 0x96
                case M5TouchGetRawX: {
                    // Get the touch raw x coordinate
                    uint16_t rawX = M5.Touch.getRawX();
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&rawX, 2);
                    break;
                }
                // case M5TouchGetRawY 0x97
                case M5TouchGetRawY: {
                    // Get the touch raw y coordinate
                    uint16_t rawY = M5.Touch.getRawY();
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&rawY, 2);
                    break;
                }
                // case M5TouchGetPressure 0x98
                case M5TouchGetPressure: {
                    // Get the touch pressure
                    uint16_t pressure = M5.Touch.getPressure();
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&pressure, 2);
                    break;
                }
                // case M5TouchGetCount 0x99
                case M5TouchGetCount: {
                    // Get the touch count
                    uint16_t count = M5.Touch.getTouchCount();
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&count, 2);
                    break;
                } */

//---------------------------------------------------------------------------------------------------------------------
// $$$$$$$\ $$$$$$$$\  $$$$$$\  
// $$  __$$\\__$$  __|$$  __$$\ 
// $$ |  $$ |  $$ |   $$ /  \__|
// $$$$$$$  |  $$ |   $$ |      
// $$  __$$<   $$ |   $$ |      
// $$ |  $$ |  $$ |   $$ |  $$\ 
// $$ |  $$ |  $$ |   \$$$$$$  |
// \__|  \__|  \__|    \______/ 
//---------------------------------------------------------------------------------------------------------------------
/*
1. begin(I2C_Class i2c)*
2. getVoltLow()
3. getDateTime(rtc_datetime_t datetime) const*
4. getTime(rtc_time_t time) const*
5. setTime(const rtc_time_t& time)
6. getDate(rtc_date_t date) const*
7. setDate(const rtc_date_t& date)
8. setAlarmIRQ(int afterSeconds)
9. setAlarmIRQ(const rtc_time_t& time)
10. setAlarmIRQ(const rtc_date_t& date, const rtc_time_t& time)
11. getIRQstatus()
12. clearIRQ()
13. disableIRQ()
14. setSystemTimeFromRtc(struct timezone tz)*
*/
//---------------------------------------------------------------------------------------------------------------------                /*
//  $$$$$$$\   $$$$$$\  $$\      $$\ $$$$$$$$\ $$$$$$$\  
//  $$  __$$\ $$  __$$\ $$ | $\  $$ |$$  _____|$$  __$$\ 
//  $$ |  $$ |$$ /  $$ |$$ |$$$\ $$ |$$ |      $$ |  $$ |
//  $$$$$$$  |$$ |  $$ |$$ $$ $$\$$ |$$$$$\    $$$$$$$  |
//  $$  ____/ $$ |  $$ |$$$$  _$$$$ |$$  __|   $$  __$$< 
//  $$ |      $$ |  $$ |$$$  / \$$$ |$$ |      $$ |  $$ |
//  $$ |       $$$$$$  |$$  /   \$$ |$$$$$$$$\ $$ |  $$ |
//  \__|       \______/ \__/     \__|\________|\__|  \__|
//---------------------------------------------------------------------------------------------------------------------                /*
                // case M5PowerBegin //1
                case M5PwrBegin: {
                    M5.Power.begin();
                    // Print debug string
                    debugPrint(MSG_M5PwrBegin);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5PowerSetExtPwr //2
                case M5PwrSetExtPwr: {
                    // Set external power state from dataIn
                    bool enable = dataIn[0];
                    m5::ext_port_mask_t portMask = static_cast<m5::ext_port_mask_t>(dataIn[1]);
                    //M5.Power.setExtOutput(enable, portMask);
                    M5.Power.setExtOutput(enable);
                    // Print debug string
                    debugPrint(MSG_M5PwrSetExtPwr);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5PowerGetExtOut //3
                case M5PwrGetExtOut: {
                    // Get external power state
                    bool extPowerState = M5.Power.getExtOutput();
                    // Print debug string
                    debugPrint(MSG_M5PwrGetExtOut);
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&extPowerState, 1);
                    break;
                }
                // case M5PowerLED //6
                case M5PwrSetLED: {
                    // Extract the brightness from dataIn
                    uint8_t brightness = dataIn[0];
                    // Set brightness 0-255 from dataIn
                    M5.Power.setLed(brightness);
                    // Print debug string
                    debugPrint(MSG_M5PwrSetLED);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5PowerOff //7
                case M5PwrOff: {
                    // Print debug string
                    debugPrint(MSG_M5PwrOff);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    // Wait
                    M5.delay(500);
                    // Power off the device
                    M5.Power.powerOff();
                    break;
                }             
                // Case getBatteryLevel //11
                case M5PwrGetBatteryLvl: {
                    // Get the battery level
                    int32_t batteryLevel = M5.Power.getBatteryLevel();
                    // Print debug string
                    debugPrint(MSG_M5PwrGetBatteryLvl);
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&batteryLevel, 4);
                    break;
                }
                // case setBatteryCharge //12
                case M5PwrSetBatteryChg: {
                    // Extract the charge state from dataIn
                    uint8_t chargeState = dataIn[0];
                    // Set the battery charge state
                    M5.Power.setBatteryCharge(chargeState);
                    // Print debug string
                    debugPrint(MSG_M5PwrSetBatteryChg);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case setChargeCurrent //13
                case M5PwrSetChargeCurr: {
                    // Extract the charge current from dataIn
                    uint16_t max_mA = (dataIn[0] << 8) | dataIn[1];
                    // Set the charge current
                    M5.Power.setChargeCurrent(max_mA);
                    // Print debug string
                    debugPrint(MSG_M5PwrSetChargeCurr);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case setChargeVoltage //14
                case M5PwrSetChargeVolt: {
                    // Extract the charge voltage from dataIn
                    uint16_t max_mV = (dataIn[0] << 8) | dataIn[1];
                    // Set the charge voltage
                    M5.Power.setChargeVoltage(max_mV);
                    // Print debug string
                    debugPrint(MSG_M5PwrSetChargeVolt);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case isCharging //15
                case M5PwrIsCharging: {
                    // Get the charging state
                    bool isCharging = M5.Power.isCharging();
                    // Print debug string
                    debugPrint(MSG_M5PwrIsCharging);
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&isCharging, 1);
                    break;
                }
                // case getBatteryVoltage //16
                case M5PwrGetBatteryVolt: {
                    // Get the battery voltage
                    uint16_t batteryVoltage = M5.Power.getBatteryVoltage();
                    // Print debug string
                    debugPrint(MSG_M5PwrGetBatteryVolt);
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&batteryVoltage, 2);
                    break;
                }
                // case getBatteryChargeCurrent //17
                case M5PwrGetBatteryCurr: {
                    // Get the battery charge current
                    int32_t chargeCurrent = M5.Power.getBatteryCurrent();
                    // Print debug string
                    debugPrint(MSG_M5PwrGetBatteryCurr);
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&chargeCurrent, 4);
                    break;
                }
                // case getPwrBtnState //18
                case M5PwrGetKeyState: {
                    // Get the power key state
                    /// @return 0=none / 1=long pressed / 2=short clicked / 3=both
                    uint8_t pwrKeyState = M5.Power.getKeyState();
                    // Print debug string
                    debugPrint(MSG_M5PwrGetKeyState);
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&pwrKeyState, 1);
                    break;
                }   
                // case M5vibrationMotr //19
                    case M5PwrSetVibration: {
                    // Extract the duration and intensity from dataIn
                    uint8_t intensity = dataIn[0];
                    // Vibrate the motor
                    M5.Power.setVibration(intensity);
                    // Print debug string
                    debugPrint(MSG_M5PwrSetVibration);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5PowerType //20
                case M5PwrGetType: {
                    // Get the power type
                    uint8_t powerICType = M5.Power.getType();
                    // Print debug string
                    debugPrint(MSG_M5PwrGetType);
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&powerICType, 1);
                    break;
                }                
//---------------------------------------------------------------------------------------------------------------------
//  $$$$$$$\  $$\   $$\ $$$$$$$$\ $$$$$$$$\  $$$$$$\  $$\   $$\ 
//  $$  __$$\ $$ |  $$ |\__$$  __|\__$$  __|$$  __$$\ $$$\  $$ |
//  $$ |  $$ |$$ |  $$ |   $$ |      $$ |   $$ /  $$ |$$$$\ $$ |
//  $$$$$$$\ |$$ |  $$ |   $$ |      $$ |   $$ |  $$ |$$ $$\$$ |
//  $$  __$$\ $$ |  $$ |   $$ |      $$ |   $$ |  $$ |$$ \$$$$ |
//  $$ |  $$ |$$ |  $$ |   $$ |      $$ |   $$ |  $$ |$$ |\$$$ |
//  $$$$$$$  |\$$$$$$  |   $$ |      $$ |    $$$$$$  |$$ | \$$ |
//  \_______/  \______/    \__|      \__|    \______/ \__|  \__|
//---------------------------------------------------------------------------------------------------------------------                /*
                // case M5ButtonUpdate 0xA0
                case M5ButtonUpdate: {
                    M5.delay(1); //1ms delay was in the example so I left it for now
                    // Update the button states
                    M5.update(); //also added to void loop
                    /// BtnPWR: "wasClicked"/"wasHold"  can be use.
                    /// BtnPWR of CoreInk: "isPressed"/"wasPressed"/"isReleased"/"wasReleased"/"wasClicked"/"wasHold"/"isHolding"  can be use.
                    uint8_t BPstate = M5.BtnPWR.wasHold() ? 1
                                : M5.BtnPWR.wasClicked() ? 2
                                : M5.BtnPWR.wasPressed() ? 3
                                : M5.BtnPWR.wasReleased() ? 4
                                : M5.BtnPWR.wasDecideClickCount() ? 5
                                : 0;
                    /// BtnA,BtnB,BtnC,BtnEXT: "isPressed"/"wasPressed"/"isReleased"/"wasReleased"/"wasClicked"/"wasHold"/"isHolding"  can be use.
                    uint8_t BAstate = M5.BtnA.wasHold() ? 1
                            : M5.BtnA.wasClicked() ? 2
                            : M5.BtnA.wasPressed() ? 3
                            : M5.BtnA.wasReleased() ? 4
                            : M5.BtnA.wasDecideClickCount() ? 5
                            : 0;
                 // uint8_t BAclickCount = M5.BtnA.getClickCount();
                    uint8_t BBstate = M5.BtnB.wasHold() ? 1
                            : M5.BtnB.wasClicked() ? 2
                            : M5.BtnB.wasPressed() ? 3
                            : M5.BtnB.wasReleased() ? 4
                            : M5.BtnB.wasDecideClickCount() ? 5
                            : 0;
                    uint8_t BCstate = M5.BtnC.wasHold() ? 1
                            : M5.BtnC.wasClicked() ? 2
                            : M5.BtnC.wasPressed() ? 3
                            : M5.BtnC.wasReleased() ? 4
                            : M5.BtnC.wasDecideClickCount() ? 5
                            : 0;
                    uint8_t BXstate = M5.BtnEXT.wasHold() ? 1
                            : M5.BtnEXT.wasClicked() ? 2
                            : M5.BtnEXT.wasPressed() ? 3
                            : M5.BtnEXT.wasReleased() ? 4
                            : M5.BtnEXT.wasDecideClickCount() ? 5
                            : 0;
                            // join all the button states
                    uint32_t buttonStates = (BPstate << 24) | (BAstate << 16) | (BBstate << 8) | BCstate;
                    // Print debug string
                    debugPrint(MSG_M5ButtonUpdate);  
                    // Send response
                    sendResponseMsg(cmdID, (byte*)&buttonStates, 4);
                    break;
                    }
//---------------------------------------------------------------------------------------------------------------------
//  $$$$$$\  $$$$$$$\  $$$$$$$$\  $$$$$$\  $$\   $$\ $$$$$$$$\ $$$$$$$\  
// $$  __$$\ $$  __$$\ $$  _____|$$  __$$\ $$ | $$  |$$  _____|$$  __$$\ 
// $$ /  \__|$$ |  $$ |$$ |      $$ /  $$ |$$ |$$  / $$ |      $$ |  $$ |
// \$$$$$$\  $$$$$$$  |$$$$$\    $$$$$$$$ |$$$$$  /  $$$$$\    $$$$$$$  |
//  \____$$\ $$  ____/ $$  __|   $$  __$$ |$$  $$<   $$  __|   $$  __$$< 
// $$\   $$ |$$ |      $$ |      $$ |  $$ |$$ |\$$\  $$ |      $$ |  $$ |
// \$$$$$$  |$$ |      $$$$$$$$\ $$ |  $$ |$$ | \$$\ $$$$$$$$\ $$ |  $$ |
//  \______/ \__|      \________|\__|  \__|\__|  \__|\________|\__|  \__|
//---------------------------------------------------------------------------------------------------------------------
            // case SpeakerBegin          0xB0                                            
                case SpeakerBegin: {
                    M5.Speaker.begin();
                    // Print debug string
                    debugPrint(MSG_SpeakerBegin);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
            // case SpeakerStop          0xB1 
                case SpeakerStop: {
                    M5.Speaker.stop();
                    // Print debug string
                    debugPrint(MSG_SpeakerStop);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }            
            // case SpeakerTone           0xB2
                case SpeakerTone: {
                   /* Play simple tone sound
                    * M5Unified Definition:
                     * tone(float frequency, uint32_t duration = UINT32_MAX, 
                     * int channel = -1, bool stop_current_sound = true)
                    * Matlab dataIn structure:
                     * dataIn(1) = chnlBytes;
                     * dataIn(2) = stopCurSndBytes;
                     * dataIn(3:18) = freqBytes; //hex as char
                     * dataIn(19:34) = durBytes; //hex as char
                    */

                    uint8_t channel = dataIn[0];
                    uint8_t stop_current_sound = dataIn[1];

                    std::string hexFreq;
                    std::string hexDur;
                    int sizeOfDataIn = 34;

                    // Iterate through data in
                    for (int i = 2; i < sizeOfDataIn-16; ++i) {
                        // Convert unicode value to character and concatenate to the string
                        hexFreq += static_cast<char>(dataIn[i]);
                        hexDur += static_cast<char>(dataIn[i+16]);
                    }

                    double frequency;
                    double duration;

                    try{
                        *reinterpret_cast<unsigned long long*>(&frequency) = std::stoull(hexFreq, nullptr, 16);
                        *reinterpret_cast<unsigned long long*>(&duration) = std::stoull(hexDur, nullptr, 16);
                    }
                    catch(...){}

                    M5.Speaker.tone(frequency, duration, channel, stop_current_sound);
                    
                    // Print debug string
                    debugPrint(MSG_SpeakerTone);
                    // Send response
                    sendResponseMsg(cmdID, 0,0);
                    break;
                }
            // case SpeakerSetVolume           0xB3
                case SpeakerSetVolume: {
                    uint8_t volume = dataIn[0]; //volume to set speaker at

                    M5.Speaker.setVolume(volume);
                    
                    // Print debug string
                    debugPrint(MSG_SpeakerSetVolume);
                    // Send response
                    sendResponseMsg(cmdID, 0,0);
                    break;
                } 
           
            // case SpeakerGetVolume           0xB5
                case SpeakerGetVolume: {
                    uint8_t v = M5.Speaker.getVolume();
                    byte* response = reinterpret_cast<byte*>(&v);

                    // Print debug string
                    debugPrint(MSG_SpeakerGetVolume);
                    // Send response
                    sendResponseMsg(cmdID, response, 1);
                    break;
                } 

            // case SpeakerPlayRaw           0xB7
                case SpeakerPlayRaw: {
                    // TODO

                    // M5.Speaker.playWav(const uint8_t* wav_data, size_t data_len, uint32_t repeat, int channel, bool stop_current_sound)
                    
                    // Print debug string
                    debugPrint(MSG_SpeakerSetVolume);
                    // Send response
                    sendResponseMsg(cmdID, 0,0);
                    break;
                } 

//---------------------------------------------------------------------------------------------------------------------
// $$\      $$\ $$$$$$\  $$$$$$\  
// $$$\    $$$ |\_$$  _|$$  __$$\ 
// $$$$\  $$$$ |  $$ |  $$ /  \__|
// $$\$$\$$ $$ |  $$ |  $$ |      
// $$ \$$$  $$ |  $$ |  $$ |      
// $$ |\$  /$$ |  $$ |  $$ |  $$\ 
// $$ | \_/ $$ |$$$$$$\ \$$$$$$  |
// \__|     \__|\______| \______/ 
//---------------------------------------------------------------------------------------------------------------------
// case MicConfig 0xC0
case MicConfig: {
    auto cfg = M5.Mic.config();
    // Extract the sample rate from dataIn
    uint16_t sampleRate = (dataIn[0] << 8) | dataIn[1];
    cfg.sample_rate = sampleRate;
    // Configure the microphone
    M5.Mic.config();
    // Print debug string
    debugPrint(MSG_MicConfig);
    // Send response
    sendResponseMsg(cmdID, 0, 0);
    break;
}
// case MicBegin 0xC1
case MicBegin: {
    M5.Mic.begin();
    // Print debug string
    debugPrint(MSG_MicBegin);
    // Send response
    sendResponseMsg(cmdID, 0, 0);
    break;
}
// case MicEnd 0xC2
case MicEnd: {
    M5.Mic.end();
    // Print debug string
    debugPrint(MSG_MicEnd);
    // Send response
    sendResponseMsg(cmdID, 0, 0);
    break;
}
// case MicSetSampleRate 0xC6
case MicSetSampleRate: {
    // Extract the sample rate from dataIn
    uint16_t sampleRate = (dataIn[0] << 8) | dataIn[1];
    // Set the sample rate
    M5.Mic.setSampleRate(sampleRate);
    // Print debug string
    debugPrint(MSG_MicSetSampleRate);
    // Send response
    sendResponseMsg(cmdID, 0, 0);
    break;
}
// case MicRecord 0xC7
/*Example
if (M5.Mic.isEnabled())
  {
    static constexpr int shift = 6;
    auto data = &rec_data[rec_record_idx * record_length];
    if (M5.Mic.record(data, record_length, record_samplerate))
    {
      data = &rec_data[draw_record_idx * record_length];

      int32_t w = M5.Display.width();
      if (w > record_length - 1) { w = record_length - 1; }
      for (int32_t x = 0; x < w; ++x)
      {
        M5.Display.writeFastVLine(x, prev_y[x], prev_h[x], TFT_BLACK);
        int32_t y1 = (data[x    ] >> shift);
        int32_t y2 = (data[x + 1] >> shift);
        if (y1 > y2)
        {
          int32_t tmp = y1;
          y1 = y2;
          y2 = tmp;
        }
        int32_t y = (M5.Display.height() >> 1) + y1;
        int32_t h = (M5.Display.height() >> 1) + y2 + 1 - y;
        prev_y[x] = y;
        prev_h[x] = h;
        M5.Display.writeFastVLine(x, y, h, TFT_WHITE);
      }
      M5.Display.display();

      if (++draw_record_idx >= record_number) { draw_record_idx = 0; }
      if (++rec_record_idx >= record_number) { rec_record_idx = 0; }
    }
  }
*/
case MicRecord: {
    //M5.Mic.record();
    if (M5.Mic.isEnabled())
  {
    static constexpr int shift = 6;
    auto data = &rec_data[rec_record_idx * record_length];
    byte* byteData;
    if (M5.Mic.record(data, record_length, record_samplerate))
    {
      data = &rec_data[draw_record_idx * record_length];
      byte* byteData = reinterpret_cast<byte*>(data);
    }
    // Print debug string
    debugPrint(MSG_MicRecord);
    // Send response
    sendResponseMsg(cmdID, byteData, sizeof(byteData));
  } else
      {   
    // Print debug string
    debugPrint(MSG_MicRecErr);
    // Send response
    sendResponseMsg(cmdID, 0, 0);
    }
    break;
}    
// PSRAM Commands
//---------------------------------------------------------------------------------------------------------------------
// $$$$$$$\   $$$$$$\  $$$$$$$\   $$$$$$\  $$\      $$\ 
// $$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$$\    $$$ |
// $$ |  $$ |$$ /  \__|$$ |  $$ |$$ /  $$ |$$$$\  $$$$ |
// $$$$$$$  |\$$$$$$\  $$$$$$$  |$$$$$$$$ |$$\$$\$$ $$ |
// $$  ____/  \____$$\ $$  __$$< $$  __$$ |$$ \$$$  $$ |
// $$ |      $$\   $$ |$$ |  $$ |$$ |  $$ |$$ |\$  /$$ |
// $$ |      \$$$$$$  |$$ |  $$ |$$ |  $$ |$$ | \_/ $$ |
// \__|       \______/ \__|  \__|\__|  \__|\__|     \__|
//---------------------------------------------------------------------------------------------------------------------
               /*
                // case M5PsramBegin 0xD0
                case M5PsramBegin: {
                    //M5.Psram.begin();
                    // Print debug string
                    debugPrint(MSG_M5PsramBegin);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5PsramWriteByte 0xD1
                case M5PsramWriteByte: {
                    // Extract the address and byte from dataIn
                    uint32_t address = (dataIn[0] << 24) | (dataIn[1] << 16) | (dataIn[2] << 8) | dataIn[3];
                    byte byte = dataIn[4];
                    // Write the byte
                    M5.Psram.writeByte(address, byte);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5PsramReadByte 0xD2
                case M5PsramReadByte: {
                    // Extract the address from dataIn
                    uint32_t address = (dataIn[0] << 24) | (dataIn[1] << 16) | (dataIn[2] << 8) | dataIn[3];
                    // Read the byte
                    byte byte = M5.Psram.readByte(address);
                    // Send response
                    sendResponseMsg(cmdID, &byte, 1);
                    break;
                }
                // case M5PsramWriteBytes 0xD3
                case M5PsramWriteBytes: {
                    // Extract the address and length from dataIn
                    uint32_t address = (dataIn[0] << 24) | (dataIn[1] << 16) | (dataIn[2] << 8) | dataIn[3];
                    uint16_t length = (dataIn[4] << 8) | dataIn[5];
                    // Write the bytes
                    M5.Psram.writeBytes(address, dataIn + 6, length);
                    // Send response
                    sendResponseMsg(cmdID, 0, 0);
                    break;
                }
                // case M5PsramReadBytes 0xD4
                case M5PsramReadBytes: {

*/       
//---------------------------------------------------------------------------------------------------------------------
//               $$\                                 $$$$$$\  $$$$$$$\  
//               \__|                               $$  __$$\ $$  __$$\ 
// $$$$$$\$$$$\  $$\  $$$$$$$\  $$$$$$\   $$$$$$\   $$ /  \__|$$ |  $$ |
// $$  _$$  _$$\ $$ |$$  _____|$$  __$$\ $$  __$$\  \$$$$$$\  $$ |  $$ |
// $$ / $$ / $$ |$$ |$$ /      $$ |  \__|$$ /  $$ |  \____$$\ $$ |  $$ |
// $$ | $$ | $$ |$$ |$$ |      $$ |      $$ |  $$ | $$\   $$ |$$ |  $$ |
// $$ | $$ | $$ |$$ |\$$$$$$$\ $$ |      \$$$$$$  | \$$$$$$  |$$$$$$$  |
// \__| \__| \__|\__| \_______|\__|       \______/   \______/ \_______/ 
//---------------------------------------------------------------------------------------------------------------------

            default: {
                // Print debug string
                debugPrint(MSG_M5UNKNOWN_CMD,cmdID);
                break;
            }
        }
    }
};
