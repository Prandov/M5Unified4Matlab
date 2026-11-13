function opts = toolboxOptions(packageFolder)
%TOOLBOXOPTIONS Release metadata and explicit contents for the M5Unified toolbox.
% Created with GPT6A for the MATLAB Project and toolbox release workflow.
% Keep the identifier unchanged so new releases update the existing add-on.
% packageFolder is the staging folder populated by buildToolbox.
root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
opts = matlab.addons.toolbox.ToolboxOptions(packageFolder, ...
    'b313688e-800a-415f-b056-b41df863d83c');
opts.ToolboxName = 'M5Unified Add-On Library for Arduino';
opts.ToolboxVersion = strtrim(fileread(fullfile(root, 'VERSION')));
opts.AuthorName = 'Eric Prandovszky';
opts.AuthorEmail = 'prandov@yorku.ca';
opts.Summary = 'Control built-in M5Stack peripherals from MATLAB through Arduino.';
opts.Description = ['Extends MATLAB Support Package for Arduino Hardware ' ...
    'with the M5Unified interface for M5Stack devices. Requires that support ' ...
    'package and the M5Unified and M5GFX Arduino libraries. Run ' ...
    'prepareForM5Stack manually after installation. NeoPixel Add-On Library ' ...
    'for Arduino is required by the Standard and Premium connection examples. ' ...
    'Development primarily uses Core2 for AWS; other board profiles are unverified.'];
opts.MinimumMatlabRelease = 'R2024a';
opts.SupportedPlatforms.MatlabOnline = false;
opts.ToolboxImageFile = fullfile(packageFolder, 'images', 'M5Unified4Matlab.png');

% Deliberately list release files: never package Git, project metadata, build
% scripts, installed resources, or autosaves. All paths are relative to the
% install root; buildToolbox populates the staging folder before packaging.
opts.ToolboxFiles = fullfile(packageFolder, toolboxFileList);
% Include the package parent, never the +package or src folders.
opts.ToolboxMatlabPath = [string(packageFolder); ...
    string(fullfile(packageFolder, 'Utilities')); string(fullfile(packageFolder, 'Examples'))];
opts.ToolboxGettingStartedGuide = fullfile(packageFolder, 'GettingStarted.mlx');
opts.OutputFile = fullfile(root, 'release', ...
    ['M5Unified-' char(opts.ToolboxVersion) '.mltbx']);
end
