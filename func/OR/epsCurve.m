function epsCurve(sid, rid, mori, saveres, OutDir, prefix, comment, varargin)

ORname = get_option(varargin, 'start', 'KS');
ORmat = getOR(ORname);
OR = orientation('matrix', ORmat, symmetry('m-3m'), symmetry('m-3m'));
[phi1, Phi, phi2] = Euler(OR);
kog = getKOG(phi1, Phi, phi2);

epsa = [1 2 3 4 5 8 12 20 30 40 60]*degree;
a = cell(1,length(epsa));
n = zeros(1,length(epsa));

for i=1:length(epsa)
    a{i} = close2KOG(mori, kog, epsa(i));
    n(i) = length(a{i});
end

disp(num2str([epsa'/degree n']));
disp(length(mori));

plot(epsa/degree,n/length(mori), '-o', 'lineWidth', 1, 'MarkerSize', 4,'MarkerFaceColor', 'b');
ylim([0 1]);
xlabel('epsilon in degree');
ylabel('KOG fraction');
title(['Optimal epsilon for ' sid '\_' rid]);
saveimg( saveres, 1, OutDir, prefix, ['eps_curve_' nameOR(ORname)], 'png', comment);