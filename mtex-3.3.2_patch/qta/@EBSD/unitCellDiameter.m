function d = unitCellDiameter(ebsd)

unitCell = ebsd.unitCell;

diffVg = bsxfun(@minus,...
  reshape(unitCell,[size(unitCell,1),1,size(unitCell,2)]),...
  reshape(unitCell,[1,size(unitCell)]));
diffVg = sum(diffVg.^2,3);
d  = sqrt(max(diffVg(:)));