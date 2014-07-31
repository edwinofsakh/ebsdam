function [ output_args ] = misType( OR_name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[~,~,kog,~] = calcKOG3(OR_name);

% Reorder variant to Japanese style
reorder = [...
       14,  8,  6, 16, 22,  9,  7, 17, 13,...
    1, 15,  3, 23, 11,  5, 19, 10, 20, 18,...
    4, 21, 12,  2];

% Calc new Japanese style variant fraction
kogJ = kog(reorder);

% In Packet
a1 = angle(kogJ(1:5))/degree;
a2 =  axis(kogJ(1:5));
% [~,ind] = sort(a1);
% a1 = a1(ind);
% a2 = a2(ind);
a3 = [a1' sort(abs(get(a2,'hkl')),2)];
a3 = fix(a3*1000)/1000;
a3 = unique(a3, 'rows');
disp('In Packet');
disp('     angle         h         k         l');
disp(a3);

% Out Packet
a1 = angle(kogJ(6:23))/degree;
a2 =  axis(kogJ(6:23));
% [~,ind] = sort(a1);
% a1 = a1(ind);
% a2 = a2(ind);
a3 = [a1' sort(abs(get(a2,'hkl')),2)];
a3 = fix(a3*1000)/1000;
a3 = unique(a3, 'rows');
disp('Out Packet');
disp('     angle         h         k         l');
disp(a3);
end

