function setupWorkDirs()
% Setup working directories such as EBSD data directoty in preferences.
%   Try to find previous seting directory in prefs and settings file, else
%   ask user to set new dirs.
%
% Syntax
%   setupWorkDirs()
%
% History
% 13.04.13  Original impelentation.

% List of working dirs
dirs = {'data_dir', 'output_dir', 'cache_dir', 'doc_dir'};

% Load dirs path from file
if exist('EBSDAM_settings.m','file')
	try
        EBSDAM_settings;
    catch
        disp('Bad settings file: ''EBSDAM_settings.m''.');
    end
end

% Rewrite settings file
fid = fopen('EBSDAM_settings.m','w');

% Setup dirs
for d = dirs
    
    % Prepare
    changeDir = 1;
    varname = d{:};
    dirpath = '';
    
    % Find previous value
    if ispref('ebsdam', varname)
        dirpath = getpref('ebsdam', varname);
    end
    if exist(varname, 'var')
        dirpath = eval(varname);
    end
    
    % Check previous value
    if ~isempty(dirpath) && exist(dirpath,'dir')
        % Ask user if he wants to change dir
        f = questdlg(...
            ['Would you like to change ' upper(varname) ' directory? Current value is :' dirpath],...
            ['Change ' upper(varname) ' directory'], ...
            'Set new dir', 'Keep old dir', 'Keep old dir');
        
        if (strcmp(f, 'Keep old dir'))
            changeDir = 0;
        end
    else
        dirpath = '';
    end
    
    % Set new dir
    if (changeDir)
        dirpath = uigetdir(dirpath, ['Select ' upper(varname) ' directory']);
    end
    
    % Save dir path
    setpref('ebsdam', varname, dirpath);
    fwrite(fid, ['setpref(''ebsdam'',''' varname ''',''' dirpath ''');' 10]); % newline = 10 (0x0A)
end

fwrite(fid, ['setpref(''ebsdam'',''caching'',1);' 10]); % newline = 10 (0x0A)
fwrite(fid, ['setpref(''ebsdam'',''saveResult'',1);' 10]); % newline = 10 (0x0A)
fwrite(fid, ['setpref(''ebsdam'', ''maxProbParents'', 2000)' 10]);% newline = 10 (0x0A);
% Close settings file
fclose(fid);

end

