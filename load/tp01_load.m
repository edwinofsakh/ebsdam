function [ ebsd ] = tp01_load( varargin )
% Test Sample
%
%     [X, Y, in, in_xy] = gridPriorGrains(16, 4, sqrt(3)/2, 0.5, 'dev', 0.6);
%     [ebsd, ori0] = Grid2EBSD(X,Y, 20, 'OR', getOR('KS');, 'prior', in, 'crop', 'none', 'dev', 0, 'removeCloseOri', 5*degree);
    
%% Settings

% File name
DataDir = getpref('ebsdam','data_dir');
matfile = [DataDir '\tp01.mat'];

if exist(matfile,'file')
    % Load saveing data
    load_struct = load(matfile, 'ebsd');
    ebsd = load_struct.ebsd;
else
    error('File no find!');
end

% Rotate data
plotx2east;

end