function [all_T] = find_mulitple_maps_single_shape(S1, para)
%% preprocessing: normalize the mesh and compute repeating eigenvalues
S1 = normalize_mesh_area(S1,1);
S1 = mesh_with_consistent_fields(S1);
S1 = MESH.compute_LaplacianBasis(S1, para.num_eigs);
S1.repeatedID = get_repeated_eigenvalues(S1.evals, para.thres_repeating_eigs);
S1.samples = MESH.get_samples(S1, para.num_samples_on_shape, 'euclidean');
S2 = S1;

%% explore the map tree of the shape
[fMapTree] = explore_map_space(S1, S2, para);

% find all leaves/maps of the map tree
leaves_id = fMapTree.findleaves;
all_C12 = arrayfun(@(l_id) fMapTree.get(l_id), leaves_id,'UniformOutput',0);
all_C12_refined = cellfun(@(C12) func_bijective_zm_fmap(S1, S2, C12, C12',...
    struct('k_init',size(C12,1),'k_step',5, 'k_final',para.stop_dim)),...
    all_C12,'un',0);


% keep the unique fmaps with small lapComm
func_lapComm = @(C12, Ev1, Ev2) norm(C12*diag(Ev1(1:size(C12, 2))) - diag(Ev2(1:size(C12, 1)))*C12, 'fro')/(size(C12,1)*size(C12,2));
err_lapComm = cellfun(@(C12) func_lapComm(C12, S1.evals, S2.evals), all_C12_refined);

unique_id = find_unique_fMap_with_smallest_lapComm(all_C12_refined, para.thres_fmap_dist, err_lapComm);
all_C12_refined = all_C12_refined(unique_id);
err = cellfun(@(C12) func_lapComm(C12, S1.evals, S2.evals), all_C12_refined);

[~, sorted_id] = sort(err);
id = sorted_id(1:min(length(err),para.num_maps_keep));

all_C12_refined = all_C12_refined(id);
all_T = cellfun(@(C12) fMAP.fMap2pMap(S1.evecs, S2.evecs,C12),all_C12_refined,'un',0);
end