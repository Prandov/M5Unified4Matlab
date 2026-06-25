/**
 * @file M5UnifiedML.h
 *
 * Curated LCD milestone header for version 0.2.
 */

#include "LibraryBase.h"
#include "M5Unified.h"

// Command ID's
#define M5Begin             0x01
#define M5BoardType         0x02
#define M5LcdBegin          0x20
#define M5LcdClear          0x21
#define M5LcdPrt            0x31
#define M5LcdPrtLn          0x32
#define M5LcdDrawString     0x33
#define M5LcdTextColor      0x34
#define M5LcdTextDatum      0x35
#define M5LcdTextSize       0x36
#define M5LcdTextFont       0x37
#define M5LcdSetCursor      0x38
#define M5LcdDrawLine       0x39
#define M5LcdDrawRect       0x3C
#define M5LcdFillRect       0x3D

const char MSG_M5Begin[]            PROGMEM = "M5 Begin\n";
const char MSG_GetBrdType[]         PROGMEM = "M5 GetBoardType\n";
const char MSG_M5LcdBegin[]         PROGMEM = "M5 Display Begin\n";
const char MSG_M5LcdClear[]         PROGMEM = "M5.Display.clear();\n";
const char MSG_M5LcdPrt[]           PROGMEM = "M5 Display: Print\n";
const char MSG_M5LcdPrtLine[]       PROGMEM = "M5 Display: PrintLine\n";
const char MSG_M5LcdDrawString[]    PROGMEM = "M5 Display: Draw String\n";
const char MSG_M5LcdTextColor[]     PROGMEM = "M5 Display: Text Color\n";
const char MSG_M5LcdTextDatum[]     PROGMEM = "M5 Display: Text Datum\n";
const char MSG_M5LcdTextSize[]      PROGMEM = "M5 Display: Text Size\n";
const char MSG_M5LcdTextFont[]      PROGMEM = "M5 Display: Text Font\n";
const char MSG_M5LcdSetCursor[]     PROGMEM = "M5 Display: Set Cursor\n";
const char MSG_M5LcdDrawLine[]      PROGMEM = "M5 Display: Draw Line\n";
const char MSG_M5LcdDrawRect[]      PROGMEM = "M5 Display: Draw Rect\n";
const char MSG_M5LcdFillRect[]      PROGMEM = "M5 Display: Fill Rect\n";
const char MSG_UNKNOWN_CMD[]        PROGMEM = "M5[%d]->Unknown Command\n";

class M5UnifiedML : public LibraryBase
{
    public:
        M5UnifiedML(MWArduinoClass& a)
    {
        libName = "M5Stack/M5Unified";
        a.registerLibrary(this);
    }

public:
    void commandHandler(byte cmdID, byte* dataIn, unsigned int payload_size)
    {
        switch (cmdID){
            case M5Begin:{
                M5.begin();
                debugPrint(MSG_M5Begin);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5BoardType: {
                uint8_t boardType = M5.getBoard();
                byte* response = reinterpret_cast<byte*>(&boardType);
                debugPrint(MSG_GetBrdType);
                sendResponseMsg(cmdID, response, 1);
                break;
            }
            case M5LcdBegin: {
                M5.Display.begin();
                debugPrint(MSG_M5LcdBegin);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdClear: {
                M5.Display.clear();
                debugPrint(MSG_M5LcdClear);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdPrt: {
                char* text = reinterpret_cast<char*>(dataIn);
                text[payload_size] = '\0';
                M5.Display.print(text);
                debugPrint(MSG_M5LcdPrt);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdPrtLn: {
                char* text = reinterpret_cast<char*>(dataIn);
                text[payload_size] = '\0';
                M5.Display.println(text);
                debugPrint(MSG_M5LcdPrtLine);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdDrawString: {
                uint16_t x = (dataIn[0] << 8) | dataIn[1];
                uint16_t y = (dataIn[2] << 8) | dataIn[3];
                char* text = reinterpret_cast<char*>(dataIn + 4);
                M5.Display.drawString(text, x, y);
                debugPrint(MSG_M5LcdDrawString);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdTextColor: {
                uint16_t textColor = (dataIn[0] << 8) | dataIn[1];
                if (payload_size == 2) {
                    M5.Display.setTextColor(textColor);
                } else if (payload_size == 4 ) {
                    uint16_t bgColor = (dataIn[2] << 8) | dataIn[3];
                    M5.Display.setTextColor(textColor, bgColor);
                }
                debugPrint(MSG_M5LcdTextColor);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdTextDatum: {
                uint16_t datum = (dataIn[0] << 8) | dataIn[1];
                M5.Display.setTextDatum(datum);
                debugPrint(MSG_M5LcdTextDatum);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdTextSize: {
                uint16_t size = dataIn[0];
                M5.Display.setTextSize(size);
                debugPrint(MSG_M5LcdTextSize);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdTextFont: {
                uint16_t font = dataIn[0];
                M5.Display.setTextFont(font);
                debugPrint(MSG_M5LcdTextFont);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdSetCursor: {
                uint16_t x = (dataIn[0] << 8) | dataIn[1];
                uint16_t y = (dataIn[2] << 8) | dataIn[3];
                M5.Display.setCursor(x, y);
                debugPrint(MSG_M5LcdSetCursor);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdDrawLine: {
                uint16_t x1 = (dataIn[0] << 8) | dataIn[1];
                uint16_t y1 = (dataIn[2] << 8) | dataIn[3];
                uint16_t x2 = (dataIn[4] << 8) | dataIn[5];
                uint16_t y2 = (dataIn[6] << 8) | dataIn[7];
                uint16_t color = (dataIn[8] << 8) | dataIn[9];
                M5.Display.drawLine(x1, y1, x2, y2, color);
                debugPrint(MSG_M5LcdDrawLine);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdDrawRect: {
                uint16_t x = (dataIn[0] << 8) | dataIn[1];
                uint16_t y = (dataIn[2] << 8) | dataIn[3];
                uint16_t w = (dataIn[4] << 8) | dataIn[5];
                uint16_t h = (dataIn[6] << 8) | dataIn[7];
                uint16_t color = (dataIn[8] << 8) | dataIn[9];
                M5.Display.drawRect(x, y, w, h, color);
                debugPrint(MSG_M5LcdDrawRect);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            case M5LcdFillRect: {
                uint16_t x = (dataIn[0] << 8) | dataIn[1];
                uint16_t y = (dataIn[2] << 8) | dataIn[3];
                uint16_t w = (dataIn[4] << 8) | dataIn[5];
                uint16_t h = (dataIn[6] << 8) | dataIn[7];
                uint16_t color = (dataIn[8] << 8) | dataIn[9];
                M5.Display.fillRect(x, y, w, h, color);
                debugPrint(MSG_M5LcdFillRect);
                sendResponseMsg(cmdID, 0, 0);
                break;
            }
            default:
                debugPrint(MSG_UNKNOWN_CMD);
                sendResponseMsg(cmdID, 0, 0);
                break;
        }
    }
};
