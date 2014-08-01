function [ frg_info ] = findPriorGrains( grains, ORmat, thr, Nv, PRm, w0, w11, w12, w2, varargin )

% Try to find fragments of prior grain (check all grains and its neighbours)
[ frg_info0 ] = findFragments( grains, ORmat, thr, Nv, PRm, w0, varargin{:});
n0 = length(frg_info0{1});

% Two pass fragments union.
[ frg_info11 ] = uniteFragments( grains, frg_info0, w11, varargin{:});
n11 = length(frg_info11{1});
[ frg_info12 ] = uniteFragments( grains, frg_info11, w12, varargin{:});
n12 = length(frg_info12{1});

% Processing grains belong to more then one fragments
[ frg_info2 ] = removeMultiGrains( grains, frg_info12, ORmat, symmetry('m-3m'), varargin{:});
n2 = length(frg_info2{1});

% Try to add grains remained without fragments to the closest fragments
[ frg_info3 ] = addRemain( grains, frg_info2, ORmat, w2, varargin{:});
n3 = length(frg_info3{1});

% Postprocessing
frg_info4 = frg_info3;

ll = cellfun(@length, frg_info3{1});
ind = (ll > 0);

frg = frg_info4{1};
frg_po = frg_info4{2};
grn_frg = frg_info4{3};
grn_po = frg_info4{4};

frg = frg(ind);
frg_po = frg_po(ind);

o = get(grains, 'mean');

for i = 1:length(frg)
	oi = o(frg{i});
    [~, ~, oup, ~] = findUniqueParent(oi, ones(1,length(oi)), ORmat, thr, Nv, w0, PRm, varargin{:});
    if isa(oup, 'orientation')
        frg_po(i) = oup;
    end
end

frg_info4{4} = frg_po;

frg_info =  frg_info4;
end