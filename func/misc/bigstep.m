function [ebsd_big] = bigstep(sid, ebsd, suffix)
% Increse step of EBSD data (remove part of the data).
%   Transform sift point, remove the closest neighbours. 
%
% + + + + + +       + + + + + +
%  + + + + +         0 + 0 + 0
% + + + + + +   \   + + + + + +
%  + + + + +    /    + 0 + 0 +
% + + + + + +       + + + + + +
%  + + + + +         0 + 0 + 0
%

ebsd = checkEBSD(sid, ebsd, 0);

% Check
% ebsd = cutEBSD(ebsd,0,0,10,10);

% Sift EBSD data
ind = siftEBSD(ebsd);

% Export data
cacheDir = getpref('ebsdam','cache_dir');
fname = fullfile(cacheDir, [sid suffix '.txt']);

export(ebsd(ind), fname);

cs = get(ebsd,'CS');
ss = get(ebsd,'SS');
ebsd_big = loadEBSD(fname,cs,ss);

% figure();plot(ebsd_big);
end

function ind = siftEBSD(ebsd)

% Get coordiantes
X = get(ebsd, 'X');
Y = get(ebsd, 'Y');

% Find unique Y coordinates
uX = unique(X);
uY = unique(Y);

[isbx, nix, six] = strIndex(X, uX); %#ok<NASGU>
[isby, niy, siy, l1, ~] = strIndex(Y, uY);

six = 0;
if (six ~= 0)
    isb = isbx;
    ni = nix;
    si = six;
elseif (siy ~= 0)
    isb = isby;
    ni = niy;
    si = siy;
else
    disp('Cube');
    ind = 0;
    return;
end

s = [1 2; 2 1];
    

% % Check
% scatter(X,Y,20,'b');
% hold on;
% scatter(X(isb(1)),Y(isb(1)),20,'r','fill');
% hold on;
% scatter(X(isb(1)+1),Y(isb(1)+1),20,'g','fill');
% hold off;


% % Check
% scatter(X,Y,20,'b');
% hold on;

% Get subindices for big step map
p = 1;
ind = [];

for i=1:2:ni
    k = isb(i);
    
    if (mod(i,4)) == 1
        j0 = s(si,1);
    else
        j0 = s(si,2);
    end
    
    nj = l1;
    
    for j=j0:2:nj
        ind(p) = k+j-1; %#ok<AGROW>
%         % Check
%         scatter(X(ind(p)),Y(ind(p)),20,'b','fill');
%         hold on;
        p = p+1;
    end
end

end

function [isb, ni, ss, l1, l2] = strIndex(Y, uY)

% Find indices of strings begins 
ni = length(uY);
isb = zeros(1,ni);
for i=1:ni
    isb(i) = find(Y == uY(i),1,'first');
end

% Is first string short or long
if (isb(1) > isb(2)) % backorder
    l2 = (isb(1)-isb(2));
    l1 = (isb(2)-isb(3));
else
    l1 = (isb(2)-isb(1));
    l2 = (isb(3)-isb(2));
end
% 
if (l1 > l2)
    ss = 1;
elseif (l2 > l1)
    ss = 2;
else
    ss = 0;
end

end