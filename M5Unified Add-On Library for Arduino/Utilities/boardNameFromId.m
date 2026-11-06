%% boardNameFromId.m
% ==================================================================================================
% Resolve M5.getBoard() using the installed M5GFX enum used by M5Unified.
% An optional header path supports testing or a custom library installation.
% Generated using GPT6Astra.
% November 2, 2026
% ==================================================================================================
function name = boardNameFromId(boardId, headerPath)

% Validate the identifier and retain a fallback if no definition matches.
validateattributes(boardId, {'numeric'}, {'scalar','integer','nonnegative'});
name = sprintf('Unknown M5Unified board (%u)', boardId);
% Locate the installed header unless a custom path was supplied.
if nargin < 2
    headerPath = fullfile(arduinoio.CLIRoot, 'user', 'libraries', ...
        'M5GFX', 'src', 'lgfx', 'boards.hpp');
end
if ~isfile(headerPath)
    warning('M5Stack:BoardDefinitionsMissing', ...
        'Cannot resolve board %u: missing %s.', boardId, headerPath);
    return
end
% Read the enum definition before walking its comma-separated entries.
source = fileread(headerPath);
% Match block comments (across lines) or line comments up to a newline.
source = regexprep(source, '/\*[\s\S]*?\*/|//[^\r\n]*', '');
% Capture the contents of enum board_t between its braces.
body = regexp(source, 'enum\s+board_t\s*\{([^}]*)\}', 'tokens', 'once');
if isempty(body)
    warning('M5Stack:BoardDefinitionsUnsupported', 'Cannot parse board_t in %s.', headerPath);
    return
end
entries = strsplit(body{1}, ',');
values = containers.Map('KeyType','char','ValueType','double');
nextId = 0;
% Track earlier names for aliases and the next implicit enumeration value.
for k = 1:numel(entries)
    % Remove the deprecated attribute, allowing whitespace before its parentheses.
    entry = regexprep(strtrim(entries{k}), '__attribute__\s*\(\(deprecated\)\)', '');
    % Capture a board_ name and its explicitly assigned number or alias.
    token = regexp(entry, '^(board_\w+)\s*=\s*(\w+)\s*$', 'tokens', 'once');
    if isempty(token)
        % Match a bare board_ name whose value is implicitly incremented.
        token = regexp(entry, '^(board_\w+)\s*$', 'tokens', 'once');
    end
    if isempty(token)
        warning('M5Stack:BoardDefinitionsUnsupported', 'Unsupported board enum entry: %s.', entry);
        return
    end
    % Resolve explicit values or aliases; otherwise use C++ enum auto-increment.
    value = nextId;
    if numel(token) > 1 && ~isempty(token{2})
        expression = token{2};
        if isKey(values, expression)
            value = values(expression);
        elseif ~isempty(regexp(expression, '^0[xX][0-9a-fA-F]+$', 'once')) % Match a complete hexadecimal literal.
            value = hex2dec(expression(3:end));
        elseif ~isempty(regexp(expression, '^\d+$', 'once')) % Match a complete unsigned decimal integer.
            value = str2double(expression);
        else
            warning('M5Stack:BoardDefinitionsUnsupported', 'Unsupported board value: %s.', expression);
            return
        end
    end
    values(token{1}) = value;
    nextId = value + 1;
    % Return the first matching name without the C++ enum prefix.
    if value == boardId
        name = erase(token{1}, 'board_');
        return
    end
end
end
