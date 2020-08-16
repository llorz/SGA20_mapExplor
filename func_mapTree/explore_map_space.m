function [fMapTree] = explore_map_space(S1, S2, para)

thres_lapcomm = para.thres_lapcomm;
thres_ortho = para.thres_ortho;
thres_fmap_dist = para.thres_fmap_dist;
stop_dim = para.stop_dim;


func_lapComm = @(C12, Ev1, Ev2) norm(C12*diag(Ev1(1:size(C12, 2))) - diag(Ev2(1:size(C12, 1)))*C12, 'fro')/(size(C12,1)*size(C12,2));
func_ortho = @(C) norm(C'*C - eye(size(C,2)),'fro')/sqrt(size(C,1));
func_find_deepest_nodes = @(tree)find(arrayfun(@(l_id)tree.getNodeDepth(l_id), tree.findleaves) == tree.depth);

const = abs(sum(S2.evecs(:,1))/sum(S1.evecs(:,1)))*S1.nv/S2.nv;
C12_ini = sum(S2.evecs(:,1))/sum(S1.evecs(:,1))*S1.nv/S2.nv;
%% Initialize the tree
fMapTree = tree(S1.name);
fMapTree = fMapTree.addnode(1, C12_ini);
fprintf('expanding the tree...')
%% BFS explore the map tree
while size(C12_ini,1) < stop_dim
    fprintf('%d...',size(C12_ini,1));
    curr_depth = fMapTree.depth;
    block_id = fMapTree.depth + 1;
    k1 = length(S1.repeatedID{block_id});
    k2 = length(S2.repeatedID{block_id});
    [all_C12_block] = get_all_possible_blocks(k1, k2);
    num = length(all_C12_block);
    leaves_id = fMapTree.findleaves;
    leaves_id = leaves_id(func_find_deepest_nodes(fMapTree));
    for leaf_id = reshape(leaves_id,1,[])
        C12_ini = fMapTree.get(leaf_id);
        for b_id = 1:num
            C12_block = all_C12_block{b_id};
            C12 = blkdiag(C12_ini, C12_block);
            fMapTree = fMapTree.addnode(leaf_id, C12);
        end
    end
    %% pre-pruning: remove the fmap with large orthogonality error
    leaves_id = fMapTree.findleaves;
    leaves_id = leaves_id(func_find_deepest_nodes(fMapTree));
    all_C12 = arrayfun(@(l_id) fMapTree.get(l_id), leaves_id,'UniformOutput',0);
    err_lapComm = cellfun(@(C12) func_ortho(C12), all_C12);
    rm_id = leaves_id(err_lapComm > thres_ortho*const);
    for i = sort(rm_id,'descend')
        fMapTree = fMapTree.removenode(i);
    end
    %% refine each leaf
    leaves_id = fMapTree.findleaves;
    leaves_id = leaves_id(func_find_deepest_nodes(fMapTree));
    all_C12 = arrayfun(@(l_id) fMapTree.get(l_id), leaves_id,'UniformOutput',0);
    all_C12_refined = cellfun(@(C12) func_bijective_zm_fmap(S1, S2, C12, C12',...
        struct('k_init',size(C12,1),'k_step',1, 'k_final',size(C12,1)+5)),...
        all_C12,'un',0);
    %% keep the unique fmaps with small lapComm and ortho error
    err_lapComm = cellfun(@(C12) func_lapComm(C12, S1.evals, S2.evals), all_C12_refined);
    unique_id = find_unique_fMap_with_smallest_lapComm(all_C12_refined, thres_fmap_dist, err_lapComm);
    keep_id = find(err_lapComm <= max(thres_lapcomm*min(err_lapComm), 0.5));
    keep_id = intersect(keep_id, unique_id);
    
    if length(keep_id) > para.max_width
        [~, id] = sort(err_lapComm(keep_id));
        keep_id = keep_id(id(1:para.max_width));
    end
    
    rm_id = setdiff(leaves_id, leaves_id(keep_id));
   
    for i = keep_id
        l_id = leaves_id(i);
        C12 = fMapTree.get(l_id);
        C12_refined = all_C12_refined{i};
        T21 = fMAP.fMap2pMap(S1.evecs(S1.samples,:), S2.evecs(S2.samples,:), C12_refined);
        C12_new = fMAP.pMap2fMap(S2.evecs(S2.samples, 1:size(C12,1)), S1.evecs(S1.samples, 1:size(C12,2)), T21);
        fMapTree = fMapTree.set(l_id, C12_new);
    end
    
    for i = sort(rm_id,'descend')
        fMapTree = fMapTree.removenode(i);
    end
    
    if fMapTree.depth == curr_depth
        break
    end
end
fprintf('done\n');
fprintf('Tree depth: %d\n', fMapTree.depth);
fprintf('Number of leaves: %d\n', length(fMapTree.findleaves));
end

