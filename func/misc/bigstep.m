function [ebsd_big] = bigstep(ebsd)
X = get(ebsd, 'X');
Y = get(ebsd, 'Y');
% o = get(ebsd, 'orientation');
% uc = get(ebsd, 'unitCell');
% 
uX = unique(X);
uY = unique(Y);

ni = length(uY);
isb = zeros(1,ni);
for i=1:ni
    isb(i) = find(Y == uY(i),1,'first');
end
a1 = (isb(1)-isb(2));
a2 = (isb(2)-isb(3));

if ( a1 > a2)
    ss = 1;
elseif (a2 > a1)
    ss = 2;
else
    disp('Cube');
end

p = 1;

ind = [];

for i=1:2:ni-1
    k = isb(i);
    
    if (mod(i,4)) == 1
        j0 = 1;
    else
        j0 = 2;
    end
    
    nj = isb(i)-isb(i+1);
    
    for j=j0:2:nj
        ind(p) = k+j-1; %#ok<SAGROW>
        p = p+1;
    end
end


scatter(X,Y);
hold on;
scatter(X(ind),Y(ind),10,'r');
hold off;

export(ebsd(ind), 'test.txt');

ebsd_big = loadEBSD('test.txt');

figure();plot(ebsd_big);
end