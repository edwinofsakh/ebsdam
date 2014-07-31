function f = myfun(x, N, Mbcc)

mphi1 = x(1);
mPhi  = x(2);
mphi2 = x(3);

vphi1 = x(4);
vPhi  = x(5);
vphi2 = x(6);

Mfcc = eulmtr ([mphi1, mPhi, mphi2]);
Vfb  = eulmtr ([vphi1, vPhi, vphi2]);

Theta = 0;
for i = 1:N
    D = ( (Vfb * Mfcc ) / ( Mbcc{i} ) );
    Theta = Theta + acos((trace(D)-1)/2);
end
Theta = Theta/N;

f = Theta;

%f = @(x,xdata)x(1)*xdata.^2+x(2)*sin(xdata);
%x = lsqcurvefit(f,x0,xdata,ydata);