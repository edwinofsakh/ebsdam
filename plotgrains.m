%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any chages to this scrip.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = symmetry('m-3m');

% specimen symmetry
SS = symmetry('-1');

% plotting convention
plotx2north

%% Specify File Names

% path to files
pname = 'F:\Projects\TextureStudy\EBSD\data\';

% which files to be imported
fname = {...
[pname '2qout2(win).ang'], ...
};


%% Import the Data

% create an EBSD variable containing the data
ebsdf = loadEBSD(fname,CS,SS,'interface','generic' ...
  , 'ColumnNames', { 'Quat real' 'Quat i' 'Quat j' 'Quat k' 'x' 'y'}, 'Quaternion');

% ebsdf = loadEBSD(fname,CS,SS,'interface','generic' ...
%   , 'ColumnNames', { 'Quat real' 'Quat i' 'Quat j' 'Quat k' 'x' 'y'}, 'Quaternion', 'unitCell', [0.042186 -0.042186 -0.042186 0.042186]);

ebsd = cutEBSD(ebsdf, 0,0, 20,20);

%% Default template
%% Visualize the Data

plot(ebsd)


%% Calculate an ODF

% odf = calcODF(ebsd)

%% Detect grains

%segmentation angle 'threshold'
segAngle = 1*degree;

grains = calcGrains(ebsd,'angle',segAngle);

%% Orientation of Grains

figure;
plot(grains)
