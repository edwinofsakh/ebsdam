% Check Misorientation after double transformation
close all
clear all

% Set orientation relation
OR = getOR('KS');
% OR = getOR([26.303782 7.429378 19.703782]*degree); % sel01
% OR = makeOR([0,1,1]',[1,1,1]',[-1,-1,1]',[-1,0,1]','g2a');
ORi = inv(OR);

% Symmety crystal and specimen
CS = symmetry('m-3m');
SS = symmetry('1');

% Set 'Null' orientation
r0 = rotation('Euler', 0*degree, 0*degree, 0*degree);
o0 = orientation(r0, CS, SS);

%% First transformation orientations
v1 = getVariants(o0, OR, CS);
a1 = angle(v1\v1)/degree;
u1 = unique(fix(a1*100)/100);
length(u1)
figure; hist(a1(:),64);

%% Second transformation orientations
v2 = getVariants(v1, ORi, CS);
a2 = angle(v2\v2)/degree;
u2 = unique(fix(a2*100)/100);
length(u2)
figure; hist(a2(:),64);

%% Second to first misorientation
a21 = angle(v2\v1)/degree;
u21 = unique(fix(a21*100)/100);
length(u21)
figure; hist(a21(:),64);

%% Check Matrix
v = getVariants(o0, OR, CS);
a = angle(v\v)/degree;
u = unique(fix(a*100)/100);

vi = getVariants(o0, ORi, CS);
ai = angle(vi\vi)/degree;
ui = unique(fix(ai*100)/100);

2*(u - ui)./(u + ui)*100
