close all;
test0005('recalc', 'epsilon', 20*degree, 'searchRange', 5*degree, 'searchSteps', 10, 'fname', 'res020.mat', 'start', 'KS');
[M, E1,E2,E3, i,j,k] = test0005('fname', 'res020.mat');
[E1(i,j,k), E2(i,j,k), E3(i,j,k)]/degree
M(i,j,k)
test0005('recalc', 'epsilon', 20*degree, 'searchRange', 5*degree, 'searchSteps', 10, 'fname', 'res021.mat', 'continue', [E1(i,j,k), E2(i,j,k), E3(i,j,k)]);
[M, E1,E2,E3, i,j,k] = test0005('fname', 'res021.mat');
[E1(i,j,k), E2(i,j,k), E3(i,j,k)]/degree
M(i,j,k)
test0005('recalc', 'epsilon', 20*degree, 'searchRange', 5*degree, 'searchSteps', 10, 'fname', 'res022.mat', 'continue', [E1(i,j,k), E2(i,j,k), E3(i,j,k)]);
[M, E1,E2,E3, i,j,k] = test0005('fname', 'res022.mat');
[E1(i,j,k), E2(i,j,k), E3(i,j,k)]/degree
M(i,j,k)
test0005('recalc', 'epsilon', 20*degree, 'searchRange', 5*degree, 'searchSteps', 10, 'fname', 'res023.mat', 'continue', [E1(i,j,k), E2(i,j,k), E3(i,j,k)]);
[M, E1,E2,E3, i,j,k] = test0005('fname', 'res023.mat');
[E1(i,j,k), E2(i,j,k), E3(i,j,k)]/degree
M(i,j,k)
test0005('recalc', 'epsilon', 20*degree, 'searchRange', 5*degree, 'searchSteps', 10, 'fname', 'res024.mat', 'continue', [E1(i,j,k), E2(i,j,k), E3(i,j,k)]);
[M, E1,E2,E3, i,j,k] = test0005('fname', 'res024.mat');
[E1(i,j,k), E2(i,j,k), E3(i,j,k)]/degree
M(i,j,k)
test0005('recalc', 'epsilon', 20*degree, 'searchRange', 5*degree, 'searchSteps', 10, 'fname', 'res025.mat', 'continue', [E1(i,j,k), E2(i,j,k), E3(i,j,k)]);
[M, E1,E2,E3, i,j,k] = test0005('fname', 'res025.mat');
[E1(i,j,k), E2(i,j,k), E3(i,j,k)]/degree
M(i,j,k)
test0005('recalc', 'epsilon', 20*degree, 'searchRange', 1*degree, 'searchSteps', 10, 'fname', 'res026.mat', 'continue', [E1(i,j,k), E2(i,j,k), E3(i,j,k)]);
[M, E1,E2,E3, i,j,k] = test0005('fname', 'res026.mat');
[E1(i,j,k), E2(i,j,k), E3(i,j,k)]/degree
M(i,j,k)