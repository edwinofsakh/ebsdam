function [ja, aa] = getVarAngles(optOR)

[a,aa] = calcKOG3(optOR);

reorder = JapanOrder();
ja = a(reorder);

disp('Unique angle/axis pair');
disp(aa);

disp('Variant misorientation from V1 to Vn');
disp([(2:24)' ja]);
end