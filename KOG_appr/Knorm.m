function ffn = Knorm(f)
% Reorder variant to Japanese style
    reorder = [...
           14,  8,  6, 16, 22,  9,  7, 17, 13,...
        1, 15,  3, 23, 11,  5, 19, 10, 20, 18,...
        4, 21, 12,  2];
    % Group equal varints
    group = {2, [3 5], 4, 6, 7, 8, [9 19], [10 14], [11 13], [12 20], [15 23], 16, 17, [18 22], 21, 24};
    
    % Calc new Japanese style variant fraction
    f1 = [0; f(reorder)];
    ff = zeros(1,length(group));
    for i=1:length(group)
        ff(i) = sum(f1(group{i}));
    end
    ffn=ff*100/sum(ff);