function I = get_adjacency_matrix(indices1, indices2)
% input two vector rows, output a n1-by-n2 matrix
% I(i,j) indicates indices2(j) is at indices1(i)


n1 = length(indices1); n2 = length(indices2);
I = sparse(n1,n2);
for i2 = 1:n2
    idx = find( indices1 == indices2(i2));
    assert( length(idx) == 1);
    I(idx, i2) = 1;
end


end