%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any chages to this scrip.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = symmetry('m-3m', 'mineral', 'Iron - Alpha');

% specimen symmetry
SS = symmetry('-1');

% plotting convention
plotx2east

%% Specify File Names

% path to files
pname = 'E:\Sergey\TextureStudy\data\ebsd\Fish\';

% which files to be imported
fname = {...
[pname '1.ang'], ...
};


%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,SS,'interface','ang' ...
  , 'flipud');
% ebsd = flipud(ebsd);

%% Default template
%% Visualize the Data

figure;
plot(ebsd, 'antipodal', 'r', xvector)
figure;
plot(ebsd, 'antipodal', 'r', yvector)
figure;
plot(ebsd, 'antipodal', 'r', zvector)


% %% Calculate an ODF
% 
% odf = calcODF(ebsd)
% 
% %% Detect grains
% 
% %segmentation angle
% segAngle = 10*degree;
% 
% grains = calcGrains(ebsd,'threshold',segAngle);
% 
% %% Orientation of Grains
% 
% plot(grains)
