%% patchArduinoUtilityV3.m
% ==================================================================================================
% This patch will modify arduinoio.internal.Utility to fix an ArduinoServer compilation error that  
% sometimes occurs when custom add-on libraries like 'NeoPixel' are included. The error is the 
% custom library header file cannot find it's dependency 'LibraryBase.h'. I've noticed this with 
% ESP32 based M5Stack when trying to program in MATLAB 24.1 for Windows 11 & Arduino Support 24.1. 
% This may be a path length issue.
% V1 Modifies Utility.m. The Function 'generateAddonLibrariesHeader' now moves the additional header
% files directly into the ArduinoServer temp directory instead of referencing their much longer path.
% V2 Separates into functions commentOutLines() and insertLines()
% V2.1 Tries to directly install esp32 board support without running arduinosetup instead of 
% throwing an error. 
% V2.2 Suppresses the boot button dialog for ESP32 when it detects M5Unified libraries are included 
% in the server.
% V2.3 Update how the arduino sketch file is named by reading the parent directory name.
% V2.4 Due to it's size, trigger verbose output during install of esp32 support for user feedback.
% V3 Expands M5Unified library detection from V2.2 to also modify the board ID, which adjusts the 
% default partition size.
% V3.1 Add file header comments to the modified file. Remove any variables created by this script
% Version 3.1
% By: Eric Prandovszky
% prandov@yorku.ca
% September 23 ,2026
% Updated: November 3, 2026
% ==================================================================================================
function patchArduinoUtilityV3(filePath)
% Optional filePath supports testing on a disposable copy of Utility.m.
disp(['Running: ' mfilename '.m'])
% Define the path to the file
if nargin < 1
    filePath = which('arduinoio.internal.Utility');
end
    % Stop with a clear installation error before reading a missing Utility.m.
    if isempty(filePath)
        error('M5Stack:UtilityMissing', 'Install the MATLAB Support Package for Arduino Hardware first.');
    end
    [folderPath, fileName, extension] = fileparts(filePath);
    fprintf(' -Attempting to update %s\n',[fileName extension]);
    backupFileName = [fileName,'OriginalUnpatched.m'];
    backupPath = fullfile(folderPath, backupFileName);
    % Reuse the backup for this support-package release, or preserve Utility.m once.
    sourcePath = backupPath;
    if ~isfile(backupPath)
        sourcePath = filePath;
    end
    backupFileContents = fileread(sourcePath);
    if contains(backupFileContents, '% OLD ') || contains(backupFileContents, 'patched using')
        error('M5Stack:OriginalUtilityRequired', ...
            '%s is already patched. Supply the original for this support-package release.', sourcePath);
    end
    createdBackup = false;
    if ~isfile(backupPath)
        [status, message] = movefile(filePath, backupPath, 'f');
        if ~status
            error('M5Stack:UtilityBackupFailed', 'Cannot rename Utility.m to %s: %s', backupPath, message);
        end
        createdBackup = true;
    end
try
    % Save a clean Utility.m before attempting any modifications, including on repeat runs.
    writeUtilityFile(filePath, backupFileContents);
    fprintf(' -Unmodified Utility.m saved from %s.\n', backupFileName);
    patchMarker = '% M5Unified Utility patch for add-on 0.5.1';
    newFileContents = backupFileContents; %Make a copy to compare output
%% Lines to comment out
% Lines need to be unique within the file to prevent unintended changes.
    oldLines = {...
        'headerFile = strrep(headerFile, ''\'', ''\\'');', ...                       % B) modify how Add-ons are included
        'contents = strcat(contents, [''#include "'', headerFile, ''"\n'']);',...    % B) modify how Add-ons are included
        'matlabshared.hwsdk.internal.localizedError(''MATLAB:arduinoio:general:thirdpartyLibNotInstalled'',''ESP32'');',...     % C) Automate arduino-cli esp32 board support install
        'matlabshared.hwsdk.internal.localizedError(''MATLAB:arduinoio:general:thirdpartyLibNotInstalled'',''ESP32 Servo'');'...% D) Automate arduino-cli esp32 servo support install
        'buildInfo.SketchFile = fullfile(buildInfo.TempDirPath, strcat(''ArduinoServer'', buildInfo.Board, ''.ino''));',... % F) Update how the arduino sketch file is named')
        '[status, result] = system(installCmd);'... % F) Trigger verbose/echo output
        };  
    comment = '% OLD '; %Flag so we can easily find what's been commented out.
    % Call the commentOutLines function
    newFileContents = commentOutLines(oldLines,comment,newFileContents);

%% Code Sections to Modify. The first line is the existing code to search. Any following lines will be added in after the 'search' line  
 % Each line should be unique within the file to prevent unintended changes.
    % A) Update File Header
        disp('A) Update file header comments')
        CodeSectionALinePart = '    %      This file has been patched using ';
        CodeSectionA = {...
            '%   Copyright 2017-2025 The MathWorks, Inc.',...  %Existing line to search for.
            [CodeSectionALinePart mfilename '.m on ' char(datetime('now','Format','yyyy-MM-dd HH:mm')) ' to improve'],...
            '    %      M5Stack support when using the M5Unified Add-On Library for Arduino Custom Addon',...
            ['    %      The original file is saved as ' backupFileName]};
        pattern = CodeSectionALinePart + wildcardPattern + ".m on " + wildcardPattern + " to improve";
        if ~contains(newFileContents,pattern) %Since the timestamp changes, check if the line exists using a wildcard pattern
            newFileContents = insertLines(CodeSectionA,newFileContents);
        end
            
    % B) modify how Add-ons are included
        disp('B) Include additional headers in main build directory')
        CodeSectionB = {...
        'contents = strcat(contents, [''#include "'', headerFile, ''"\n'']);',... %Existing line to search for.
        '                    % NEW: instead of referencing the custom arduino add-on header in its original directory, move it to the'   , ...
        '                    % main ArduinoServer temp directory. Moving everything together simplifies development/troubleshooting '    , ...
        '                    headerPathParts = split(headerFile, filesep); %Find the header file name'                                   , ...
        '                    contents = strcat(contents, [''#include "'', char(headerPathParts{end}), ''"\n'']);'                        , ...
        '                    % NEW: Copy the header file to the ArduinoServer temporary directory'                                       , ...
        '                    copyfile(headerFile, buildInfo.TempDirPath);'                                                               , ...
        '                    % cd(buildInfo.TempDirPath); %Helpful for development in order to confirm arduinoServer files'              };
        %ChangeEnabled 
        newFileContents = insertLines(CodeSectionB,newFileContents);

    % C) Automate arduino-cli esp32 board support install
        disp('C) Automate esp32 board install')
        CodeSectionC = {...
        'matlabshared.hwsdk.internal.localizedError(''MATLAB:arduinoio:general:thirdpartyLibNotInstalled'',''ESP32'');',... %Existing line to search for.
        '                        % NEW install esp32 board support',...
        '                        [status,result] = complete3pInstall(obj,buildInfo);',...
        '                        if status;fprintf(result);error(''could not install support packages for esp32 boards in arduino-cli'');end'};
        newFileContents = insertLines(CodeSectionC,newFileContents);

    % D) Automate arduino-cli esp32 servo support install
        disp('D) Automate esp32 servo install')
        CodeSectionD = {... 
        'matlabshared.hwsdk.internal.localizedError(''MATLAB:arduinoio:general:thirdpartyLibNotInstalled'',''ESP32 Servo'');',... %Existing line to search for.
        '                        % NEW install esp32 servo support',...
        '                        [status] = completeServoESP323pInstall(obj,buildInfo);'...
        '                        if status;error(''could not install support packages for esp32 Servo in arduino-cli'');end'};
        newFileContents = insertLines(CodeSectionD,newFileContents);
        
    % E) Detect when M5Unified library is included; suppress boot button & trigger board selection
        disp('E) Detect when M5Unified library is included; suppress boot button & trigger board selection window')
        CodeSectionE = {...
        'buildInfo.SketchFile = fullfile(buildInfo.TempDirPath, strcat(''ArduinoServer'', buildInfo.Board, ''.ino''));',... %Existing line to search for.
        '            %% NEW Detect if M5Unified is included and modify build to better support M5Stack',...
        '            if ismember(''M5Stack/M5Unified'',buildInfo.Libraries)',...
        '               setpref(''MATLAB_HARDWARE'',''Test_NoBootButtonPressESP32'',true);  %Disable Boot Button dialog',...
        '               %The property "buildInfo.Board" e.g. "ESP32-WROOM-DevKitC" is used by matlab to determine how to build the arduino server, ArduinoCLI uses FQBN.',...
        '               %FQBN follows three-part convention [vendor:architecture:board] stored as the properties [buildInfo.Package,buildInfo.Arch,buildInfo.BoardName]',...
        '               % Ask user to select the M5Stack type and set corresponding FQBN board',...
        '               boardOptions = { ...',...
        '                  %Device Name                 FQBN-Board ID           Flash Size  PSRAM Size  Default App Partition Size',...
        '                   ''Core (< V2.5)'',            ''m5stack-core-esp32'',   4194304,    0,          1310720; ...',...   % < V2.5 Cores released Before June 2020 had 4MB Flash
        '                   ''Core / Basic / Gray'',      ''m5stack-core-esp32'',   16777216,   0,          6815744; ...',...   % Must define Flash Size and set partition scheme
        '                   ''Fire / Bala / Bala2'',      ''m5stack-fire'',         16777216,   8388608,    6815744; ...',...   % < V2.6 released Before April 2020 had 4 MB of PSRAM. PSRAM size is auto-detected
        '                   ''Core2 / Tough'',            ''m5stack-core2'',        16777216,   8388608,    6815744; ...',...
        '                   ''CoreS3 / CoreS3 SE'',       ''m5stack-cores3''        16777216,   8388608,    6815744; ...',...
        '                   ''StickC / StickC Plus'',     ''m5stick-c'',            4194304,    0,          1310720; ...',...
        '                   ''StickC Plus 2'',            ''m5stick-c-plus2'',      8388608,    2097152,    3145728; ...',...   %ESP32-PICO-V3-02; 2 MB Quad PSRAM
        '                   ''StickS3'',                  ''m5stack-sticks3'',      8388608,    8388608,    3145728; ...',...   %ESP32-S3-PICO-1-N8R8
        '                   ''CoreInk'',                  ''m5stack-coreink'',      4194304,    0,          1310720; ...',...
        '                   ''Paper'',                    ''m5paper'',              16777216,   8388608     6815744; ...',...
        '                   ''Paper Mono/Lite/Color'',    ''esp32s3'',              16777216,   8388608     6815744; ...',...   %Must define Flash Size and set partition scheme  
        '                   ''Station'',                  ''m5station'',            4194304,    0,          1310720; ...',...
        '                   ''Atom Lite / Matrix'',       ''m5stack-atom'',         4194304,    0,          1310720; ...',...
        '                   ''Atom PSRAM / Echo'',        ''m5stack-atom'',         4194304,    4194304,    1310720; ...',... 
        '                   ''Atom S3 / Lite'',           ''m5stack-atoms3'',       8388608,    0,          3145728; ...',...   %ESP32-S3 SOC 
        '                   ''Stamp Pico'',               ''pico32'',               4194304,    0,          1310720; ...',...
        '                   ''Stamp C3 RISC-V'',          ''esp32c3'',              4194304,    0,          1310720; ...',...   %ESP32-C3
        '                   ''Stamp S3 / S3A / Dial'',    ''m5stack_stamps3'',      8388608,    0,          3145728; ...',...
        '                   ''Cardputer / Capsule'',      ''m5stack_stamps3'',      8388608,    0,          3145728;...',...
        '                   ''DinMeter / AirQ'',          ''m5stack_stamps3'',      8388608,    0,          3145728;...',...
        '                   ''M5StampP4X / TAB5'',        ''esp32p4'',              16777216,   16777216,   6815744};',...      %ESP32-P4NRW32
        '               % Keep all listed boards selectable; hardware testing so far covers Core and Core2 only.',...
        '               try %Create display list from the Device Names column with Core2 as the default',...
        '                   selection = listdlg(''PromptString'',''Select M5Stack board variant:'', ...',...
        '                       ''SelectionMode'',''single'',''ListString'',boardOptions(:,1), ...',...
        '                       ''InitialValue'',4,''ListSize'',[180 340]);',...
        '                   % Stop on cancellation rather than silently choosing a different board.',...
        '                   if isempty(selection);error(''M5Stack:SelectionCancelled'',''Board selection cancelled.'');end',...
        '               catch % If UI not available (e.g., headless)',...
        '                   % Require explicit selection instead of silently defaulting when the dialog fails.',...
        '                   error(''M5Stack:BoardSelectionRequired'',''Select a board interactively before building.'');',...
        '               end %of list selection',...
        '               buildInfo.BoardName = boardOptions{selection,2};',...
        '               buildInfo.MemorySize = boardOptions{selection,5};',...
        '               % If user selected Core / Basic / Gray (option 2), append flash/partition info',...
        '               if selection == 2;buildInfo.BoardName = [buildInfo.BoardName '':FlashSize=16M,PartitionScheme=default_16MB''];end',...
        '               %Todo: allow user to set the partition scheme (appended to FQBN e.g. esp32:esp32:m5stack-core2:PartitionScheme=default_16mb)',...
        '            else % restore the boot button',...
        '               setpref(''MATLAB_HARDWARE'',''Test_NoBootButtonPressESP32'',false); %Could also use rmpref',...
        '            end %of NEW M5Unified detection section'};
        newFileContents = insertLines(CodeSectionE,newFileContents);
   % F) Ensure the sketch file has the same name as the parent directory
        disp('F) Name the sketch file based on the parent directory')
        CodeSectionF = {...
        'buildInfo.SketchFile = fullfile(buildInfo.TempDirPath, strcat(''ArduinoServer'', buildInfo.Board, ''.ino''));',... %Existing line to search for.
        '            % NEW Name the .ino file the same as the parent directory which is a requirement. Much simpler to add a build property.',...
        '            buildInfo.SketchFile = fullfile(buildInfo.TempDirPath, strcat(regexp(buildInfo.TempDirPath,''[^\\/]+$'',''match'',''once''), ''.ino''));' };
        newFileContents = insertLines(CodeSectionF,newFileContents);

   % G) Trigger verbose/echo output when installing ESP32 or RP2040 Support (complete3pInstall)
        disp('G) Trigger verbose/echo output') %set Verbose output in arduinoCLI and print it to the matlab command window using echo
        CodeSectionG = {...
        '[status, result] = system(installCmd);',... %Existing line to search for.
        '            % New Provide feedback for the user during the long install process',...
        '            installCmd = [installCmd,'' -v'' ]; % NEW add verbose flag',...
        '            [status, result] = system(installCmd, ''-echo''); % NEW add echo flag';};
        newFileContents = insertLines(CodeSectionG,newFileContents);

%% Save the output
    % Identify generated output; repeat runs still rebuild from the backup.
    newFileContents = [patchMarker newline newFileContents];
    % Compare full contents so equal-length edits are detected too.
    if ~isfile(filePath) || ~strcmp(newFileContents, fileread(filePath))
        % Only install a new Utility.m after every patch section succeeds.
        writeUtilityFile(filePath, newFileContents);
        fprintf(' -%s modified successfully.',[fileName extension]);
    else
        fprintf(' -NO changes were made to %s',[fileName extension]);
    end

catch exception
    % A failed first patch must not leave MATLAB without its original Utility.m.
    if createdBackup && ~isfile(filePath)
        [restored, message] = copyfile(backupPath, filePath, 'f');
        if ~restored
            warning('M5Stack:UtilityRestoreFailed', ...
                'Restore %s to %s manually: %s', backupPath, filePath, message);
        end
    end
    rethrow(exception);
end
end

function writeUtilityFile(filePath, contents)
% Write a new file beside Utility.m; never truncate the current file in place.
temporaryPath = [tempname(fileparts(filePath)) '.m'];
temporaryCleanup = onCleanup(@() deleteTemporaryUtility(temporaryPath)); %#ok<NASGU>
[fid, message] = fopen(temporaryPath, 'w');
if fid < 0
    error('M5Stack:UtilityWriteFailed', ...
        'Cannot open %s for writing: %s. Check access permissions or file locks; original backup retained.', filePath, message);
end
fileCleanup = onCleanup(@() closeUtilityFile(fid)); %#ok<NASGU>
% Detect incomplete writes rather than reporting a successful patch.
count = fwrite(fid, contents);
if count ~= numel(contents)
    error('M5Stack:UtilityWriteFailed', 'Incomplete write to %s; restore the original backup.', filePath);
end
closeStatus = fclose(fid);
if closeStatus ~= 0
    error('M5Stack:UtilityWriteFailed', 'Cannot finish writing %s; verify or restore the original backup.', filePath);
end
clear fileCleanup
% Confirm the saved text before replacing Utility.m; write/close errors are checked above.
if ~strcmp(fileread(temporaryPath), contents)
    error('M5Stack:UtilityWriteFailed', 'Saved contents do not match the requested text; existing Utility.m and backup retained.');
end
[status, message] = movefile(temporaryPath, filePath, 'f');
if ~status
    error('M5Stack:UtilityWriteFailed', 'Cannot install the new %s: %s. Original backup retained.', filePath, message);
end
end

function closeUtilityFile(fid)
if ~isempty(fopen(fid))
    fclose(fid);
end
end

function deleteTemporaryUtility(filePath)
if isfile(filePath)
    delete(filePath);
end
end

function modifiedContent = commentOutLines(oldLines,comment,modifiedContent)
% Comment out lines
disp(' -Commenting out old lines')
linesCommented = 0;
totalLines = size(oldLines,2);
    for i = 1:1:totalLines
        posStr = strfind(modifiedContent, oldLines{i});
        NumIdenticalLines = length(posStr);
        %Check if the line is unique
        if NumIdenticalLines>1             
            % Stop before saving rather than commenting out an ambiguous target.
            error('M5Stack:UnsupportedUtility', 'Ambiguous patch target: %s', oldLines{i});
            fprintf('  --Error commenting out line %d, Multiple matches found for: ''%s...''\n',i,(oldLines{i}(1:min(30, end))))
        elseif NumIdenticalLines == 1
            %Check if the line was already commented.
            posLnSt = find(modifiedContent(1:posStr(1)-1) == newline, 1, 'last'); % find the beginning of the line for the string you are looking for.
            spaceb4Str = strtrim(modifiedContent(posLnSt:posStr(1)));
            if startsWith(spaceb4Str,'%')
                error('M5Stack:UnsupportedUtility', 'Patch target is already commented out: %s', oldLines{i});
            else
                modifiedContent = insertBefore(modifiedContent, oldLines{i},comment);
                linesCommented = linesCommented+NumIdenticalLines;
            end
        else % Error: No Match found
            % Stop before saving a partial patch when the expected source has changed.
            error('M5Stack:UnsupportedUtility', 'Missing patch target: %s', oldLines{i});
            fprintf('  --Error commenting out line %d, no match found.\n',i)
        end

    end
        fprintf('  --%d of %d lines successfully commented out\n',linesCommented,totalLines);
end

function modifiedContent = insertLines(CodeSection,modifiedContent)
% Insert new lines 
% CodeSection is a 1*n cell array. The first line needs to be the existing section of code to find. The following lines are all the code to add
disp(' -Inserting new code')
linesInserted = 0;
    for i = 2:1:size(CodeSection, 2)
            previousLineofCode = CodeSection{i-1};
            strOut = strtrim(previousLineofCode); %Remove leading and trailing whitespace
            % Check if the current line already exists in modifiedContent.
            posPrevStr = strfind(modifiedContent, CodeSection{i-1});
            NumIdenticalLines = length(posPrevStr);
            if NumIdenticalLines>1
                % Stop before saving rather than inserting code at an ambiguous location.
                error('M5Stack:UnsupportedUtility', 'Ambiguous insertion target: %s', previousLineofCode);
                fprintf('  --No Code inserted. Multiple matches for line %d: ''%s...'' found \n inserted lines must be unique',i-1,strOut(1:min(20, end)))
            elseif NumIdenticalLines == 1
            %PrevStrSz = length(CodeSection{i-1});
            %PrevStrEnd = posPrevStr+PrevStrSz;
            newLineofCode = [newline, CodeSection{i}];
            %newLineofCodeSz = length(newLineofCode);
            %posNewStrEnd = PrevStrEnd+newLineofCodeSz;
            % Check if the new line already exists in modifiedContent.
            if ~contains(modifiedContent, CodeSection{i})
                modifiedContent = insertAfter(modifiedContent, previousLineofCode,newLineofCode);
                linesInserted = linesInserted+1;
            else
                strOut = strtrim(CodeSection{i});
                fprintf('  --No Code inserted. Identical text to line %d: ''%s...'' found.\n',i,strOut(1:min(30, end)))
            end
            else
                 % Stop before saving a partial patch when an insertion anchor is missing.
                 error('M5Stack:UnsupportedUtility', 'Missing insertion target: %s', previousLineofCode);
                 fprintf('  --No Code inserted. Could not find the previous line: %s...\n',strOut(1:min(20, end)))
            end
    end
    fprintf('  --%d of %d lines inserted\n',linesInserted,i-1);
end
