function markRegion(ebsd, name, xy)
% Mark region on full map
%
% Syntax
%   markRegion(ebsd, name, xy);
%
% Input
%   ebsd	- full EBSD data
%   name    - region name
%   xy      - region coordiantes
%
% Example
%   markRegion(ebsd, 'o1', [10 10 20 20]);
%
% History
% 17.08.14  Original implementation


setpref('mtex', 'border', 22);

plot(ebsd, 'antipodal', 'r',zvector); hold on;

switch(length(xy))
    case 1
        title(['Mark region ''' name ''' (full)']);
    case 4
        x = xy(1); y = xy(2);
        w = xy(3); h = xy(4);
        rectangle('Position',[x,y,w,h],'LineWidth',1.5, 'LineStyle','--','EdgeColor','k');
        title(['Mark region ''' name '''']);
    otherwise
        line(xy(:,1),xy(:,2), 'LineWidth',1.5,'LineStyle','--', 'Color', 'k');
        title(['Mark region ''' name '''']);
end
hold off;

setpref('mtex', 'border', 10);
end
