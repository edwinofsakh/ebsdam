function [cags0, cags1, cags2, cags3] = test_GS

N = 28;
S = 20;

% Check random
display('110');
imax = 9;
cags0 = cell(1,imax);
for i = 1:imax
    try
        display(int2str(i));
        [X, Y] = gridGrains(N, sqrt(3)/2, 0.5, 'dev', 0.4);
        ebsd = Grid2EBSD(N, X,Y, S, 'omega', 15*degree);
        cags0{i} = viewSizes( ['rnd110_' int2str(i)], 0, ebsd, 1, 0.1, 0, 'flat_save');
    end
end

% Check Grain Numbers
display('111');
Na = [8, 12, 24, 32];
imax = length(Na);
cags1 = cell(1,imax);
for i = 1:imax
    try
        display(int2str(i));
        [X, Y] = gridGrains(Na(i), sqrt(3)/2, 0.5, 'dev', 0.4);
        ebsd = Grid2EBSD(Na(i), X,Y, S, 'omega', 15*degree);
        cags1{i} = viewSizes( ['rnd111_' int2str(i)], 0, ebsd, 1, 0.1, 0, 'flat_save');
    end
end

% Check S
display('112');
Sa = [5,10,15,20,25];
imax = length(Sa);
cags2 = cell(1,imax);
for i = 1:imax
    try
        display(int2str(i));
        [X, Y] = gridGrains(N, sqrt(3)/2, 0.5, 'dev', 0.4);
        ebsd = Grid2EBSD(N, X,Y, Sa(i), 'omega', 15*degree);
        cags2{i} = viewSizes( ['rnd112_' int2str(i)], 0, ebsd, 1, 0.1, 0, 'flat_save');
    end
end

% Check dev
display('113');
deva = [0.4,0.6,0.8,1.0,1.2];
imax = length(deva);
cags3 = cell(1,imax);
for i = 1:imax
    display(int2str(i));
    try
        [X, Y] = gridGrains(N, sqrt(3)/2, 0.5, 'dev', deva(i));
        ebsd = Grid2EBSD(N, X,Y, S, 'omega', 15*degree);
        cags3{i} = viewSizes( ['rnd113_' int2str(i)], 0, ebsd, 1, 0.1, 0, 'flat_save');
    end
end

save('test_gs', 'cags0', 'cags1', 'cags2', 'cags3');

end
