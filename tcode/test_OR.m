function test_OR(cap)
% Testing OR functions
% For checking Pole figure see: Articles\EBSD\Pancholi_V.pdf
%   V. Pancholi. Self-accommodation in the bainitic microstructure of 
%   ultra-high-strength steel


% Orientation relation
OR_name = 'KS';
OR = getOR(OR_name);

% Symmety crystal and specimen
CS = symmetry('m-3m');
SS = symmetry('1');

% Set 'Null' orientation
r0 = rotation('Euler', 0*degree, 0*degree, 0*degree);
o0 = orientation(r0, CS, SS);

% Set 'Test' orientation
r1 = rotation('Euler', 222*degree, 234*degree, 318*degree);
o1 = orientation(r1, CS, SS);

r2 = rotation('Euler', 3*degree, 137*degree, 38*degree);
o2 = orientation(r2, CS, SS);

r3 = rotation('Euler', 39*degree, 24*degree, 184*degree);
o3 = orientation(r3, CS, SS);

% Vectors
h0 = [Miller(1,0,0)];
hv = CS*h0;
hv = unique(hv);
hv = Miller(hv);

[o,omega] = project2FundamentalRegion([o1 o2 o3]);

angle(r2,r3)/degree
angle(o2,o3)/degree
min(min(angle_outer(CS*r2,CS*r3)))/degree
min(min(angle_outer((r2*CS).',(r3*CS).')))/degree

angle(r2)/degree
angle(CS*r2)'/degree
angle(r2*CS)/degree

axis(r2)
axis(CS*r2)
axis(r2*CS)

figure
v = vector3d(1,0,0);
plot(CS*r2*v, 'antipodal', 'MarkerSize', 3, 'complete', 'grid', 'MarkerColor','b')
hold all
plot( r2*CS*v, 'antipodal', 'MarkerSize', 3, 'complete', 'grid', 'MarkerColor','r')
hold off

figure
plot(r2*CS, 'AXISANGLE', 'MarkerColor','r')
hold all
plot((r2*CS)', 'AXISANGLE', 'MarkerColor','g')
hold all
plot((r2*CS).', 'AXISANGLE', 'MarkerColor','b')
hold all
plot(CS*r2, 'AXISANGLE', 'MarkerColor','k')
hold off

%% Variant 1. Draw orientation relation
if cap(1)
    % Set misorientation
    mis = orientation('matrix', OR, CS, CS);
    misb = orientation('matrix', OR^-1, CS, CS);

    % Get all variants of misorientation
    v = symmetrise(mis);
    ov = orientation(v, SS,SS);
    vb = symmetrise(misb);
    ovb = orientation(vb, SS,SS);
    
    figure
    plot1(ov,[OR_name ' g2a v1']);
    
    figure
    plot1(ovb, [OR_name ' g2a v1']);
end

%% Variant 2.
if cap(2)
    % Set misorientation
    mis = orientation('matrix', OR, SS, CS);
    misb = orientation('matrix', OR^-1, SS, CS);

    % Get all variants of misorientation
	v = symmetrise(mis);
    vb = symmetrise(misb);
    length(v)
    
    % Forward transformation
    figure
    plot2(o1, v*o1, [OR_name ' g2a v2']);

    % Backward transformation
    figure
    plot2(o1, vb*o1, [OR_name ' a2g v2']);

end

%% Variant 3.
if cap(3)
    % Set misorientation
    mis = rotation('matrix', OR);
    misb = rotation('matrix', OR^-1);

    % Get all variants of misorientation
    v = rotation(CS)*rotation(mis)*rotation(CS);
    vb = rotation(CS)*rotation(misb)*rotation(CS);
    
    figure('Name', [OR_name ' g2a v3']);
    plot3(o1*hv, r1*vb*hv)
    
    
    figure('Name', [OR_name ' a2g v3']);
    plot3(o1*hv, r1*vb*hv)
end


%% Variant 4.
if cap(4)
    % Set misorientation
    mis = rotation('matrix', OR);
    misb = rotation('matrix', OR^-1);

    % Get all variants of misorientation
    v = rotation(CS)*rotation(mis)*rotation(CS);
    vb = rotation(CS)*rotation(misb)*rotation(CS);

    figure
    plot3(CS*r1, symmetrise(o1));
    
    figure('Name', [OR_name ' g2a v4']);
    plot3(o1*hv, v*r1*hv)
    
    figure('Name', [OR_name ' a2g v4']);
    plot3(o1*hv, vb*r1*hv)
    
    % check variant
    vs = v*r1;
    c = 0;
    for i = 1:length(vs)
        ps = rotation(CS)*rotation(misb)*rotation(CS)*vs(i);
%         eq = sum(sum(ps == r1));
        eq = sum(sum(angle(ps,r1) < 1*degree));
        if eq >= 1
            c = c + eq;
        end
    end
    c
    
    % check variant
    c = 0;
    c1 = 0;
    for i = 1:length(vs)
        ps0 = rotation(CS)*rotation(misb)*rotation(CS)*vs(i);
        ps1 = (rotation(misb)*rotation(CS)*vs(i)*CS).';
        ps = orientation(rotation(misb)*rotation(CS)*vs(i), CS, SS);
        ps = symmetrise(ps);
        ps = ps(:);
        for j = 1:length(ps0)
            c1 = c1 + sum(sum(angle(ps,ps1(j)) < 1*degree));
        end
        eq = sum(sum(angle(ps,r1) < 1*degree));
        if eq >= 1
            c = c + eq;
        else
            test = 1;
        end
    end
    c
end

end

function plot1 (o, name)
%
%
h = [Miller(1,0,0) Miller(1,1,0) Miller(1,1,1)];

plotpdf(o, h,...
    'antipodal', 'MarkerSize', 3, 'complete', 'grid', ...
    'FigureTitle', name);

end

function plot2 (o1, o2, name)
%
%
plot1 (o1, name)
hold all

plot1 (o2, name)
hold off

end

function plot3 (v1, v2)
%
%
plot(v1, 'antipodal', 'MarkerSize', 3, 'complete', 'grid', 'MarkerColor','b');
hold all
plot(v2, 'antipodal', 'MarkerSize', 3, 'complete', 'grid', 'MarkerColor','r');
hold off

end
    
