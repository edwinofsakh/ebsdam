function [ frg_info ] = findPriorGrains( grains, ORmat, thr, Nv, PRm, w0, w11, w21, w2, varargin )

% 'refineOri'

% Try to find fragments of prior grain (check all grains and its neighbours)
[ frg_info0 ] = findFragments( grains, ORmat, thr, Nv, PRm, w0, varargin{:});
n0 = length(frg_info0{1});

% Two pass fragments union.
[ frg_info11 ] = uniteFragments( grains, frg_info0, w11, varargin{:});
n11 = length(frg_info11{1});

% Processing grains belong to more then one fragments
[ frg_info2 ] = removeMultiGrains( grains, frg_info11, ORmat, symmetry('m-3m'), varargin{:});
n2 = length(frg_info2{1});

[ frg_info21 ] = uniteFragments( grains, frg_info2, w21, varargin{:});
n21 = length(frg_info21{1});

% Try to add grains remained without fragments to the closest fragments
[ frg_info3, nn ] = addRemain( grains, frg_info21, ORmat, w2, varargin{:});
n3 = length(frg_info3{1});


%% Postprocessing
frg_info4 = frg_info3;

% Remove empty fragments
ll = cellfun(@length, frg_info3{1});
ind = (ll > 0);

frg = frg_info4{1};
frg_po = frg_info4{2};

frg = frg(ind);
frg_po = frg_po(ind);

frg_info4{1} = frg;
frg_info4{2} = frg_po;

% Refine orientation and find variants
if check_option(varargin, 'refineOri')
    o = get(grains, 'mean');

    frg_v = cell(1,length(frg));
    
    for i = 1:length(frg)
        oi = o(frg{i});
        [~, ~, oup, ~] = findUniqueParent(oi, ones(1,length(oi)), ORmat, thr, Nv, w0, PRm, varargin{:});
        if isa(oup, 'orientation')
            frg_po(i) = oup;
            frg_v{i}  = checkVariants(oup, ORmat, symmetry('m-3m'), oi);
        end
    end
    frg_info4{2} = frg_po;
end

frg_info =  frg_info4;
end