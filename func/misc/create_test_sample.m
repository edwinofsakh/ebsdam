function create_test_sample()
% Create sample for system testing

dataDir = getpref('ebsdam','data_dir');
fname = fullfile(dataDir, 'testing', 'test_sample1.txt');

if (~exist(fname,'file'))
    % Parameters of prior grain structure
    N = 16; % Size of product grains grid
    Np = 4; % Size of parent grains grid

    sdev = 0.2;      % Spatial deviation (1 close to distance between grain centers)
    odev = 1*degree; % Orientation deviation in degree

    ORmat = getOR('KS'); % Orientation relation

    % Create test sample
    [X, Y, in] = gridPriorGrains(N, Np, sqrt(3)/2, 0.5, 'dev', sdev);
    ebsd = Grid2EBSD(X,Y, 20, 'OR', ORmat, 'prior', in, 'crop', 'none', 'dev', odev, 'removeCloseOri', 5*degree, 'addProperties');

    export(ebsd, fname);
end

dataDir = getpref('ebsdam','data_dir');
fname = fullfile(dataDir, 'testing', 'test_sample2.txt');

if (~exist(fname,'file'))
    % Parameters of grain structure
    N = 16; % Size of product grains grid
    
    sdev = 0.2;      % Spatial deviation (1 close to distance between grain centers)
    odev = 1*degree; % Orientation deviation in degree

    % Create test sample
    [X, Y] = gridGrains(N, sqrt(3)/2, 0.5, 20, 'dev', sdev);
    ebsd = Grid2EBSD(X,Y, 20, 'crop', 'none', 'dev', odev, 'removeCloseOri', 5*degree, 'twoPhase');

    export(ebsd, fname);
end


