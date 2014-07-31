function Theta = optimizeTheta( x0, np, Mbcc, Vfb, cs, ss, N )

Theta0 = meanTheta (x0, np, Mbcc, Vfb, cs, ss, N);

f = @(x)meanTheta (x, np, Mbcc, Vfb, cs, ss, N);

options = optimset('algorithm','levenberg-marquardt');

x = lsqnonlin(f, x0, [], [], options);

Theta = meanTheta (x, np, Mbcc, Vfb, cs, ss, N);

end


% parent orientation of points
% e - euler angle
% np - number of points
% Mbcc - orientations of points
% Vfb - orientation relation
function ThetaM = meanTheta (x, np, Mbcc, Vfb, cs, ss, N)

Mfcc = orientation ('Euler', x(1),x(2),x(3), cs,ss);
Sym = symmetrise (orientation ('Euler', 0,0,0, cs,ss));

Theta = zeros(1,np);
for i = 1:np
    %D = ( (Vfb * Sym(N(1,i)) * Mfcc ) * inverse( Sym(N(2,i)) * Mbcc{i}{1} ) );
    D = ( (Vfb*Sym(N(1,i))*Mfcc) \ (Sym(N(2,i))*Mbcc{i}{1}) );
    %ThetaS = ThetaS + acos((trace(D)-1)/2);
    Theta(i) = angle(D);
end
%ThetaM = ThetaS/np;
ThetaM = mean(Theta);

end

