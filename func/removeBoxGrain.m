function [good_grains, ind] = removeBoxGrain(grains, mSize)
% Remove grains connected to image edges.
%
% mSize - minimal size of grain for removeing, big grain will be saved

X = get(grains, 'X');
Y = get(grains, 'Y');

minX = min(X); minY = min(Y);
maxX = max(X); maxY = max(Y);

[ dx, dy ] = getStep( get(grains, 'ebsd') );
step = min([dx ,dy]);

a = (minX:step:maxX)';
data = [a, ones(length(a),1)*minY];
bad_grainsXvY0 = findByLocation( grains, data );

data = [a, ones(length(a),1)*maxY];
bad_grainsXvY1 = findByLocation( grains, data );

a = (minY:step:maxY)';
data = [ones(length(a),1)*minX, a];
bad_grainsX0Yv = findByLocation( grains, data );

data = [ones(length(a),1)*maxX, a];
bad_grainsX1Yv = findByLocation( grains, data );

ind = ones(1,numel(grains));

if (~isempty(bad_grainsXvY0))
    ind(find(bad_grainsXvY0(grainSize(bad_grainsXvY0) < mSize))) = 0; %#ok<FNDSB>
end
if (~isempty(bad_grainsXvY1))
    ind(find(bad_grainsXvY1(grainSize(bad_grainsXvY1) < mSize))) = 0; %#ok<FNDSB>
end
if (~isempty(bad_grainsX0Yv))
    ind(find(bad_grainsX0Yv(grainSize(bad_grainsX0Yv) < mSize))) = 0; %#ok<FNDSB>
end
if (~isempty(bad_grainsX1Yv))
    ind(find(bad_grainsX1Yv(grainSize(bad_grainsX1Yv) < mSize))) = 0; %#ok<FNDSB>
end

ind = logical(ind);
good_grains = grains(ind);