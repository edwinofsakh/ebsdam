function [ang, upairs, dis1, udis1, pair_ind] = calcKOG3 (ORdata,varargin)
% calcucate KOG
%
%% Description
%  Function *calcKOG* calcucate disorientation angle for orientation 
%  relation. Angle round to 0.001.
%  (Vfb * Cn * Mbcc) * inv(Vfb * Cm * Mbcc) =
%  = (Vfb * Cn * Mbcc) * (Mbcc^-1 * Cm^-1 * Vfb^-1) = 
%  = Vfb * Cn * Cm^-1 * Vfb^-1
%
%% Syntax
%  ang = calcKOG(ORdata) -
%  ang = calcKOG(ORdata,'display') -
%
%% Input
%  ORdata	- data for orientation relation
%    currently available:
%
%    * 'KS' - Kurdjumov-Sachs
%    * 'K'  - Kelly
%    * 'NW' - Nishiyama-Wasserman
%    * 'V1' - from G. Miyamoto article doi:10.1016/j.actamat.2010.08.001
%
%% Output
%  ang  - list of unique disorientation angles
%  Nang - fraction of angles
%  axe  - list of unique disorientation axes
%  Naxe - fraction of axes
%  dis  - list of unique disorientation pairs of angle and axis
%  Ndis - fraction of pairs
%
%% Flags
%  display - plot histogram and print table.
%
%% See also
%  getOR

% TODO
% 1. Remove "Warning: Symmetry mismatch!"


ORmat = getOR(ORdata);

CS = symmetry('m-3m');
SS = symmetry('1');

% ORo = orientation('matrix', ORmat, CS, SS);
ORo = rotation('matrix', ORmat);

% ORoa = CS * ORo;
ORoa =  rotation(CS) * ORo;

% dis = inverse(ORoa) * ORoa;
dis1 = inverse(ORoa(1)) * ORoa(2:end);

% dis = orientation(dis, CS, CS);
dis1 = orientation(dis1, CS, CS);

% [ang, axe, pairs] = getAA(dis);
[ang, axe, pairs1] = getAA(dis1);

% [upairs1, m, n] = unique(pairs1,'rows');
% udis1 = dis1(m);

% Round angle
ang = round(ang*100)/100;

% Get unique misorientations
uang = unique(ang(:));
uaxe = unique(axe,'antipodal'); %#ok<NASGU>
[upairs, m, pair_ind] = unique(pairs1,'rows','first');
udis1 = dis1(m);

%% Plotting
if check_option(varargin,'display')
    ORo = orientation(ORo, CS, SS);
    ORoa = orientation(ORoa, CS, SS);

    figure;
    disp('plot OR');
    plotpdf(ORo, Miller(1,0,0), 'antipodal', 'MarkerSize', 6);

    figure;
    disp('plot ORoa');
    plotpdf(ORoa, Miller(1,0,0), 'antipodal', 'MarkerSize', 6);

    % figure;
    % disp('plot dis');
    % plotpdf(dis(:), Miller(1,0,0), 'antipodal', 'MarkerSize', 4);

    figure;
    disp('plot dis1');
    plotpdf(dis1(1:10), Miller(1,0,0), 'complete', 'antipodal', 'MarkerSize', 3);
    % plot(dis1(:), 'antipodal', 'MarkerSize', 4);
    hold on;
    plotpdf(dis1(11:23), Miller(1,0,0), 'complete', 'antipodal', 'MarkerSize', 3,'MarkerColor','b');
    hold off;
end

% figure;
% disp('plot udis1');
% plotpdf(udis1(:), Miller(1,0,0), 'antipodal', 'MarkerSize', 4);
% plot(udis1(:), 'antipodal', 'MarkerSize', 4);
% hold on;
% plotpdf(udis1(:), Miller(-1,0,0), 'antipodal', 'MarkerSize', 4);
% hold off;

% disp(['Unique Angles  ' num2str(length(uang))]);
% disp( uang );
% disp('Unique Axes');
% disp( uaxe );
% disp(['Unique Pairs  ' num2str(length(upairs))]);
% disp( upairs );

% figure;
% disp('plot axe');
% plot(axe, 'antipodal', 'MarkerSize', 6);

if check_option(varargin,'display')
    figure;
    [n, xout] = hist(ang,uang);
    n = n / sum(n);
    disp(['  KOG ' nameOR(ORdata) '  ']);
    disp( num2str([xout, round(n'*10000)/100]) );
    bar(xout, n);
end


% % % ORo = orientation('matrix', ORmat, CS, SS);
% % ORo = orientation('matrix', ORmat, SS, CS);
% % Bas = orientation('Euler', 1,0,0, CS, SS);
% % % ORo = rotation('matrix', ORmat);
% % 
% % ORoa = symmetrise(ORo);
% % % ORoa = rotation(CS) * ORo;
% % % ORoa = CS * ORo;
% % 
% % % dis = (CS * ORo)^-1 * (CS * ORo) = (ORo^-1 * CS^-1) * (CS * ORo)
% % dis = inverse(ORoa) * ORoa;
% % diso = inverse(ORo) * ORo;
% % 
% % % dis = orientation( dis, CS, SS);
% % 
% % figure;
% % %plot(ORo, 'antipodal', 'MarkerSize', 6);
% % plotpdf(ORo, Miller(1,0,0), 'antipodal', 'COMPLETE','MarkerSize', 6);
% % 
% % figure;
% % % plotpdf(dis, 'antipodal', Miller(1,0,0), 'MarkerSize', 6);
% % plot(diso, 'antipodal', 'MarkerSize', 6);

% % figure;
% % plotpdf(ORoa, Miller(1,0,0), 'antipodal');
% 
% % figure;
% % plotpdf(dis, Miller(1,0,0), 'antipodal');
% 
% ang = angle(dis)/degree;
% axe = axis(dis);
% test = ang(:);
% test2 = axe(:);
% p = [ang(:), getx(axe(:)),  gety(axe(:)),  getz(axe(:))];
% v = unique(axe(:));
% disp(p);
% disp('Unique Axe');
% % t = get(v(:),'hkl');
% disp( v );
% 
% figure;
% plot(axe);
% 
% ind = ang > ang(1);
% ang = ang(ind);
% 
% ang = round(ang*100)/100;
% tet = unique(ang)
% 
% if check_option(varargin,'display')
%     figure;
%     [xout, n] = hist(ang,tet);
%     n = n / sum(n);
%     disp(['  KOG ' nameOR(ORdata) '  ']);
%     disp( num2str([xout', n]) );
%     bar(n, xout);
% end

