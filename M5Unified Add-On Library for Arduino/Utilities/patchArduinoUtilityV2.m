%% patchArduinoUtilityV2.m
% ==================================================================================================
% This patch will modify arduinoio.internal.Utility to fix an ArduinoServer compilation error that  
% sometimes occurs when custom add-on libraries like 'NeoPixel' are included. The error is that the 
% custom library header file cannot find it's dependancy 'LibraryBase.h'. I've noticed this with 
% ESP32 based M5Stack when trying to program in MATLAB 24.1 for Windows 11 & Arduino Support 24.1
% V1 Modifies Utility.m. The Function 'generateAddonLibrariesHeader' now moves the additional header
% files directly into the ArduinoServer temp directory instead of referenceing their orignal path.
% NOTE: These changes have been commented out for now while the error is being investigated further. 
%       PLEASE submit a support request with MATHWORKS if you get an error here.
% V2 Separates into functions commentOutLines() and insertLines()
% V2.1 Tries to directly install esp32 board support without running arduinosetup instead of 
% throwing an error. 
% V2.2 Suppresses the boot button dialog for ESP32 when it detects M5Unified libraries are included 
% in the server.
% Version 2.2
% By: Eric Prandovszky
% prandov@yorku.ca
% October 3, 2024
% ==================================================================================================
disp('Running: patchArduinoUtilityV2.m')
% Define the path to the file
    filePath = which('arduinoio.internal.Utility');

    [folderPath, fileName, extension] = fileparts(filePath);
    fprintf(' -Attempting to update %s\n',[fileName extension]);
% Read the content of the file
    backupFileContents = fileread(filePath);
    newFileContents = backupFileContents; %Make a copy to compare output
    backupFileName = [fileName,'OriginalUnpatched.m'];
%% Lines to comment out
% Lines need to be unique within the file to prevent unintended changes.
    oldLines = {...
       %ChangeDisabled 'headerFile = strrep(headerFile, ''\'', ''\\'');', ...
       %ChangeDisabled 'contents = strcat(contents, [''#include "'', headerFile, ''"\n'']);',...
        'matlabshared.hwsdk.internal.localizedError(''MATLAB:arduinoio:general:thirdpartyLibNotInstalled'',''ESP32'');',...
        'matlabshared.hwsdk.internal.localizedError(''MATLAB:arduinoio:general:thirdpartyLibNotInstalled'',''ESP32 Servo'');'
        };  
    comment = '% OLD ';
    % Call the commentOutLines function
    newFileContents = commentOutLines(oldLines,comment,newFileContents);

%% Code Sections to Modify. The first line is the existing code to search. Any following lines will be added in after the 'search' line  
 % Each line should be unique within the file to prevent unintended changes.
    % A) modify how Add-ons are included
        CodeSectionA = {...
        'contents = strcat(contents, [''#include "'', headerFile, ''"\n'']);',... %Existing line to search for.
        '                    % NEW: instead of referencing the custom arduino add-on header in its original directory, we move it to the', ...
        '                    % main ArduinoServer temp directory. So we just have to #include header.h instead of the original path'     , ...
        '                    headerPathParts = split(headerFile, filesep);'                                                              , ...
        '                    contents = strcat(contents, [''#include "'', char(headerPathParts{end}), ''"\n'']);'                        , ...
        '                    % NEW: Copy the header file to the ArduinoServer temporary directory'                                       , ...
        '                    copyfile(headerFile, buildInfo.TempDirPath);'                                                               , ...
        '                    % cd(buildInfo.TempDirPath);'                                                                              };
        %ChangeDisabled newFileContents = insertLines(CodeSectionA,newFileContents);

    % B) Automate arduino-cli esp32 board support install
        CodeSectionB = {...
        'matlabshared.hwsdk.internal.localizedError(''MATLAB:arduinoio:general:thirdpartyLibNotInstalled'',''ESP32'');',... %Existing line to search for.
        '                        % NEW install esp32 board support',...
        '                        [status,result] = complete3pInstall(obj,buildInfo);',...
        '                        if status;fprintf(result);error(''could not install support packages for esp32 boards in arduino-cli'');end'};
        newFileContents = insertLines(CodeSectionB,newFileContents);
    % C) Automate arduino-cli esp32 servo support install
        CodeSectionC = {... 
        'matlabshared.hwsdk.internal.localizedError(''MATLAB:arduinoio:general:thirdpartyLibNotInstalled'',''ESP32 Servo'');',... %Existing line to search for.
        '                        % NEW install esp32 servo support',...
        '                        [status] = completeServoESP323pInstall(obj,buildInfo);'...
        '                        if status;error(''could not install support packages for esp32 Servo in arduino-cli'');end'};
        newFileContents = insertLines(CodeSectionC,newFileContents);
    % D) Supress Boot Button Dialog when M5Unified library is included
        CodeSectionD = {...
        '            buildInfo.SketchFile = fullfile(buildInfo.TempDirPath, strcat(''ArduinoServer'', buildInfo.Board, ''.ino''));',... %Existing line to search for.
        '            %% NEW Supress Boot Button Dialog when M5Unified is detected',...
        '            if ismember(''M5Stack/M5Unified'',buildInfo.Libraries)',...
        '               setpref(''MATLAB_HARDWARE'',''Test_NoBootButtonPressESP32'',true);',...
        '            else % restore the boot button',...
        '               setpref(''MATLAB_HARDWARE'',''Test_NoBootButtonPressESP32'',false); %Could also use rmpref',...
        '            end %NEW'};
        newFileContents = insertLines(CodeSectionD,newFileContents);

%% Save the output
    % Check to see if any changes were made.
    if length(newFileContents)~=length(backupFileContents)
        %Copy the original file to a backup called [fileName,'OriginalUnpatched.m'].
        movefile (filePath, fullfile(folderPath,backupFileName), 'f'); % added a force because one some users got an error in osx.
        % Write the modified content to the original filename.
        fid = fopen(filePath, 'w');
        fwrite(fid, newFileContents);
        fclose(fid);
        fprintf(' -%s modified successfully.',[fileName extension]);
    else
        fprintf(' -NO changes were made to %s',[fileName extension]);
    end

function modifiedContent = commentOutLines(oldLines,comment,modifiedContent)
% Comment out lines
disp(' -Commenting out old lines')
linesCommented = 0;
totalLines = size(oldLines,2);
    for i = 1:1:totalLines
        posStr = strfind(modifiedContent, oldLines{i});
        NumIdenticalLines = length(posStr);
        if NumIdenticalLines>1
            fprintf('  --Error commenting out line %d, Multiple matches found for: ''%s...''\n',i,(oldLines{i}(1:min(30, end))))
        elseif NumIdenticalLines == 1
            %Check if the line was already commented.
            %Only checks if the first match was already commented, this may result in subsequent matches not getting commented out.
            posLnSt = find(modifiedContent(1:posStr(1)-1) == newline, 1, 'last'); % find the beginning of the line for the string you are looking for.
            spaceb4Str = strtrim(modifiedContent(posLnSt:posStr(1)));
            if startsWith(spaceb4Str,'%')
                fprintf('  --Error commenting out line %d, ''%s...'' is already commented out.\n',i,(oldLines{i}(1:min(30, end))));
            else
                modifiedContent = insertBefore(modifiedContent, oldLines{i},comment);
                linesCommented = linesCommented+NumIdenticalLines;
            end
        else % error
            fprintf('  --Error commenting out line %d, no match found.\n',i)
        end

    end
        fprintf('  --%d of %d lines successfully commented out\n',linesCommented,totalLines);
end

function modifiedContent = insertLines(CodeSection,modifiedContent)
% Insert new lines 
disp(' -Inserting new code')
linesInserted = 0;
    for i = 2:1:size(CodeSection, 2)
            previousLineofCode = CodeSection{i-1};
            strOut = strtrim(previousLineofCode);
            % Check if the current line already exists in modifiedContent.
            posPrevStr = strfind(modifiedContent, CodeSection{i-1});
            NumIdenticalLines = length(posPrevStr);
            if NumIdenticalLines>1
                fprintf('  --No Code inserted. Multiple matches for line %d: ''%s...'' found',i-1,strOut(1:min(20, end)))
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
                 fprintf('  --No Code inserted. Could not find the previous line: %s...\n',strOut(1:min(20, end)))
            end
    end
    fprintf('  --%d of %d lines inserted\n',linesInserted,i-1);
end