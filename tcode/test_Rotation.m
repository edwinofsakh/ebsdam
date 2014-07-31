function test_Rotattion()
% Check all rotation features

%

phi1 =  12*degree;
Phi  =  34*degree;
phi2 = 106*degree;

h = 1;
k = 2;
l = 3;

u = -6;
v = 9;
w = -4;

% Rotation Matrix for Bunge notation ZXZ
% The term orientation describes the orientation of the principle axes of 
% this crystal (eic) relative to the principle axes of the sample (eis).
% The Euler angles are the three rotations about the principle axes of the 
% crystal that will bring the crystal axes into coincidence with the 
% principle axes of the sample. In the case of Bunge's form of the Euler 
% angles (j1, F, j2) this is a rotation (j1) about the e3c axis followed by
% a rotation (F) about the e1c axis followed by a third rotation (j2) about
% the e3c axis again.
%                                                          from OIM DC help
M11 = rotMtr(phi1,Phi,phi2);

% Old School Function
M12 = EulMtx([phi1,Phi,phi2]);

% Direct formula from Engler Randle Book
M21 = hklMtr([h k l],[u v w]);

% Orientation relation matrix (for V1 of KS OR)
M31 = makeOR([0,1,1]',[1,1,1]',[-1,-1,1]',[-1,0,1]','g2a');
M32 = getOR('KS'); % a2g
M33 = EulMtx([24.2038 10.5294 24.2038]*degree);

% MTEX rotation
r1 = rotation('Euler', phi1,Phi,phi2);

% MTEX orientation
CS = symmetry('m-3m');
SS = symmetry('-1');
o1 = orientation('Euler', phi1,Phi,phi2, CS,SS);
o2 = orientation('Miller',[h k l],[u v w],CS,SS);
o3 = orientation('matrix', M32, CS, CS); % 24.2038 10.5294 24.2038
o4 = orientation('Euler',[24.2038 10.5294 24.2038]*degree, CS,CS);

%% Checking

disp('Euler angle of orientation:');
disp([phi1,Phi,phi2]);
disp('Check old school. Compare two matrices obtained by direct formulas.');
if (norm(M11 - M12) < 1e-5)
    disp('Done')
else
    disp('Fail')
end
    
% MTEX orientation matrix transform crystal coordinates into specimen
% coordiantes. TThis is opposite to notation in some book. So inverse
% matrix will be equal to M1 and M2.
disp('Check rotation. Compare MTEX rotation and direct formula (for MTEX matrix(*)'' was used). ');
if (norm(M11 - matrix(r1)') < 1e-5)
    disp('Done')
else
    disp('Fail')
end

% This test is show that MTEX save first rotation
disp('Check orientation. Compare MTEX orientation and direct formula (for MTEX matrix(*)'' was used).');
if (norm(M11 - matrix(o1)') < 1e-5)
    disp('Done')
else
    disp('Fail')
end

disp('--------------------------------------------------------------------');
display(o2);
disp('In MTEX direct orientation always produce vector3d - specimen vector');
disp(o2*Miller(1,1,1))
disp(o2*vector3d(1,1,1))

display(o2');
disp('and inverse orientation always produce Miller - crystal vector');
disp(o2'*Miller(1,1,1))
disp(o2'*vector3d(1,1,1))

display(o3);
disp('and misorientation always produce Miller - crystal vector');
disp(o3*vector3d(1,1,1))
disp(o3*Miller(1,1,1))
disp(o3'*vector3d(1,1,1))
disp(o3'*Miller(1,1,1))


disp('--------------------------------------------------------------------');


disp('MTEX return inverse matrix, from crystal to specimen. It''s will be ');
disp('clearly after using plane/direction representation of rotation matrix.');

disp('Plane:');
disp([h,k,l]);

disp('Direction:');
disp([u,v,w]);

disp('Check direct orientation. Transform (hkl) and (uvw) to (001) and (100).');
o2*vector3d(h,k,l) %#ok<NOPRT>
o2*vector3d(u,v,w) %#ok<NOPRT>

disp('Check inverse orientation. Transform (001) and (100) to (hkl) and (uvw).');
o2'*vector3d(0,0,1) %#ok<NOPRT>
o2'*vector3d(1,0,0) %#ok<NOPRT>


disp('--------------------------------------------------------------------');


disp('Now check orientation relation. In EBSDAM OR is from alpha to gamma, ');
disp('so we use inverse rotation for vector (1 1 1)');

disp('V1 * [1 1 1]''')
disp(M31*[ 1  1  1]');

disp('V1 * [-1 0 1]''')
disp(M31*[-1  0  1]');

disp('ori_V1 * vector3d(1,1,1)'' (for MTEX inverse orientation)')
display(o3'*vector3d(1,1,1))

disp('ori_V1 * vector3d(-1,0,1)'' (for MTEX inverse orientation)')
display(o3'*vector3d(-1,0,1))

% o3all  = symmetrise(o3);
o3all0  = CS * o3 * CS;
o3all1  = rotation(o3 * CS);
o3all2  = rotation(CS * o3);

m30 = inverse(o3all0) * o3all0;
m31 = inverse(o3all1) * o3all1;
m32 = inverse(o3all2) * o3all2;

a30 = unique(m30);
a31 = unique(m31);
a32 = unique(m32);

m3new = orientation(o3all0,CS,SS);
m3uni = unique(m3new);

% figure;
% plot(a30*Miller(1,0,0), 'antipodal');
% 
% figure;
% plot(a31*Miller(1,0,0), 'antipodal');
% 
% figure;
% plot(a32*Miller(1,0,0), 'antipodal');

disp('--------------------------------------------------------------------');

OR = rotation(CS * o3);
reorder = JapanOrder();
ind = [1 reorder+1];

ind2 = [1 15 17 7 9 23, 10 8 21 14 4 19, 2 24 13 6 20 11, 18 16 5 22 12 3]; % new order after getVarInfo
OR = OR(ind2);

OR(2:2:24) = OR(2:2:24)*rotation('matrix', [1 0 0; 0 -1 0; 0 0 -1]);
p = {vector3d( 1, 1, 1), vector3d( 1,-1, 1), vector3d(-1, 1, 1), vector3d( 1, 1,-1)};

% Direct check of OR
[ ORmtr ] = getORVarInfo( );

for i = 1:24
    for j = 1:24
        if (norm(matrix(OR(i)) - ORmtr{j}) < 0.1)
            disp([i j]);
        end
%         if (mod(i,2) == 0)
%             if (norm(matrix(OR(i))*[1 0 0; 0 -1 0; 0 0 -1] - ORmtr{j}) < 0.1)
%                 disp([i j]);
%             end
%         end
    end
end


end



function M1 = rotMtr(phi1,Phi,phi2)

M1 = [...
    cos(phi1)*cos(phi2)-sin(phi1)*sin(phi2)*cos(Phi),  sin(phi1)*cos(phi2)+cos(phi1)*sin(phi2)*cos(Phi), sin(phi2)*sin(Phi);
    
   -cos(phi1)*sin(phi2)-sin(phi1)*cos(phi2)*cos(Phi), -sin(phi1)*sin(phi2)+cos(phi1)*cos(phi2)*cos(Phi), cos(phi2)*sin(Phi);
   
               sin(phi1)*sin(Phi),                                  -cos(phi1)*sin(Phi),                      cos(Phi);
    ];

end



function M1 = hklMtr(n,d)
% h - Miller indices for crystal plane perpendicular for Z spicemen
% direction, Normal Direction
% d - indices for crystal direction coincide with X spicemen direction,
% Rolling direction

h = n(1);
k = n(2);
l = n(3);
R2 = sqrt(sum(n.^2));

u = d(1);
v = d(2);
w = d(3);
R1 = sqrt(sum(d.^2));

M1 = [...
    u/R1 (k*w-l*v)/(R1*R2) h/R2;
    v/R1 (l*u-h*w)/(R1*R2) k/R2;
    w/R1 (h*v-k*u)/(R1*R2) l/R2;
    ];

end
