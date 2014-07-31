function [ ebsd ] = t01_load( varargin )
%t01_load Load generated EBSD data from 'test01.txt'
%  Supplier : PANPURIN SERGEY
%  Material : test data
%  Phases   : ferrite.
%  Columns  : Phase ; x ; y ; Euler 1 ; Euler 2 ; Euler 3
%  Points   : 72 (12x6)
%  Size     : N/A
%  Step     : N/A
%  Comments :
%   Random oreantition for tests.

%% Settings

% File name
fname = '.\test01.txt';

% Specify crystal and specimen symmetry
CS = symmetry('m-3m','mineral','Fe');   % crystal symmetry phase ferrite

if (check_option(varargin, 'odf'))
    ss = symmetry('222');   % specimen symmetry
else
    ss = symmetry('-1');   % specimen symmetry
end

% Load data director from preference
DataDir = getpref('ebsdam','data_dir');


%% Loading

% Load data
disp(['Loading EBSD data from "' fname '": ']);
ebsd = loadEBSD([DataDir '\' fname], CS, SS, 'interface','generic',...
  'ColumnNames', { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3'},...
  'Columns', [1 2 3 4 5 6],...
  'ignorePhase', 0, 'Bunge');

plotx2east;

ebsd = flipud(ebsd);

end

