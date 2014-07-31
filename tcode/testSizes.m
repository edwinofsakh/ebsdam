sids = {'p01','p02','p03'};

for i = 1:3
    sid = sids{i};
    viewSizes(sid,0,1,3,4);
    viewSizes(sid,0,1,3,8);
    viewSizes(sid,0,1,3,20);

    viewSizes(sid,0,1,5,4);
    viewSizes(sid,0,1,5,8);
    viewSizes(sid,0,1,5,20);

    viewSizes(sid,0,1,15,4);
    viewSizes(sid,0,1,15,8);
    viewSizes(sid,0,1,15,20);
    
    viewGrains(sid,0,1,5,4);
    viewGrains(sid,0,1,5,8);
    viewGrains(sid,0,1,5,20);
end

    viewSizes('p01',0,1,5,0);
    viewSizes('p02',0,1,5,0);
    viewSizes('p03',0,1,5,0);
    
    viewSizes('p01',0,1,15,0);
    viewSizes('p02',0,1,15,0);
    viewSizes('p03',0,1,15,0);