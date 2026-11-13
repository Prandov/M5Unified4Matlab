function htmlFile = buildDocumentation
%BUILDDOCUMENTATION Publish the current wrapper without executing its code.
% Created with GPT6A for the MATLAB Project and toolbox release workflow.
% Optional development preview only; HTML is not included in the toolbox release.
root = fileparts(mfilename('fullpath'));
classFolder = fullfile(root, 'M5Unified Add-On Library for Arduino', ...
    '+arduinoioaddons', '+M5Stack');
sourceFile = fullfile(classFolder, 'M5Unified.m');
options = struct('format', 'html', 'evalCode', false, 'showCode', true, ...
    'outputDir', fullfile(classFolder, 'html'));
htmlFile = publish(sourceFile, options);
assert(isfile(htmlFile), 'M5Unified:MissingDocumentation', ...
    'MATLAB did not generate the wrapper documentation.');
fprintf('Published %s\n', htmlFile);
end
