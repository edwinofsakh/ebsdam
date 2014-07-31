function [ ebsd ] = a_load( fname, cs, ss, type, hdr, flipx, flipy )
%Pattern for loading Prometey's EBSD data (Euler angle in radians)
%   Universal loading pattern for Prometey's data. Prometey usually use
%   '.ang' files.
%
% Input
%   fname   - name of data file
%   cs      - crystall symmetry
%   ss      - sample symmetry
%   hdr     - header offset
%
% Output
%   ebsd    - ebsd data
%
% Syntax
%   [ ebsd ] = a_load( fname, cs, ss, type, hdr, flipx, flipy )
%
% History
% 29.10.12  Original implementation
% 27.11.12  Add the correct description of the function
% 12.03.14  Add caching check

% Type of data loading
switch type
    case 'prometey'
        rad = 1;
        colnames = { 'Euler 1' 'Euler 2' 'Euler 3' 'x' 'y' 'IQ' 'CI' 'Phase' 'SEM' 'Fit'};
        colnum = 1:10;
    case 'ftim'
        rad = 0;
        colnames = { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'CI' 'IQ'};
        colnum = 1:8;
    case 'ftim_p'
        rad = 0;
        colnames = { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'CI' 'IQ' 'V1' 'V2' 'V3' 'V4'};
        colnum = 1:12;
     case 'ftim_f'
        rad = 0;
        colnames = { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'MAD' 'IQ' 'RI' 'M11' 'M12' 'M13' 'M21' 'M22' 'M23' 'M31' 'M32' 'M33'};
        colnum = 1:18;    
    otherwise
        error('Invalid type of data loading!');
end

% Load data director from preference
isCaching = getpref('ebsdam','caching');
dataDir = getpref('ebsdam','data_dir');
cacheDir = getpref('ebsdam','cache_dir');

% Name of MAT file with saveing variables 
matfile = [cacheDir '\' fname '.mat'];
datafile = [dataDir '\' fname];

if exist(matfile,'file') && isCaching
    % Load saveing data
    load_struct = load(matfile, 'ebsd');
    ebsd = load_struct.ebsd;
else
    % Load data
    disp(['Loading EBSD data from "' fname '": ']);
    
    if rad
    ebsd = loadEBSD(datafile, cs,ss, 'interface','generic','RADIANS',...
      'ColumnNames', colnames,...
      'Columns', colnum,...
      'Bunge', 'HEADER', hdr);
      % 'ignorePhase', strcmpi(noPhase, 'noPhase'), 'Bunge', 'HEADER', hdr);
    else
    ebsd = loadEBSD(datafile, cs,ss, 'interface','generic',...
      'ColumnNames', colnames,...
      'Columns', colnum,...
      'Bunge', 'HEADER', hdr);
      % 'ignorePhase', strcmpi(noPhase, 'noPhase'), 'Bunge', 'HEADER', hdr);
    end
    
    disp('Done');

    if isCaching
        % Check directory
        pathstr = fileparts(matfile);
        if ~exist(pathstr,'dir')
            mkdir(pathstr);
        end

        % Save EBSD object
        save(matfile, 'ebsd');

        disp('Saved');
    end
end

% display(ebsd);
    
%% Processing

% Rotate data
plotx2east;

% Flip Left&Right
if strcmpi(flipx, 'flipx')
    ebsd = fliplr(ebsd);
end

% Flip Up&Down
if strcmpi(flipy, 'flipy')
    ebsd = flipud(ebsd);
end

end

