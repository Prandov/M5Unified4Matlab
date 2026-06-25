%% ExampleM5Chessboard.m
% ==================================================================================================
% By: Eric Prandovszky
% prandov@yorku.ca
% June 3, 2024
% Create a chessboard pattern on the M5Stack using the M5Unified Library. 
% Also display the pattern in a MATLAB figure.
% ==================================================================================================

% Sample RGB565 colours (16-bit Colour)
    TFT_BLACK       = 0x0000;
    TFT_RED         = 0xF800;
    TFT_GREEN       = 0x07E0; 
    TFT_BLUE        = 0x001F;
    TFT_LIGHTGRAY   = 0xD69A;
    TFT_DARKGRAY    = 0x7BEF;
    TFT_CYAN        = 0x07FF;
    TFT_MAGENTA     = 0xF81F;
    TFT_YELLOW      = 0xFFE0;
% Set the Colour:
    rgb565 = TFT_GREEN;

% Set display height and width:
    displayWidth = 320;
    displayHeight = 240;
    boardSize = 8; %Standard chessboard is 8x8.

% Calculate the size in pixels of each square of the chessboard
    squareSize = min(displayHeight, displayWidth) / boardSize;

% Convert RGB565 to RGB888 (24-bit Colour) for display in MATLAB
    r = uint8(bitshift(bitand(rgb565, 63488), -8)*8); % Extract and scale red component.
    g = uint8(bitshift(bitand(rgb565, 2016), -5)*4);  % Extract and scale green component.
    b = uint8(bitand(rgb565, 31) * 8);              % Extract and scale blue component.
    rgb888 = cat(3, r, g, b);

%Preallocate memory for displaying the board in MATLAB
    display = zeros(displayHeight, displayWidth,3,'uint8');

% Calculate the starting position of the chessboard
    startX = floor((displayWidth - boardSize * squareSize) / 2);
    startY = floor((displayHeight - boardSize * squareSize) / 2);
% Clear the LCD
    m5u.lcdClear;
% Create the chessboard pattern
    for i = 1:boardSize
        for j = 1:boardSize
            if mod(i+j, 2) == 0
                for c = 1:3 % copy each colour channel individually.
                display(startY+(i-1)*squareSize+1:startY+i*squareSize, startX+(j-1)*squareSize+1:startX+j*squareSize,c) = rgb888(c);
                end
                Xp = startX+(j-1)*squareSize;
                Yp = startY+(i-1)*squareSize;
                m5u.lcdDrawFillRect(Xp,Yp,squareSize,squareSize,rgb565)
            end
        end
    end

% Display the chessboard in a MATLAB figure window
    imshow(display);
