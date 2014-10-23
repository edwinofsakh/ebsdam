% Unit Test

%% Result saving
% !!! At first result file must be deleted
disp('Test - Result saving ...')

a = 1; b = 2; c = 3;
saveResultData('UT_ResultSaving', a, b, c);
[S, a1, b1, c1] = loadResultData('UT_ResultSaving', 'a', 'b', 'c');
if ((a == a1) && (b == b1) && (c == c1))
    disp('done');
else
    disp('failed');
end

%% Orientation relation
[v, ind] = getVariants(o, ORmat, CS);
[ OR, ORr, V, CP, B, in_cp, out_cp, in_b, out_b ] = getORVarInfo( );
getVarinatNumber(type, data, varargin);
[ja, aa] = getVarAngles(optOR);

[reorder, group, ticks] = JapanOrder();
[ A, o ] = getOR( ORdata );
[ mis ] = getORmis( ORname );
[ output_args ] = misType( OR_name );

HistNearKOG(grains, epsilon, optOR, allbnd, saveres, OutDir, prefixk, desc, comment);

%%
[ ebsd_cut, lineXY ] = selectEBSD( 's04', 0, 'Fe', 0, 0, 'a' );

%%
saveResult('off');
[ op, lineXY ] = parent4polygon( 's04', 2, 3, getOR('M1'), lineXY, 0, 3 );

