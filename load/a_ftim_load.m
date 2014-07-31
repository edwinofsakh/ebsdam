function [ ebsd ] = a_ftim_load( fname, cs, ss, hdr, ignorePhase, flipDataX, flipDataY )
%Pattern for loading FTIM's EBSD data (Euler angle in degree)
%   Universal loading pattern for FTIM's data. FTIM use usually use '.txt'
%   files.
%   fname - name of data file
%   cs - crystall symmetry
%   ss - sample symmetry
%   hdr - header offset
%
% History
% 29.10.12 Original implementation

% Load data director from preference
DataDir = getpref('ebsdam','data_dir');

% Name of MAT file with saveing variables 
matfile = [DataDir '\' fname '.mat'];

if exist(matfile,'file')
    % Load saveing data
    load_struct = load(matfile, 'ebsd');
    ebsd = load_struct.ebsd;
else
    % Load data
    disp(['Loading EBSD data from "' fname '": ']);
    ebsd = loadEBSD([DataDir '\' fname], cs,ss, 'interface','generic',...
      'ColumnNames', { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'MAD' 'BC'},...
      'Columns', [1 2 3 4 5 6 7 8],...
      'ignorePhase', ignorePhase, 'Bunge', 'HEADER', hdr);
    disp('Done');

    save(matfile, 'ebsd');
    disp('Saved');
    
    display(ebsd);
end

%% Processing

% Set X axis to east
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

