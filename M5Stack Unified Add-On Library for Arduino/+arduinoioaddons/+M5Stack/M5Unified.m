%% Custom Arduino Add-On Library for the M5Unified Library by M5Stack
% Version: 0.2
% Curated LCD milestone MATLAB wrapper.

classdef M5Unified < matlabshared.addon.LibraryBase & matlab.mixin.CustomDisplay
    properties(Access = private, Constant = true)
        M5Begin              = hex2dec('01')
        M5BoardType          = hex2dec('02')
        M5LcdBegin           = hex2dec('20')
        M5LcdClear           = hex2dec('21')
        M5LcdPrt             = hex2dec('31')
        M5LcdPrtLn           = hex2dec('32')
        M5LcdDrawString      = hex2dec('33')
        M5LcdTextColor       = hex2dec('34')
        M5LcdTextDatum       = hex2dec('35')
        M5LcdTextSize        = hex2dec('36')
        M5LcdTextFont        = hex2dec('37')
        M5LcdSetCursor       = hex2dec('38')
        M5LcdDrawLine        = hex2dec('39')
        M5LcdDrawRect        = hex2dec('3C')
        M5LcdFillRect        = hex2dec('3D')
    end

    properties(Access = protected, Constant = true)
        LibraryName = 'M5Stack/M5Unified'
        DependentLibraries = {}
        LibraryHeaderFiles = {'M5Unified/src/M5Unified.h'}
        CppHeaderFile = fullfile(arduinoio.FilePath(mfilename('fullpath')), 'src', 'M5UnifiedML.h')
        CppClassName = 'M5UnifiedML'
    end

    properties(Access = private)
        ResourceOwner = 'M5Stack/M5Unified';
    end

    methods(Hidden, Access = public)
        function obj = M5Unified(parentObj)
            obj.Parent = parentObj;
        end
    end

    methods(Access = public)
        function begin(obj)
            sendCommand(obj, obj.LibraryName, obj.M5Begin, 0x00);
        end

        function getBoardType(obj)
            sendCommand(obj, obj.LibraryName, obj.M5BoardType, 0x00);
        end

        function lcdBegin(obj)
            sendCommand(obj, obj.LibraryName, obj.M5LcdBegin, 0x00);
        end

        function lcdClear(obj)
            sendCommand(obj, obj.LibraryName, obj.M5LcdClear, 0x00);
        end

        function lcdPrint(obj, string)
            sendCommand(obj, obj.LibraryName, obj.M5LcdPrt, uint8(char(string)));
        end

        function lcdPrintLn(obj, string)
            sendCommand(obj, obj.LibraryName, obj.M5LcdPrtLn, uint8(char(string)));
        end

        function lcdDrawStr(obj, x, y, string)
            xybytes = typecast(swapbytes([uint16(x), uint16(y)]), 'uint8');
            text = uint8(char(string));
            sendCommand(obj, obj.LibraryName, obj.M5LcdDrawString, [xybytes, text]);
        end

        function lcdTextColor(obj, varargin)
            if nargin == 2
                dataIn = typecast(swapbytes(uint16(varargin{1})), 'uint8');
            else
                dataIn = typecast(swapbytes(uint16([varargin{1}, varargin{2}])), 'uint8');
            end
            sendCommand(obj, obj.LibraryName, obj.M5LcdTextColor, dataIn);
        end

        function lcdTextDatum(obj, datum)
            sendCommand(obj, obj.LibraryName, obj.M5LcdTextDatum, typecast(swapbytes(uint16(datum)), 'uint8'));
        end

        function lcdTextSize(obj, size)
            sendCommand(obj, obj.LibraryName, obj.M5LcdTextSize, uint8(size));
        end

        function lcdFont(obj, font)
            sendCommand(obj, obj.LibraryName, obj.M5LcdTextFont, uint8(font));
        end

        function lcdCursor(obj, xPos, yPos)
            xyData = typecast(swapbytes([uint16(xPos), uint16(yPos)]), 'uint8');
            sendCommand(obj, obj.LibraryName, obj.M5LcdSetCursor, xyData);
        end

        function lcdDrawLine(obj, x1, y1, x2, y2, color)
            dataIn = typecast(swapbytes([uint16(x1), uint16(y1), uint16(x2), uint16(y2), uint16(color)]), 'uint8');
            sendCommand(obj, obj.LibraryName, obj.M5LcdDrawLine, dataIn);
        end

        function lcdDrawRect(obj, x, y, width, height, color)
            dataIn = typecast(swapbytes([uint16(x), uint16(y), uint16(width), uint16(height), uint16(color)]), 'uint8');
            sendCommand(obj, obj.LibraryName, obj.M5LcdDrawRect, dataIn);
        end

        function lcdFillRect(obj, x, y, width, height, color)
            dataIn = typecast(swapbytes([uint16(x), uint16(y), uint16(width), uint16(height), uint16(color)]), 'uint8');
            sendCommand(obj, obj.LibraryName, obj.M5LcdFillRect, dataIn);
        end
    end
end
