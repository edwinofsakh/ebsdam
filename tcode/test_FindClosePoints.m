%% Find pattern

patterns = [];
for k = 1:1
    % get coordinates
    X = get(ebsd, 'X');
    Y = get(ebsd, 'Y');
    
    mX = min(X);
    mY = min(Y);
    MX = max(X);
    MY = max(Y);
    
    i = randi(length(X),1);
    a = 0.3;
    
    while ((X(i) - mX) <= 2*a || (Y(i) - mY) <= 2*a) || ((MX - X(i)) <= 2*a || (MY - Y(i)) <= 2*a)
        i = randi(length(X),1);
    end

    % get square
    iX1 = abs(X-X(i)) <= a*1.01;
    iY1 = abs(Y-Y(i)) <= a*1.01;
    ind1 = find(iX1&iY1);

    % get circle
    X1 = X(ind1);
    Y1 = Y(ind1);

    ind2 = ((X1-X(i)).^2+(Y1-Y(i)).^2) <= a*1.01;
    ind3 = ind1(ind2);

    X2 = X(ind3);
    Y2 = Y(ind3);

%     scatter(X2,Y2);
%     axis equal;
    %ind1 - i
    pt = (ind3 - i);
    length(pt)
    patterns(:,k) = pt;
end

%% Borders
X1 = X-mX > 1.5*a;
X2 = MX-X > 1.5*a;
Y1 = Y-mY > 1.5*a;
Y2 = MY-Y > 1.5*a;

iind = find(X1&X2&Y1&Y2);

iind2 = repmat(patterns',length(iind),1) + repmat(iind,1,length(patterns));

scatter(X,Y,5,'sb');
hold on;
scatter(X(iind2(:)),Y(iind2(:)),5,'sr');

%%
o = get(ebsd,'orientation');
c = fix(length(patterns)/2)+1;

for i = 1:length(iind)
    ind = iind2(i,:);
    j = ind(c);
    o0 = o(j);
    o1 = o(ind);
    mo1 = o1\o0;
    
    dX = X(ind)-X(j);
    dY = Y(ind)-Y(j);
end

%%
A = repmat(patterns',length(X),1);
B = repmat((1:length(X))',1,length(patterns));
iind = A + B;

iind2 = sum((iind > 1) & (iind < length(X)),2) == length(patterns);

iind3 = iind(iind2,:);

scatter(X,Y,5,'sb');
hold on;
scatter(X(iind2),Y(iind2),5,'sr');

%% Full test
% too big, memory problem
% MX = repmat(X',length(X),1);