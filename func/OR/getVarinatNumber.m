function getVarinatNumber(type, data, varargin)

CS = symmetry('m-3m');
SS = symmetry('1');

switch (type)
    case 'matrix'
        r = rotation('matrix', data);
        EE = euler(r);
        mtr = data;
    case 'euler'
        r = rotation('euler', data(1), data(2), data(3));
        EE = data;
        mtr = matrix(r);
end

mtrN = normalizeOR('ori', {EE});

oN = orientation('matrix', mtrN, CS,SS);

kog = getKOGmtr(oN, CS);
calcKOG3(o1);

[reorder] = JapanOrder();