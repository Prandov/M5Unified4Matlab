% prepareForM5Stack.m
% ==================================================================================================
% Run the commands to prepare matlab to use the M5Stack
% Only tested with M5Stack Core2 for AWS so far
% By: Eric Prandovszky
% prandov@yorku.ca
% September 25, 2024
% ==================================================================================================

% 1. Install MATLAB.
% 2. Install MATLAB Support Package for Arduino Hardware (in MATLAB and click Add-Ons --> Get Add-Ons)
% 3. Install M5Unified Library for MATLAB (in MATLAB and click Add-Ons --> Get Add-Ons)
% 4. Install NeoPixel Add-On Library for Arduino (in MATLAB and click Add-Ons --> Get Add-Ons)
% 5. Run this Script
% 6. *Possibly install CP210x USB serial port driver if your computer can't detect the M5Stack.
% 7. Try out the one of the connectToM5Stack* scripts to get started.

disp('Running: prepareForM5Stack.m')
% patchArduinoUtility2, changes how add-on libraries are included. (Change is currently disabled to try and reproduce the original error).
% patchArduinoUtility2 supresses the ESP32 Boot Button dialog when using M5Unified libraries, and auto installs esp32 board & servo support.
patchArduinoUtilityV2
% InstallArduinoLibs will change to the Arduino Libraries directory if it finds a duplicate libaray so you can troubleshoot.
% InstallArduinoLibs can be configured to install any library, M5Unified, M5GFX and AdafruitNeopixel are the defaults.
installArduinoLibsFromGitHub 
disp('Done!')


%% Todo: automate installing matlab addons
% 
% https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/47522/versions/3/download/mlpkginstall %Downloads 'arduinoio.mlpkginstall'
% Neopixel Addon URL
% https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/eabd9147-ddef-4d20-b251-bda6bdd5c4dd/2.6/packages/mltbx

function installMatlabAddons() %Untested (generated with GPT)
% List of add-on file paths
addonFiles = {
    'path_to_addon1.mltbx', 
    'path_to_addon2.mltbx', 
    'path_to_addon3.mltbx'
};

% Loop through each add-on and install
    for i = 1:length(addonFiles)
        try
            matlab.addons.install(addonFiles{i});
            fprintf('Installed: %s\', addonFiles{i});
        catch ME
            fprintf('Failed to install: %s\ Error: %s\', addonFiles{i}, ME.message);
        end
    end

end