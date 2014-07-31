function [ ou, wu ] = calcWeigth( o, a )
%calcWeigth Summary of this function goes here
%   Detailed explanation goes here

or = fix_o(o, a);
ou = unique(or)
wu = zeros(1,length(ou));

for i = 1:length(ou)
    wu(i) = length(find(or == ou(i)));
end

% w = wr(n);
% 
% for i = 1:length(o)
%     ind = find(or, o(i), a2);
%     if (length(ind) > 1)
%         error('Bad ind');
%     end
%     w(i) = wr(ind);
% end

end

