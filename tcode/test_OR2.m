% Test Orientation Relations determine in MTEX
%% Find unique variants

% Orientation relation from alpha to gamma
[ORmat, ORm] = getOR('KS');

% Check main direction
ORm * Miller(0,1,1)
ORm * Miller(-1,-1,1)

ORm * vector3d(0,1,1)
ORm * vector3d(-1,-1,1)

ORmat * [0,1,1]'
ORmat * [-1,-1,1]'

% Plot axes
figure;
plot([symmetrise(ORm * Miller(1,0,0)),...
      symmetrise(ORm * Miller(0,1,0)),...
      symmetrise(ORm * Miller(0,0,1))],...
    'antipodal');

figure;
plot(symmetrise(ORm * symmetrise(Miller(1,0,0, symmetry('m-3m')))), 'antipodal');

figure;
plotpdf(ORm, Miller(1,0,0), 'antipodal', 'complete')

% Get new phase orientations
O2 = orientation('Euler', 0,0,0, symmetry('m-3m'), symmetry('1')) * ORm;

figure;
plot(symmetrise(O2) * symmetrise(Miller(1,0,0, symmetry('m-3m'))), 'antipodal');

symmetrise(O2) \ matrix(O2(1))

r = symmetrise(O2) * inverse(rotation(O2(1)));
o = orientation(r, symmetry('m-3m'), symmetry('1'));