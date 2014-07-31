function [a, d] = spatialProfileDiff(ebsd,lineX,s)

[p,d] = spatialProfile(ebsd,lineX);

if (s == 0)
    n = length(p);
else
    n = fix(max(d)/s)+1;
end

a = zeros(1,n-1);
ind = zeros(1,n-1);

if (s == 0)
    for i = 1:(n-1)
        ind(i) = i; 
        a(i) = angle(p(i),p(i+1))/degree;
    end
else
    ind(1) = 1;
    for i = 1:(n-1)
        [neverUsed,j] = min(abs(d - s*i));
        ind(i+1) = j;
        a(i) = angle(p(ind(i)),p(ind(i+1)))/degree;
    end
    ind = ind(2:end);
end

d = d(ind);

optiondraw(plot(d,a));
ylabel(['\Delta in ' mtexdegchar])
xlabel(['distance (step ' int2str(s) ')']);

end
