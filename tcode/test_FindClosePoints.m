%% Load sample
ebsd = af03s_load();
ebsd = cutEBSD(ebsd, 50,30, 40,40);

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
    a = 0.5;
    
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

    %ind1 - i
    pt = (ind3 - i);
    length(pt)
    patterns(:,k) = pt;
end

%% Plot pattern
% scatter(X2,Y2,'fill'); box on;
% axis equal;

%% Borders
X1 = X-mX > 1.5*a;
X2 = MX-X > 1.5*a;
Y1 = Y-mY > 1.5*a;
Y2 = MY-Y > 1.5*a;

% Indices of orientation in region
in_ind = find(X1&X2&Y1&Y2);

% Indices of points and neighbours
iind2 = repmat(patterns',length(in_ind),1) + repmat(in_ind,1,length(patterns));

% Plot
% scatter(X,Y,5,'sb');
% hold on;
% scatter(X(iind2(:)),Y(iind2(:)),5,'sr');

%% Process all orientation
% o = get(ebsd,'orientation');
% c = fix(length(patterns)/2)+1;
% 
% for i = 1:length(in_ind)
%     ind = iind2(i,:);
%     j = ind(c);
%     o0 = o(j);
%     o1 = o(ind);
%     mo1 = o1\o0;
%     
%     dX = X(ind)-X(j);
%     dY = Y(ind)-Y(j);
% end

%% Make R and U
% Get orientations
o = get(ebsd,'orientation');
om = o(iind2);

% Center point offset
c = fix(length(patterns)/2)+1;

% Init matrix
Rs = zeros(3, length(patterns)*2, length(in_ind));
Us = zeros(3, length(patterns)*2, length(in_ind));

for i = 1:length(in_ind)
    ind = iind2(i,:);
    j = ind(c);
    
    o0 = o(j);
    o1 = o(ind);
    
    mo1 = o1\o0;
    
    U = (angle(mo1)/degree).*vector3d(normalize(axis(mo1)));
    
    Rs(:,:,i) = [X(ind)' X(ind)'; Y(ind)' Y(ind)'; [-1*ones(1,length(ind)), ones(1,length(ind))];];
    Us(:,:,i) = [getx(U)' getx(U)'; gety(U)' gety(U)'; getz(U)' getz(U)'];
end

%% Process all orientation

c = mat2cell(o(iind2), ones(1,length(in_ind)), length(pt));
om = repmat(Eori,length(in_ind),1);

s = fix(length(in_ind)/20);

length(in_ind)
for i = 1:length(in_ind)
    [om(i), d(i)] = mean(c{i});
    if (mod(i,s) == 0)
        i
    end
end

%%
ebsd2 = ebsd;
o2 = o;
o2(in_ind) = om;
ebsd2 = set(ebsd2, 'rotations', o2);

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