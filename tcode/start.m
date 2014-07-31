% 
close all;

% 
if ~exist('sid', 'var')
    sid = 's01';
end

if ~exist('cut', 'var')
    cut = [0,0, 100,100];
end

% load data
if ~exist('ebsd', 'var') || ~isa(ebsd, 'ebsd')
    ebsd = eval([sid '_load'])
    ebsd = ebsd('Fe');
end

ebsd = cutEBSD(ebsd, cut(1), cut(2), cut(3), cut(4));
grains = getGrains(ebsd, 3*degree, 8);