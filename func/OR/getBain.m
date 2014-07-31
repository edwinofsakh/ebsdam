function [ B, Br ] = getBain(varargin)
% Get rotation matrix for Bain groups and display it on pole figure.
%
% Syntax
%   [ B, Br ] = getBain('display')
%
% Output
%   B       - Bain group matrix
%   Br      - Bain group rotation
%
% Options
%   'display'   - display Bain groups on pole figure
%
% History
% 09.10.13  Original implementation
% 09.04.14  Fix function. Old version get strange results. Recomment.

doPlotting = check_option(varargin, 'display');

B = cell(1,3);
Br = rotation();

Br(1) = rotation('axis', vector3d(1,0,0), 'angle', 45*degree);
Br(2) = rotation('axis', vector3d(0,1,0), 'angle', 45*degree);
Br(3) = rotation('axis', vector3d(0,0,1), 'angle', 45*degree);

for i = 1:3
    B{i} = matrix(Br(i));
end

%% Plotting
if doPlotting
    %% Plotting options
    % Axis options
    from = '\gamma';
    cb = [0.5 0.5 0.5];

    % Markers type
    mt = {'o','^','s','p'};

    %% Plot CP group

    % Plot axis
    figure('Name', 'CP Group');
    plot([vector3d(1,0,0) vector3d(0,1,0) vector3d(0,0,1)],...
        'label', {['100' from],['010' from],['001' from]},...
        'antipodal','grid_res',15*degree, 'MarkerColor', cb);
    hold on;

    for i = 1:3
        % Plot variants
        p = [Br(i)*vector3d( 1,0,0); Br(i)*vector3d(0, 1,0); Br(i)*vector3d(0,0, 1);...
             Br(i)*vector3d(-1,0,0); Br(i)*vector3d(0,-1,0); Br(i)*vector3d(0,0,-1)];
        plot(p, 'antipodal', 'Marker',mt{i}); hold on;
     end

    legend('{100}_\gamma', 'B_1', 'B_2', 'B_3')
    hold off;
end