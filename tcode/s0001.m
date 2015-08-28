ebsd = if01_load();
viewSizes('tif01', 0, ebsd, 1, 2, 5, 'saveres', 'removeBad', 0.2);
viewSizes('ttif01', 0, ebsd, 1, 2, 5, 'saveres', 'removeBad', 0.2, 'extBoundary');
viewSizes('tttif01', 0, ebsd, 1, 2, 5, 'saveres', 'removeBad', 0.2, 'extBoundary', 'smoothGrain');
