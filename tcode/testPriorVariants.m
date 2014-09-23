% Reconstruction parent for different number of variants
% Test reconstruction algorithm

%% Settings
% Variants parameters
n = 1; % number of statistic loop
vmin = 23; % min variant number
vmax = 24; % max variant number
dev = 2*degree; % Anglar deviation of product orientations
ORm = getOR('KS'); % Orientation relation matrix

% Reconstruction parameters
thr = 5*degree;
Nv  = 3;
w0  = 5*degree;
PRm = 1.4;


%% Prepare
ma = zeros(1,vmax);
m = 0;
ff = zeros(1,vmax);

% Symmetry
cs = symmetry('m-3m');
ss = symmetry('-1');


% Statistic loop
for j = 1:n
    % Generate random orientation
    o1 = orientation('Euler', rand*pi/2, rand*pi/2, rand*pi/2, cs, ss);
    
    % For one loop
    if (n == 1)
        disp(['Euler = ' num2str(fix(Euler(o1)/degree*100)/100)]);
        disp('Test...');
    end
    
    m1 = 0;
    for i = vmin:vmax 
        oa = getVariants(o1, inv(ORm), cs);
        p = randperm(24);
        ind = p(1:i);
        oi = oa(ind);

        oi1 = setOriDev(oi, dev);
        m1 = m1 + sum(angle(oi1,oi)/degree)/i;

        [Pmax, PR, oup, gind, op, vnum] = findUniqueParent(oi1, ones(1,length(oi1)), ORm, thr, Nv, w0, PRm);
        
        if isa(oup, 'orientation')
            if (n == 1)
                disp(['Euler = ' num2str(fix(Euler(oup)/degree*100)/100) ': i = ' int2str(i) ' - Pmax = ' num2str(Pmax) ' - PR = ' num2str(PR)]);
            end

            ma(i) = ma(i) + angle(o1, oup)/degree;
        else
            ff(i) = ff(i) + 1;
        end
    end
    m = m + m1/(vmax-vmin+1);
end
ma = ma/n;
m  = m/n;

disp(['m = ' num2str(m)]);

st = [(vmin:vmax)', ma(vmin:vmax)', ff(vmin:vmax)']
