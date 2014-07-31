%% Settings
% Anglar deviation of children orientations
dev = 2*degree;

ORm = getOR('KS');

thr = 5*degree;
Nv  = 3;
w0  = 5*degree;
PRm = 1.4;

n = 200;
vmin = 3;
vmax = 12;

%% Prepare
ma = zeros(1,vmax);
m = 0;
ff = zeros(1,vmax);

% Symmetry
cs = symmetry('m-3m');
ss = symmetry('-1');


% Statistic loop
for j = 1:n
    o1 = orientation('Euler', rand*pi/2, rand*pi/2, rand*pi/2, cs, ss);
    
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

        [Pmax, PR, oup, gind, op, vnum] = findUniqueParent(oi1, ORm, thr, Nv, w0, PRm, 'onlyFirst');
        
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
