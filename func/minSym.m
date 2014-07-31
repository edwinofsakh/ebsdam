% find symmetry matrices for min Theta
function [N, T] = minSym (Vfb, Mfcc, Mbcc, np, Sym, nSym )

N = zeros (2, np);
T = zeros (1, np);

for p = 1:np
    ThetaArr = zeros(24,24);
    for i = 1:nSym
        for j = 1:nSym
            %D = ( (Vfb*Sym(i)*Mfcc) * inverse((Sym(j)*Mbcc{p}{1})) );
            D = ( (Vfb*Sym(i)*Mfcc) \ (Sym(j)*Mbcc{p}{1}) );
            Theta = angle(D);
            %Theta1 = angle(D1);
            ThetaArr(i,j) = Theta;
        end
    end
    % ???
    [C,IndArr] = min (ThetaArr,[],1);
    [M,Ind] = min (C);
    % fix i and j
    N(1,p) = IndArr(Ind);
    N(2,p) = Ind;
    T(1,p) = M;
end

end