function [ebsd_big] = bigstep(sid, ebsd, suffix)
% Increse step of EBSD data (remove part of the data).
%   Transform sift point, remove the closest neighbours. 

% + + + + + +       + + + + + +
%  + + + + +         0 + 0 + 0
% + + + + + +   \   + + + + + +
%  + + + + +    /    + 0 + 0 +
% + + + + + +       + + + + + +
%  + + + + +         0 + 0 + 0

% + + + + + +       0 + 0 + 0 +
%  + + + + +         + + + + +
% + + + + + +   \   + 0 + 0 + 0
%  + + + + +    /    + + + + +
% + + + + + +       0 + 0 + 0 +

ebsd = checkEBSD(sid, ebsd, 0);

% Check
% ebsd = cutEBSD(ebsd,0,0,10,10);

% Check grid type
if numel(get(ebsd,'unitCell')) == 12
    % Hex grid
    
    % Sift EBSD data
    ind = siftEBSD(ebsd);
    
    % Export data
    cacheDir = getpref('ebsdam','cache_dir');
    fname = fullfile(cacheDir, [sid suffix '.txt']);

    export(ebsd(ind), fname);

    CS = get(ebsd,'CS');
    SS = get(ebsd,'SS');
    fn = fieldnames(get(ebsd, 'options'));
    fn = {'Euler 1','Euler 2','Euler 3','Phase',fn{:}};
    ebsd_big = loadEBSD_generic(fname,'CS',CS,'SS',SS, 'ColumnNames', ...
    fn, 'Bunge');

    % figure();plot(ebsd_big);
    
elseif numel(get(ebsd,'unitCell')) == 8
    % Cube grid
    
    ebsd_big = ebsd;
end
end

function ind = siftEBSD(ebsd)

% Get coordiantes
X = get(ebsd, 'X');
Y = get(ebsd, 'Y');

if (X(1) == X(2))
    C1 = Y;
%     C2 = X;
elseif (Y(1) == Y(2))
    C1 = X;
%     C2 = Y;
end

[isb, l1] = strIndex(C1);

ni = length(isb);

s = [1 2; 2 1];
    

% Get subindices for big step map
p = 1;
ind = [];

for i=1:2:ni
    k = isb(i);
    
    if (mod(i,4)) == 1
        j0 = s(1,1);
    else
        j0 = s(1,2);
    end
    
    nj = l1;
    
    ind = [ind, k+(j0:2:nj)-1]; %#ok<AGROW>
    
%     for j=j0:2:nj
%         ind(p) = k+j-1; %#ok<AGROW>
% %         % Check
% %         scatter(X(ind(p)),Y(ind(p)),20,'b','fill');
% %         hold on;
%         p = p+1;
%     end
end

ind = ind(ind < numel(ebsd));

end

function [ind, l1, l2] = strIndex(X0)
% Determine long and short strings

% Find line length
uX0 = unique(X0);
i1 = find(X0 == uX0(1));
i2 = find(X0 == uX0(2));
l1 = i2(1) - i1(1);
l2 = i1(2) - i2(1);
ind = sort([i1;i2]);
end