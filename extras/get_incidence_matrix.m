function I = get_incidence_matrix(node, source_node, sink_node)
% input argus are column vectors, 

num_node = size(node,1);
num_edge = size(source_node,1);
assert(size(sink_node,1) == num_edge);

assert(length(node) == length(unique(node))); % no repeatative elements
assert(isempty(setdiff(source_node, node))); % source_node \subseteq node
assert(isempty(setdiff(sink_node, node))); % sink_node \subseteq node

I = sparse(num_node, num_edge);
for ie = 1:num_edge
	assert( source_node(ie) ~= sink_node(ie)); % no self-loops
    source_ind = find( source_node(ie) == node);
    sink_ind = find( sink_node(ie) == node);
    assert( length(source_ind) == 1);
    assert( length(sink_ind) == 1);
    I(source_ind, ie) = 1;
    I(sink_ind, ie) = -1;
end


end