function [ ebsd ] = s04t1_load( varargin )
%s04_load Load test EBSD data from 'X100-2_4.txt' 10x10 from x=100;y=100
%  Supplier : FTIM
%  Material : bainite steel
%  Phases   : austenite, ferrite!, cementite.
%  Columns  : Phase ; x ; y ; Euler 1 ; Euler 2 ; Euler 3 ; Mad ; BC
%  Points   : 292681 (541x541)
%  Size     : 216 x 216 um
%  Step     : 400 nm
%  Comments :
%

%% Settings

% File name
DataDir = getpref('ebsdam','data_dir');
matfile = [DataDir '.\Exp FTIM\s04t1.mat'];

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

