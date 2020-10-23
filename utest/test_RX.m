clear; clc; close all;

define_constants;

warning('this test only works for the case in which the largest node is the root/substation');

mpc = loadcase('C:\Users\still\Documents\Github\Active-DG-Hosting-Capacity-Eval\data\case56_sce\case56_sce.m');
% mpc = loadcase('C:\Users\still\Documents\Github\Active-Hosting-Capacity-Eval\data\case3_dist\case3_dist.m');
% mpc = loadcase('case69');

opt.alpha = 0.5;
tic;
[result, Rmat, Xmat] = distflow_lossy(mpc, opt);
R1 = Rmat(:,1:(end-1));
X1 = Xmat(:,1:(end-1));
t1 = toc;

% second way to compute R and X
tic;
[R2,X2] = get_lDistFlow_RX(mpc);
t2 = toc;

disp(t1); disp(t2);
% R1,R2
% X1,X2

assert( norm(full(R1-R2)) <= 1e-6 ) ;
assert( norm(full(X1-X2)) <= 1e-6 ) ;

% norm(full(X-X2))