% Reconstruct parent austenite orientaion by mean grain orientation

epsilon = 5*degree;

o = get(grains_local, 'MeanOrientation');
n = length(o); % number of grains
m = o\o;
ind = tril(ones(n),-1);
um = m(logical(ind)); 

[~,~,dis,udis] = calcKOG_new('V1');
dis = dis(2:end);

m = length(dis); % number of variants
test = cell(1,m);
pairs = cell(1,m);

% find speciall boundary
h = waitbar(0,'Please wait...');
for i = 1:m
    ind_l = find(um,dis(i),epsilon);
    test{i} = find(ind_l);
    
    [I,J] = ind2sub([n,n],test{i});
    pairs{i} = [I,J];
    
    waitbar(i/m);
end
close(h)

[nn, near] = neighbors(grains_local);

pairs_all = cell2mat(pairs');


nnt = zeros(1,n);
neigh = cell(1,n);

for i = 1:n
    m = nn(i);
    
    ind1 = find(near(:,1) == i);
    ind2 = find(near(:,2) == i);
    indn = vertcat(near(ind1,2), near(ind2,1)); 
    
    neigh{i} = indn;
    nnt(i) = length(indn);
%     if length(indn) ~= m
%         disp([num2str(i) ' - ' num2str(m) ' - ' num2str(length(indn))])
%         error('Er');
%     end

end

