function paint_boundary2( grains, OR_name, epsilon, drawExt, drawType, drawColor)
%Paint KOG-like boundary by attributes
%   Paint KOG-like boundary by angle, package or Bain group.
%
% Syntax
%   paint_boundary2( grains, OR_name, epsilon, drawExt, drawType, drawColor)
%
% Input 
%   grains      - MTEX grains set (use getGrains or calcGrains)
%   OR_name     - orienarion relation name, specify KOG
%   epsilon     - KOG threshold, in radian
%   drawExt     - 'ext' for draw only extern boundary, 0 for draw all boundary
%   drawType    - attribute type: 
%                   * 'hi-lo' - angle
%                   * 'pkg'   - package
%                   * 'bain'  - Bain group
%   drawColor   - coloring:
%                   * 'clr'   - color
%                   * 'gray'  - grayscale
%                   * 'del'   - white
%
% History
% 21.11.12  Isolate plotting function. Add Bain group.
% 07.12.12  Add 'epsilon'. Replace drawExt from '1' to 'ext'.
% 06.03.13  Move to MTEX 3.3.2: replace 'color' to 'linecolor'.

lw = 2.0;
d = epsilon*degree;

%grains = grains_cut;

[~,~,dis,~] = calcKOG3(OR_name);
% ??? dis = dis(1:end); % 21.11.12 I cann't understand this string

a = angle(dis)/degree;
ind_l = find(a < 35);
ind_h = find(a > 35);

% Disorientation in and out package
[~, ~, ~, ~, ~, in_cp, out_cp, in_b, out_b] = getORVarInfo( );

% % Check pairs
% [~,~,umi] = getAA(dis(dis_in_p))
% [~,~,umo] = getAA(dis(dis_out_p))
figure();

% cmap = colormap(jet(length(dis)));

if (drawExt)
    plotBoundary(grains, 'linecolor','k','linewidth',lw,'antipodal','ext');
else
    plotBoundary(grains, 'linecolor','k','linewidth',lw,'antipodal');
end;

% Color settings
switch (drawColor)
    case 'clr'
    lclr = 'b';
    hclr = 'r';
    iclr = [0.8 1   0.8]; %'b';
    oclr = [0   0.7 0  ]; %'r';
    case 'gray'
    lclr = [0.7, 0.7, 0.7];
    hclr = [0.9, 0.9, 0.9];
    iclr = [0.9, 0.9, 0.9];
    oclr = [0.7, 0.7, 0.7];   
    case 'del'
    lclr = [0.999, 0.999, 0.999];
    hclr = [0.999, 0.999, 0.999]; 
    iclr = [0.999, 0.999, 0.999];
    oclr = [0.999, 0.999, 0.999];   
end

switch drawType
    case 'pkg'
        plotInOut(grains, dis, in_cp, out_cp, iclr, oclr, lw, d, drawExt);
    case 'bain'
        plotInOut(grains, dis, in_b, out_b, iclr, oclr, lw, d, drawExt);        
    case 'hi-lo'
        plotInOut(grains, dis, ind_l, ind_h, lclr, hclr, lw, d, drawExt);
    otherwise
        error('Invalid drawing type');
end

hold off;
end

function plotInOut( grains, dis, iind, oind, iclr, oclr, lw, d, drawExt)

% In package
for i = iind
    if (strcmp(drawExt,'ext'))
        hold on, plotBoundary(grains,'property',rotation(dis(i)),'linecolor',iclr,'linewidth',lw, 'delta', d, 'antipodal','ext');
    else
        hold on, plotBoundary(grains,'property',rotation(dis(i)),'linecolor',iclr,'linewidth',lw, 'delta', d, 'antipodal');
    end
    fprintf(1,'.');
end

% Out package
for i = oind
    if (strcmp(drawExt,'ext'))
        hold on, plotBoundary(grains,'property',rotation(dis(i)),'linecolor',oclr,'linewidth',lw, 'delta', d, 'antipodal','ext');
    else
        hold on, plotBoundary(grains,'property',rotation(dis(i)),'linecolor',oclr,'linewidth',lw, 'delta', d, 'antipodal');
    end
    fprintf(1,'.');
end

fprintf(1,'\n');
end
