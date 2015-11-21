function paint_boundary4( grains, ORdata)
%Paint KOG-like boundary
%
% Syntax
%   paint_boundary4( grains, OR_name, epsilon)
%
% Input 
%   grains      - MTEX grains set (use getGrains or calcGrains)
%   ORdata      - data for orienarion relationship, specify KOG
%   epsilon     - KOG threshold, in degree
%   drawExt     - 'ext' for draw only extern boundary, 0 for draw all boundary

%   -drawType    - attribute type: 
%                   * 'hi-lo' - angle
%                   * 'pkg'   - package
%                   * 'bain'  - Bain group
%   -drawColor   - coloring:
%                   * 'clr'   - color
%                   * 'gray'  - grayscale
%                   * 'del'   - white
%
% History
% 17.09.13  New version of function. Use modified MTEX code.

% Color settings
switch (drawColor)
    case 'clr'
    color_in  = [0.8 1   0.8]; %'b';
    color_out = [0   0.7 0  ]; %'r';
    case 'gray'
    color_in  = [0.9, 0.9, 0.9];
    color_out = [0.7, 0.7, 0.7];   
    case 'del'
    color_in  = [0.999, 0.999, 0.999];
    color_out = [0.999, 0.999, 0.999];   
end

lw = 2.0;
d = epsilon*degree;

[~,~,dis,~] = calcKOG3(ORdata);
a = angle(dis)/degree;

[~, ~, ~, ~, ~, in_cp, ~, in_b, ~] = getORVarInfo();

in = zeros(23,1);
switch drawType
    case 'pkg'
        in(in_cp) = 1;
    case 'bain'
        in(in_b) = 1;        
    case 'hi-lo'
        in(a < 35) = 1;
    case 'far'
        in(1) = 1; %just skip
    otherwise
        error('Invalid drawing type');
end
in = logical(in);

mycolormap = zeros(23,3);

mycolormap(in,:) = repmat(color_in,sum(in),1);
mycolormap(~in,:) = repmat(color_out,sum(~in),1);
    
% figure();

if (strcmpi(drawType,'far'))
    plotBoundary(grains,'property',dis,'NOnearest','nodegree',...
        'linewidth',lw, 'delta', 90, 'antipodal','ext');
    colormap(1-gray);
    brighten(-0.8);
    
else
    
    if (drawExt)
        plotBoundary(grains, 'linecolor','k','linewidth',lw,'antipodal','ext');
    else
        plotBoundary(grains, 'linecolor','k','linewidth',lw,'antipodal');
    end;

    if (strcmp(drawExt,'ext'))
        hold on, plotBoundary(grains,'property',dis,'nearest','nodegree',...
            'linewidth',lw, 'delta', d, 'antipodal','ext');
    else
        hold on, plotBoundary(grains,'property',dis,'nearest','nodegree',...
            'linewidth',lw, 'delta', d, 'antipodal');
    end

    colormap(mycolormap);

    hold off;
end
end