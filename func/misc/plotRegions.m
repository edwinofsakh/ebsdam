function plotRegions(samples, regions, rxy)
% Summary of this function goes here
%   Detailed explanation goes here
%
% Syntax
%   ***
%
% Output
%   ***     - ***
%
% Input
%   ***     - ***
%
% Options
%   ***     - ***
%
% Example
%   ***
%
% See also
%   ***
%
% Used in
%   ***
%
% History
% 12.04.13  Original implementation

saveres = getpref('ebsdam','saveResult');
comment = getComment();

sid_set = unique(samples);

for sid = sid_set
    ind = cellfun(@(x) strcmpi(x, sid{:}), samples);
    ind = find(ind);
    ebsd = checkEBSD(sid{:}, 0,0);
    plot(ebsd, 'antipodal', 'r', zvector); hold all;
    

    OutDir = checkDir(sid{:}, 'maps', saveres);

%     xmax = max(get(ebsd, 'X'));
%     ymax = max(get(ebsd, 'Y'));
%     dx = 10;
%     dy = 12;
%     tx = xmax + dx;
%     ty = ymax - dy;
    
    for i = ind
        name = regions{i};
        xy = rxy{i};
        switch(length(xy))
            case 1
%                 mtex_text(tx, ty, name);
%                 line([tx xmax], [ty ymax], 'LineWidth',1.5, 'LineStyle','-', 'Color', 'b');
%                 [Xf, Yf] = DS2NFU([tx xmax], [ty ymax]);
%                 annotation('textarrow', Xf, Yf, 'String', name);
            case 4
                x = xy(1); y = xy(2);
                w = xy(3); h = xy(4);
                rectangle('Position',[x,y,w,h],'LineWidth',1.5, 'LineStyle','--','EdgeColor','k');
%                 mtex_text(tx, ty, name);
%                 [Xf, Yf] = DS2NFU([tx x+w], [ty y+h]);
%                 annotation('textarrow', Xf, Yf,  'String', name);
            otherwise
                line(xy(:,1),xy(:,2), 'LineWidth',1.5,'LineStyle','--', 'Color', 'k');
%                 mtex_text(tx, ty, name);
%                 line([tx xy(1,1)], [ty xy(1,2)], 'LineWidth',1.5, 'LineStyle','-', 'Color', 'b');
%                 [Xf, Yf] = DS2NFU([tx xy(1,1)], [ty xy(1,2)]);
%                 annotation('textarrow', Xf, Yf,  'String', name);
        end
%         ty = ty - dy;
    end
    saveimg( saveres, 1, OutDir, sid{:}, 'regions', 'png', comment );
end

end
