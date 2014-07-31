function plotBndRange( grains, thr, saveres, odir, prefix, bndType)
% Plot boundary map coloring range of misorientation angle
% 
% Input
%   grains  - grains
%   thr     - boundary detection thershold, in radian
%   saveres - see main function
%   odir    - output directory
%   prefix  - file name prefix
%   fname   - file name
%   ltitle  - data title (name 'title' is used)
%   bndType - possible value: 'allbnd' - all boundary, 'ext' - external, 
%           	'sub' - internal
% History
% 27.03.13  Separate from 'viewGrains'.
% 14.04.13  Add saveing of comment.

    comment = getComment();
    
    figure();
    cmap = colormap(lines(5));
    leg = {};
    if (thr < 1*degree)
        hold on, plotBoundary(grains,'property',[ 0  1]*degree  ,'linecolor',cmap(1,:), bndType);
        leg = [leg , '<1^\circ'];
        hold on, plotBoundary(grains,'property',[ 1  2]*degree  ,'linecolor',cmap(2,:), bndType);
        leg = [leg , '1^\circ-2^\circ'];
    else
        if (thr < 2*degree)
            hold on, plotBoundary(grains,'property',[ 0  2]*degree  ,'linecolor',cmap(3,:), bndType);
            leg = [leg , '<2^\circ'];
        end
    end
    hold on, plotBoundary(grains,'property',[ 2  5]*degree ,'linecolor',cmap(4,:), bndType);
    leg = [leg , '2^\circ-5^\circ'];
    hold on, plotBoundary(grains,'property',[ 5 12]*degree ,'linecolor',cmap(5,:), bndType);
    leg = [leg , '5^\circ-12^\circ'];
    hold on, plotBoundary(grains,'property',[12 90]*degree ,'linecolor','k',       bndType);
    leg = [leg , '>12^\circ'];

    saveimg( saveres, 0, odir, prefix, ['af_' bndType], 'png', comment);
    
    legend(leg,'Location','EastOutside');

    saveimg( saveres, 1, odir, prefix, ['af_l' bndType], 'png', comment);
end

