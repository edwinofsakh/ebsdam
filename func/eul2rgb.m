function c = eul2rgb(e)

phi1 = e(:,1);
Phi  = e(:,2);
phi2 = e(:,3);

phi1 = mod(-phi1,pi/2) *2 ./ pi;
Phi = mod(-Phi,pi/2); Phi = Phi./max(Phi(:));
phi2 = mod(-phi2,pi/2)*2 ./ pi;

c = [phi1(:),Phi(:),phi2(:)];