function [ frg_info1 ] = uniteFragments( grains, frg_info0, w, varargin )
% Unite fragments with close orientation
%
% Syntax
%   [ frg_info1 ] = uniteFragments(grains, frg_info0, w );
%
% Output
%   frg_info1 - information about fragments:
%       frg     - index of grains in fragments
%       frg_po  - parent orientation of fragments
%       grn_frg - index of fragments for all grains
%       grn_po  - possible parent orientation of grains
%   (old)gf1  - new index of grains in fragments
%   (old)oop1 - new parent orientation of fragments
%
% Input
%   frg_info0 - information about fragments:
%   (old)gf   - index of grains in fragments
%   (old)opp  - parent orientation of fragments
%   w         - tolerance angle
%
% History
% 12.04.13  Original implementation

frg0     = frg_info0{1};
frg_po0  = frg_info0{2};
grn_frg0 = frg_info0{3};
grn_po0  = frg_info0{4};

frg_po1 = frg_po0;
frg1 = frg0;
n = length(frg_po1);

if w == 0
    frg_info1 = frg_info0;
    return;
end

if (isdebug)
    figure; plotpdf(frg_po1,Miller(1,0,0),'antipodal', 'MarkerSize', 4);
end
            
if 0
    h = waitbar(0,'Unite fragments...');
    
    i = 1;
    % For all fragments
    while i < n
    %     ind = i;
        mis = angle(frg_po1,frg_po1(i));
        mm = (mis < w)';

        % Coordinates of grain center
        c = centroid(grains);

        % Find fragments with close orientations
        if (sum(mm) > 1)
            if (isdebug)
                plotpdf(frg_po1(mm),Miller(1,0,0),'antipodal', 'MarkerSize', 4);
            end

%             frg_po1(i) = mean(frg_po1(mm));
%             frg1{i} = unique([frg1{mm}]);
%             a = ~mm;
%             b = (1:n == i);
%             frg_po1 = frg_po1(a | b);
%             frg1 = frg1(a | b);
            [frg1, frg_po1] = add2Frg(frg1, frg_po1, i, mm, 0);
            n = length(frg_po1);
        end

        i = i+1;
        waitbar(i/n);
    end
    close(h);
else
    flag = 1;
    while flag
        mis = angle(frg_po1\frg_po1);
        mm = (mis < w);
        [m, i] = max(sum(mm,1));
        if (m > 1)
            ind = mm(i,:);
            
            if (isdebug)
                h1 = figure;
                plotpdf(frg_po1(ind),Miller(1,0,0),'antipodal', 'MarkerSize', 4);
                hold on;
                plotpdf(frg_po1(i),Miller(1,0,0),'antipodal', 'MarkerSize', 4, 'MarkerColor', 'r');
                hold off;
                close(h1);
            end
            
            [frg1, frg_po1, mm] = add2Frg(frg1, frg_po1, i, ind, mm);
        else
            flag = 0;
        end
    end
end

if (isfulldebug)
    plotpdf(frg_po1,Miller(1,0,0),'antipodal', 'MarkerSize', 4);
end

% colorFragments(grains_fe, frg1);

grn_frg1 = group2item( frg1, numel(grains));
grn_po1 = cellfun(@(x) frg_po1(x), grn_frg1, 'UniformOutput',false);


frg_info1 = {frg1, frg_po1, grn_frg1, grn_po1};
end


function [frg1, frg_po1, mm1] = add2Frg(frg, frg_po, i, ind, mm)

n = length(frg_po);

frg_po(i) = mean(frg_po(ind));
frg{i} = unique([frg{ind}]);
a = ~ind;
b = (1:n == i);
frg_po1 = frg_po(a|b);
frg1 = frg(a|b);

if (size(mm,1) > 1) && (size(mm,2) > 1)
    mm1 = mm(a|b, a|b);
end

end
