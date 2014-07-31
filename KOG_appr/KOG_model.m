%modeling inter-variant spectrum versus kinetics parameters
% 1- AB 140, 2- AB 47, 3- D40S, 4- X100, 5-X90

Nsample = [3;3;6;12;9];
Nnodef = [2;2;3;4;4];
D_au = [140;47;99;49;81];
Def = zeros(5,12);
Def(1,3)=0.36; Def(2,3)=0.36;
Def(3,4)=0.4; Def(3,5)=0.4; Def(3,6)=0.4;
Def(4,5)=0.2; Def(4,6)=0.2; Def(4,7)=0.2; Def(4,8)=0.2;
Def(4,9)=0.6; Def(4,10)=0.6; Def(4,11)=0.6; Def(4,12)=0.6;
Def(5,5)=0.2; Def(5,6)=0.2; Def(5,7)=0.2;
Def(5,8)=0.6; Def(5,9)=0.6;
Rate(1,1)=5; Rate(1,2)=50; Rate(1,3)=50; Rate(2,1)=5; Rate(2,2)=50; Rate(2,3)=50;
Rate(3,1)=10; Rate(3,2)=30; Rate(3,3)=100; Rate(3,4)=10; Rate(3,5)=30; Rate(3,6)=100;
Rate(4,1)=1; Rate(4,2)=5; Rate(4,3)=10; Rate(4,4)=20;
Rate(4,5)=1; Rate(4,6)=5; Rate(4,7)=10; Rate(4,8)=20;
Rate(4,9)=1; Rate(4,10)=5; Rate(4,11)=10; Rate(4,12)=20;
Rate(5,1)=1; Rate(5,2)=5; Rate(5,3)=10; Rate(5,4)=20;
Rate(5,5)=1; Rate(5,6)=5; Rate(5,7)=10; Rate(5,8)=20;
Rate(5,9)=1; Rate(5,10)=5; Rate(5,11)=10; Rate(5,12)=20;

%critical temperature points
Bs = [605; 605; 660; 595; 640];
Ms = [430; 430; 460; 460; 470];
T005 = zeros(5,12);
T005(1,1:3)=[600 450,434];
T005(2,1:3)=[567 429 495];
T005(3,1:6)=[680 610 530 710 670 595];
T005(4,1:12)=[585 580 555 525 610 595 585 565 610 600 590 590];
T005(5,1:9)=[620 600 585 560 635 615 590 630 615];
T05 = zeros(5,12);
T05(1,1:3)=[506 427 416];
T05(2,1:3)=[518 426 464];
T05(3,1:6)=[580 520 480 600 560 490];
T05(4,1:12)=[555 520 490 470 565 545 530 505 575 555 545 535];
T05(5,1:9)=[585 550 530 500 600 575 540 590 580];

%experimental spectrums
KOG_data;
for i=1:4
    for j=1:Nnodef(i)
        fda=KOGda(i,j,:);
        fa=fda(:);
        fform=Knorm(fa);
        KOG(i,j,:)=fform;
    end
end

%model
% 1- V2, 2- V3-V5, 3- V4, 4- V6, 5- V7, 6- V8, 7- V9-V19, 8- V10-V14, 
% 9- V11-V13, 10- V12-v20, 11- V15-V23, 12-V16, 13- V17, 14- V18-V22,
% 15- V21, 16- V24
clf
x = 1:16;
ip = 0;
for i=1:4
    for j=1:Nnodef(i)
        Tpar = 0.5*(T005(i,j)+T05(i,j));
        Tshift = (Bs(i)-Tpar)/(Bs(i)-Ms(i));
        KOGf = mod_KOG(Tshift);
        KOGf = KOGf*100/sum(KOGf);
        KOGmod(i,j,:) = KOGf;
        fda=KOG(i,j,:); 
        fa=fda(:);
        ip = ip+1;
        figure(ip);
        plot(x,KOGf,'-k+',x,fa,'-ko');
        c(ip)=sum(abs(KOGf-fa').^2)^(1/2)/16;
    end
end
c
sumc=sum(c.^2)^(1/2)/ip
