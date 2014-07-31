function colorFragments( grains, grp )
% Colorize fragment
%   .
%
% Syntax
%   colorFragments( grains, gf )
%
% Output
%
% Input
%   grains	- list of grains
%   grp     - grains fragments
%
% History
% 17.04.13  Original impelemetion

n = length(grp);
cmap = colormap(hsv(n));

ng = size(grains,1);
itm = group2item(grp,ng);
clr = ones(ng,3);

for i = 1:ng
    if (~isempty(itm{i}))
        if length(itm{i}) > 1
            clr(i,:) = [0 0 0];
        else
            clr(i,:) = cmap(itm{i},:);
        end
    end
end

plotBoundary(grains, 'ext'); hold on;
plot(grains, 'property', clr); hold off;
colormap(cmap);
colorbar('YTickLabel',...
    cellfun(@(x) num2str(x),(num2cell((1:n+1))),'UniformOutput', false))

end
