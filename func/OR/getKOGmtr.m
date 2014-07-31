function [ kog ] = getKOGmtr( ORmat, CS )

ORo = rotation('matrix', ORmat);
ORoa =  rotation(CS) * ORo;
kog = inverse(ORoa(1)) * ORoa(2:end);

end

