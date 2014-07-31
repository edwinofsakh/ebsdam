function [ ebsd ] = r02_load( varargin )
%Random
%

%% Settings

% File name
DataDir = getpref('ebsdam','data_dir');
matfile = [DataDir '.\rand02.mat'];

if exist(matfile,'file')
    % Load saveing data
    load_struct = load(matfile, 'ebsd');
    ebsd = load_struct.ebsd;
else
    error('File no find!');
end

display(ebsd);

% Rotate data
plotx2east;

end

