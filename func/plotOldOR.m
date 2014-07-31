function plotOldOR()

figure;

name = {'KS', 'NW', 'M1', 'M2', 'B1', 'B2', 'B3'};
clr  = { 'r',  'b',  'k',  'k',  'k',  'k',  'k'};

for i = 1:length(name)
    ORmat = getOR(name{i});
    OR = orientation('matrix', ORmat, symmetry('m-3m'), symmetry('m-3m'));
    plotpdf(OR,Miller(1,0,0),'antipodal',...
                'MarkerSize',2, 'MarkerColor', clr{i}, 'complete');
    hold on;
end

hold off;
end