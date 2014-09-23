function [reorder, group, ticks] = JapanOrder()

% Reorder 23 pairs of variants (from V2/V1 to V24/V1) to Japanese style
reorder = [...
       14,  8,  6, 16, 22,  9,  7, 17, 13,...
    1, 15,  3, 23, 11,  5, 19, 10, 20, 18,...
    4, 21, 12,  2];

% Group equal pairs of varints
group = {2, [3 5], 4, 6, 7, 8, [9 19], [10 14], [11 13], [12 20], [15 23], 16, 17, [18 22], 21, 24};

% Ticks for group of pairs of variants
ticks = {'V2', 'V3-V5', 'V4', 'V6', 'V7', 'V8', 'V9-V19', 'V10-14', 'V11-V13', 'V12-V20', 'V15-V23', 'V16', 'V17', 'V18-V22', 'V21', 'V24'};


% Reorder for OR variants. Even variant must be mupliple by matrix [1 0 0; 0 -1 0; 0 0 -1] for
% matching with plan/direction matrix
ind = [1 15 17 7 9 23, 10 8 21 14 4 19, 2 24 13 6 20 11, 18 16 5 22 12 3];

end