function outputFile = buildToolbox
%BUILDTOOLBOX Build the release installer without installing or running it.
% Created with GPT6A for the MATLAB Project and toolbox release workflow.
% Run from the repository root in MATLAB R2024a or later.
root = fileparts(mfilename('fullpath'));
library = fullfile(root, 'M5Unified Add-On Library for Arduino');
outputFolder = fullfile(root, 'release');
if ~isfolder(outputFolder)
    mkdir(outputFolder);
end
% Package a flat staging root rather than preserving the repository's
% library folder inside the folder MATLAB creates for the installed add-on.
stagingFolder = tempname(outputFolder);
mkdir(stagingFolder);
stagingCleanup = onCleanup(@() rmdir(stagingFolder, 's')); %#ok<NASGU>
rootDocuments = ["README.md", "CHANGELOG.md", "VERSION", ...
    "images/boards/core.jpg", "images/boards/core2.jpg", "images/boards/core2-aws.jpg", "images/boards/stickc-plus.jpg"];
relativeFiles = toolboxFileList;
for index = 1:numel(relativeFiles)
    relativeFile = relativeFiles(index);
    if any(relativeFile == rootDocuments)
        sourceFile = fullfile(root, relativeFile);
    else
        sourceFile = fullfile(library, relativeFile);
    end
    assert(isfile(sourceFile), 'M5Unified:MissingReleaseFile', ...
        'A listed toolbox release file is missing: %s', sourceFile);
    destinationFile = fullfile(stagingFolder, relativeFile);
    destinationFolder = fileparts(destinationFile);
    if ~isfolder(destinationFolder)
        mkdir(destinationFolder);
    end
    copyfile(sourceFile, destinationFile);
end
% Configure MATLAB's options after all staged files exist for validation.
opts = toolboxOptions(stagingFolder);
outputFile = opts.OutputFile;
matlab.addons.toolbox.packageToolbox(opts);
assert(isfile(outputFile), 'M5Unified:MissingInstaller', ...
    'MATLAB did not produce the expected toolbox installer.');
fprintf('Created %s\n', outputFile);
end
