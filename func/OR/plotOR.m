function plotOR( ORname, varargin)
% Plot pole figure for set of orientation relationships
%
% Syntax
%   plotOR( ORname, complete, cmap )
%
% Input
%   ORname  - orientation relationship name or cell array of names
%
% Options
%   'complete' - if 1 draw full figure, else  only {100}, {010}, {111}
%
% History
% 17.04.13  Separate from 'findUniqueParent.m'

% Convert to cell
if ~iscell(ORname)
    ORname = {ORname};
end

% OR matrix (from gamma to alpha)
n = length(ORname);
ORmat = cell(1,n);
ORmat = cellfun(@(x) inv(getOR(x)), ORname, 'UniformOutput', false);

from = '\gamma';
showBase = 1;
cb = [0.5 0.5 0.5];

if (showBase)
    plot([vector3d(1,0,0) vector3d(0,1,0) vector3d(0,0,1)],...
        'label', {['100' from],['010' from],['001' from]},...
        'antipodal','grid_res',15*degree,...
        'MarkerColor', cb, 'MarkerSize',3);
    hold on;
end

% Set symmetry
CS = symmetry('m-3m');
SS = symmetry('-1');

for i = 1:n
    if check_option(varargin,'complete')
        e = orientation('euler', 0,0,0, CS, SS);
        v = getVariants(e, ORmat{i}, CS);
    else
        v = orientation('matrix', ORmat{i}, symmetry('m-3m'), symmetry('-1'));
    end
    u = symmetrise(vector3d(1,0,0),CS);
    if check_option(varargin,'labels')
        for j = 1:length(v)
            text
            plot(v(j)*u, 'label', num2str(j), 'FontSize', 10, 'FontName','FixedWidth',...
                'antipodal', 'MarkerSize',3, 'MarkerColor','k');
            hold on;
        end
    else
        plot(v*u, 'antipodal', 'MarkerSize',3, 'MarkerColor','k');
        hold on;
    end
end

hold off;
end
