function [ xy ] = selectRegion( varargin )
%Select region on last figure.
%   Smart interface for ginput. Can draw selected part.
%
% Options
%  'smartSelection' - draw selected part
%  'closeSelction'  - add first element to end

if (check_option(varargin, 'smartSelection'))
    xy = [];
    i = 1;
    ixy = ginput(1);
    while (~isempty(ixy))
        if (i > 1)
            hold on; line([xy(end, 1), ixy(:,1)], [xy(end, 2), ixy(:,2)]);
        end

        xy = [xy; ixy];
        i = i + 1;

        ixy = ginput(1);
    end
else
    xy = ginput();
end

hold on; line(xy([1:end,1],1),xy([1:end,1],2),'Color','r'); hold off;

if (check_option(varargin, 'closeSelection'))
    xy = xy([1:end,1]);
end