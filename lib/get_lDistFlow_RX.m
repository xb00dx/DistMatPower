function [R,X,Z,B] = get_lDistFlow_RX(mpc)
define_constants;
NONREF_BUS = mpc.bus(:,BUS_TYPE) ~= REF;

nbranch_all = size(mpc.branch,1);
nbranch_on = size(mpc.branch(:,BR_STATUS)==1,1);
nnode_all = size(mpc.bus,1);

if nbranch_all ~= nbranch_on
    error('need to remove off lines');
else
    assert(nbranch_on == (nnode_all-1));
end

if nbranch_all ~= (nnode_all-1)
    warning('the complete network (all branches on) is not a tree');
end

% nnode_ref = sum(mpc.bus(:,BUS_TYPE) == REF);
% if nnode_ref ~= 1
% 
% end

A0 = get_incidence_matrix(mpc.bus(:,BUS_I),mpc.branch(:,F_BUS),mpc.branch(:,T_BUS));
A = A0(NONREF_BUS,:);

B = sparse(inv(A)); % very inefficient, and possiblely inaccurate for large A

R = 2*B'*sparse(1:nbranch_on,1:nbranch_on,mpc.branch(:,BR_R))*B;
X = 2*B'*sparse(1:nbranch_on,1:nbranch_on,mpc.branch(:,BR_X))*B;

Z = (0.5*R).*2 + (0.5*X).*2;

end