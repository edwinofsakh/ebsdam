function check_ebsdam()
% Check EBSD Analysis Module prefs and paths
% 
% Syntax
%   startup_ebsdam()
%
% History
% 13.04.13  Add paths check.

if ispref('ebsdam')
    getpref('ebsdam')
else
	disp(' EBSDAM does not installed.')
end

% Find basepath is in search path
disp('Paths:')
cellpath = regexp(path, ['[^' pathsep ']+'],'match');
cellind  = strfind(lower(cellpath), 'ebsdam');
cellind  = cellfun(@isempty,cellind);
cellind  = not(cellind);
for p = cellpath(cellind)
    disp(p{:});
end
