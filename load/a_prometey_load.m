function [ ebsd ] = a_prometey_load( fname, cs, ss, hdr, ignorePhase, flipDataX, flipDataY )
%Pattern for loading Prometey's EBSD data (Euler angle in radians)
%   Universal loading pattern for Prometey's data. Prometey usually use
%   '.ang' files.
%   fname - name of data file
%   cs - crystall symmetry
%   ss - sample symmetry
%   hdr - header offset
%
% History
% 29.10.12 Original implementation

% Load data director from preference
DataDir = getpref('ebsdam','data_dir');
CacheDir = getpref('ebsdam','cache_dir');

% Name of MAT file with saveing variables 
matfile = [CacheDir '\' fname '.mat'];

if exist(matfile,'file')
    % Load saveing data
    load_struct = load(matfile, 'ebsd');
    ebsd = load_struct.ebsd;
else
    % Load data
    disp(['Loading EBSD data from "' fname '": ']);
    ebsd = loadEBSD([DataDir '\' fname], cs,ss, 'interface','generic','RADIANS',...
      'ColumnNames', { 'Euler 1' 'Euler 2' 'Euler 3' 'x' 'y' 'BC' 'MAD' 'Phase' 'SEM' 'Fit'},...
      'Columns', [1 2 3 4 5 6 7 8 9 10],...
      'ignorePhase', ignorePhase, 'Bunge', 'HEADER', hdr);
    disp('Done');

    % Check directory
    pathstr = fileparts(matfile);
    if ~exist(pathstr,'dir')
        mkdir(pathstr);
    end
    
    % Save EBSD object
    save(matfile, 'ebsd');
    
    disp('Saved');
    
    display(ebsd);
end

%% Processing

% Rotate data
plotx2east;

% Flip Up&Down
if flipDataX
    ebsd = fliplr(ebsd);
end

% Flip Left&Right
if flipDataY
    ebsd = flipud(ebsd);
end

end

