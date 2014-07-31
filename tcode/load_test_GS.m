function load_test_GS

S = load('test_gs1.mat', 'cags0', 'cags1', 'cags2', 'cags3');

% cags0 = S.cags0;
% ags0 = calcMean(cags0, 1000, 0);

% cags1 = S.cags1;
% ags1 = calcMean(cags1, 1, 0);

% One Sample
% cags2 = S.cags2;
% ags2 = calcMean(cags2, 1, [2 3 4 5]);

cags3 = S.cags3;
ags3 = calcMean(cags3, 1, 0);

end


function ags = calcMean(cags, j, ind)

if (ind ~= 0)
    cags = cags(ind);
end

n = length(cags);

ags = zeros(size(cags{1}));

for i = 1:n
    if (mod(i,j) == 0)
        figure();
        a = cags{i};
        a = convert_A(a);
        plot(a(:,1:4)', 'LineWidth',2);
    end
    
    ags = ags + cags{i};
end

ags = ags/n;

ags = convert_A(ags);

figure;
plot(ags(:,1:4)', 'LineWidth',2);
legend('intersect', 'from area', 'from areafraction', 'from eq radius', 'from misori', 'Location','NorthWest');


dev = zeros(size(cags{1}));
for i = 1:n
    a = cags{i};
    a = convert_A(a);
    dev = dev + (a-ags).^2;
end

dev = sqrt(dev);

figure;
plot(dev(:,1:4)', 'LineWidth',2);
legend('intersect', 'from area', 'from areafraction', 'from eq radius', 'from misori', 'Location','NorthWest');


end

function b = convert_A(a)

b(1,:) = 1.27*a(1,:);       % intersect
b(2,:) = 2*sqrt(a(2,:)/pi); % mean area to diameter
b(3,:) = a(3,:);            % area fraction
b(4,:) = 2*a(4,:);          % equivalent diameter
b(5,:) = a(5,:);            % length

end
