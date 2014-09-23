function HistNearKOG(grains, epsilon, optOR, allbnd, saveres, OutDir, prefixk, desc, comment)
% Plot and
%   Detailed explanation goes here
%
% Syntax
%   HistNearKOG(grains, epsilon, optOR, allbnd, saveres, OutDir, prefixk, desc, comment)
%
% Input
%   grains
%   epsilon
%   optOR
%   allbnd
%   saveres
%   OutDir
%   prefixk
%   desc
%   comment
%
% Used in
%   viewGrains
% 
% History
% ??.??.??  Original implementation
% 21.09.14  Add description

f = fracKOG(grains, epsilon, optOR, allbnd);

optORn = nameOR(optOR);

% Draw all variant fraction
figure();
bar(f);
saveimg( saveres, 1, OutDir, prefixk, [desc '_' optORn], 'png', comment);

[reorder, group, ticks] = JapanOrder();

% Calc new Japanese style variant fraction
f1 = [0; f(reorder)];
ff = zeros(1,length(group));
for i=1:length(group)
    ff(i) = sum(f1(group{i}));
end

% Draw Japanese style variant fraction
figure();
bar(ff/sum(ff)*100);
ylabel('Доля, %');
title('Относительные протяженности КОГ');
set(gca, 'XLim', [0 length(group)+1], 'XTick', 1:length(group), 'XTickLabel', ticks);
set(gca, 'YLim', [0 45]);
rotateticklabel(gca,45);
line([0 17],[100/23 100/23],'LineStyle','--','Color','k');

saveimg( saveres, 1, OutDir, prefixk, [desc '_J_' optORn], 'png', comment);

savexy( 1:length(ff), ff, saveres, OutDir, prefixk, [desc '_J_' optORn],...
    ['KOG fraction (in Vi-Vj format)' optORn], comment);
end