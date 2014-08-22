function plotBndRange( grains, thr, saveres, newfig, odir, prefix, bndType, ranges, colors, varargin)
% Plot boundary map coloring range of misorientation angle
% 
% Syntax
%   plotBndRange( grains, thr, saveres, newfig, odir, prefix, bndType, ranges, colors, varargin)
%
% Input
%   grains  - grains
%   thr     - boundary detection thershold, in radian
%   saveres - see main function
%   odir    - output directory
%   prefix  - file name prefix
%   bndType - possible value: 'allbnd' - all boundary, 'ext' - external, 
%           	'sub' - internal
%   ranges  - booundary ranges in style [2 5 10 15]
%   colors  - color for ranges
%
% History
% 27.03.13  Separate from 'viewGrains'.
% 14.04.13  Add saveing of comment.
% 15.08.14  Cleanup. Add dynamic range.

    comment = getComment();
    
    rng = [ranges 90];
    n = length(rng);

    if (newfig == 1)
        figure();
    end
    
    if colors == 0
        cmap = colormap(lines(n-1));
    else
        cmap = colors;
    end
    
    leg = {};
    
    w = [1.2 1.2 1.2];
    for i = 1:n-1
        hold on, plotBoundary(grains,'property',[rng(i)  rng(i+1)]*degree, 'linecolor',cmap(i,:), bndType, 'linewidth', w(i), varargin{:});
        if (rng(i) == 0)
            leg = [leg , ['<' num2str(rng(i+1)) '^\circ']];
        elseif (i == n-1)
            leg = [leg , ['>' num2str(rng(i)) '^\circ']];
        else
            leg = [leg , [num2str(rng(i)) '^\circ - ' num2str(rng(i+1)) '^\circ']];
        end
    end

    hold off;
    
    saveimg( saveres, 0, odir, prefix, ['af_' bndType], 'png', comment);
    
	if (newfig == 1)
        legend(leg,'Location','EastOutside');
    else
        legend(['data', leg],'Location','EastOutside');
    end

    saveimg( saveres, 1, odir, prefix, ['af_l' bndType], 'png', comment);
end

