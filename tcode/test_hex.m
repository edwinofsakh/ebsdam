N = 16;
S = 20;
xo = [0.25  0.5 0.75  0.5  0.5  0.5];
yo = [ 0.5  0.5  0.5 0.25  0.5 0.75];
n = length(xo);
for i = 1:n
    ebsd = hexGrains(N,S,xo(i),yo(i));
    viewSizes( ['hexO' int2str(i)], 0, ebsd, 1, 0.1, 0);
end

N = [8 16 24];
S = 20;
xo = 0.5;
yo = 0.5;
n = length(N);
for i = 1:n
    ebsd = hexGrains(N(i),S,xo,yo);
    viewSizes( ['hexN' int2str(i)], 0, ebsd, 1, 0.1, 0);
end

N = 16;
S = [5 10 20];
xo = 0.5;
yo = 0.5;
n = length(S);
for i = 1:n
    ebsd = hexGrains(N,S(i),xo,yo);
    viewSizes( ['hexS' int2str(i)], 0, ebsd, 1, 0.1, 0);
end