close all;
clear all;

p = path;
path(p,'func');

% Set austenite parent orientation in euler angles (p1,p,p2)
Eg = [pi/1.1, pi/4.8, pi/1.4];
Mg = eulmtr(Eg);

Blur = 3/180*pi;
% Set parent grain orientation
S = [10 10];
N = S(1)*S(2);
Gg = cell(1,N);
for i = 1:N
    az = randn(1,3)*Blur;
    R1 = rotationmat3D(az(1),[1 0 0]);
    R2 = rotationmat3D(az(2),[0 1 0]);
    R3 = rotationmat3D(az(3),[0 0 1]);
    Gg{i} = Mg*R3*R2*R1;
    %Gg{i} = Mg;
end

% Orientation relationship
OR_KS = [ 0.7416  -0.6667  -0.0749;
          0.6498   0.7416  -0.1667;
          0.1667   0.0749   0.9832; ];
      
OR_NW = [ 0.7071  -0.7071  0;
          0.6969   0.6969  -0.1691;
          0.1196   0.1196   0.9856; ];

OR_V1 = [ 0.7174  -0.6952  -0.0450;
          0.6837   0.7150  -0.1464;
          0.1340   0.0742   0.9882; ];

OR = OR_KS;
%OR = makeOR([0,1,1]',[1,1,1]',[-1,-1,1]',[-1,0,1]','g2a');

% Symmetry matrix
Sym = cubicsymm();

% Austenite-Ferrite transformation
 Ga = cell(1,N);
 for i = 1:N
     r = randi(24,1);
     if (i == 1)
         RRR = r;
     end
     % !!! for test
     r = 5;
     ORr = OR*Sym{r}';
     Ga{i} = ORr*Gg{i};
     %Test1 = inv(ORr)*Ga{i}*inv(ORr');
     %Test2 = Gg{i};
     %Test = (Test1-Test2)^2;
 end

% Plotting
% 1
E = cellfun(@mtreul,Gg, 'UniformOutput', false);
E = cell2mat(E');
C = eul2rgb(E);

X = repmat([1:S(1)],1,S(2));
Y = reshape(repmat([1:S(1)],S(2),1),1,N);

figure();
scatter(X',Y',30,C,'filled');

% 2
E = cellfun(@mtreul,Ga, 'UniformOutput', false);
E = cell2mat(E');
C = eul2rgb(E);

figure();
scatter(X',Y',30,C,'filled');

% Find Mgt

% calc Mg variants
Np = N; % number of points
Mgt = cell(Np,24);
for i = 1:Np % point
    for vi = 1:24 % variant
        ORr = OR*Sym{vi}';
        Mgt{i,vi} = ORr\Ga{i};
    end
end

V = zeros(1,N);
% set variant 1 for first point
V(1) = 1;

% compare Vg variants (first point vs other)
Dar = ones(1,24)*100;
for j = 2:Np % 2nd point
        for vj = 1:24 % 2nd variant
            D = Mgt{1,1}/Mgt{j,vj};
            Dar(vj) = real(acos((trace(D)-1)/2));
            %Dar(vj) = norm((Mgt{1,1}-Mgt{j,vj}));
        end
        [~,ind] = min(Dar);
        V(j) = ind;
end

for i = 2:N % point
    D = Mgt{1,1} - Mgt{i,V(i)};
end

Test = Mg/Mgt{1,1};
    
% for i = 1:Np-1 % point
%     if ( trace(Dar(:,:,i)) < 4*pi/180)
%         t = 1;
%     end
% end

x0 = [Eg mtreul(OR)];
f = @(x)myfun (x, N, Ga);
x = lsqnonlin(f,x0);
y = myfun (x, N, Ga);
return;

Cm = zeros(1,24);
T = RRR;
for vi = 1:24 % 1st variant
    if (vi == RRR)
        t = 1;
        Test = Mg-Mgt{1,vi};
    end
    Var = reshape(Dar(vi,:,:),1,24*(Np-1));
    ind = find(Var<3*pi/180);
    Cm(vi) = length(ind);
end

test = Mgt{1,1};
for i = 1:Np-1 % point
    ind = find(Dar(1,:,i)<3*pi/180);
    Mtest = Mgt{i,ind};
end

for i = 1:Np-1 % point
    if ( trace(Dar(:,:,i)) < 4*pi/180)
        t = 1;
    end
end
a = t;
% Vind = zeros(Np,3);
% DarBig = {};
% for i = 1:Np % 1st point
%     for j = i+1:Np % 2nd point
%         Dar = ones(24)*2*pi;
%         
%         for vi = 1:24 % 1st variant
%             for vj = 1:24 % 2nd variant
%                 D = Mgt{i,vi}*inv(Mgt{j,vj});
%                 Dar(vi,vj) = real(acos((trace(D)-1)/2));
%             end
%         end
%         
%         DarBig = {DarBig, Dar}
%         [C,Ivi] = min(Dar);
%         [C,Ivj] = min(C);
%         Vind(i,:) = [Ivi(Ivj),Ivj,C];
%         clear Dar;
%     end
% end
% 
% for i = 1:Np % point
%     ORr = Sym{Vind(1,1)}*inv(OR);
%     Mgtest = inv(ORr)*Ga{i}*inv(ORr');
%     D = (Mgtest-Mg)^2;
% end
    

path(p);

return;
x = lsqcurvefit(fun,x0,xdata,ydata)
