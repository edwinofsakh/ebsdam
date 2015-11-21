% Logistic Map Example
function x = example3(x0,r,N)

r = 4*r;
N = 1+round(100*N);

x = zeros(1,N);
x(1) = x0;

for n = 1:N-1
    x(n+1) = r*x(n)*(1-x(n));
end