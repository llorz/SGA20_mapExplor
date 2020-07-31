clc; clf; clear;
%%
addpath(genpath('./utils/'));
addpath(genpath('./func_mapTree/'));
%% parameters
para.num_samples_on_shape = 200; %
para.num_eigs = 50; % num eigenfunctions to compute (= stop_dim)
para.thres_lapcomm = 1.5; % threshold for the Laplacian Commutativity
para.thres_ortho = 0.5; % threshold for the orthogonality
para.thres_fmap_dist = 0.5; % if the normalized distance between two fmaps is smaller than this threshold, we assume these two maps are equivalent after applying zoomout
para.stop_dim = 20; % the maximum depth of the tree
para.max_width = 10; % the largest width of the tree at each depth (to speed up with expanding the tree too wide)
para.num_maps_keep = 8; % the number of maps that are selected from the map tree
para.thres_repeating_eigs = 0.1; % threshold
%% you can try different meshes
mesh_dir = './dataset/FAUST/';
s_name = 'tr_reg_000.off';


mesh_dir = './dataset/';
s_name = 'knot.obj';
s_name = 'table.obj';

mesh_dir = './dataset/SHREC19_remeshed/';
s_name = '20.obj';

%%
S1 = MESH.MESH_IO.read_shape([mesh_dir, s_name]);

[all_pMap] = find_mulitple_maps_single_shape(S1, para);

%% visualize the computed maps
view_pos = [0,90];
figure(1); clf;
num = length(all_pMap);
subplot(4,ceil((num+1)/4),1); visualize_map_on_source(S1, S1, all_pMap{1}); view(view_pos); title('Source')
for i = 1:num
    T21 = all_pMap{i};
    subplot(4,ceil((num+1)/4),i+1); visualize_map_on_target(S1, S1, T21); view(view_pos);
    title(['map ',num2str(i,'%02d')]);
end

return
%% we can further apply zoomout to refine the selected map
% S1.samples = MESH.get_samples(S1, 1000, 'euclidean');
% S1 = MESH.compute_LaplacianBasis(S1, 50);
% S2 = S1;
% all_T12 = all_pMap; all_T21 = all_pMap;
% para2.k_init = para.stop_dim;
% para2.k_step = 5; %10
% para2.k_final = 50;
% num = length(all_T12);
% all_T12_refined = cell(size(all_T12));
% all_T21_refined = cell(size(all_T21));
% all_C12_refined = cell(num, 1);
% all_C21_refined = cell(num, 1);
% for i = 1:length(all_T12)
%     T12_ini = all_T12{i}; T21_ini = all_T21{i};
%     [T12, T21, C12, C21] = func_bijective_zm(S1, S2, T12_ini, T21_ini, para2);
%     all_T12_refined{i} = T12; all_T21_refined{i} = T21;
%     all_C12_refined{i} = C12; all_C21_refined{i} = C21;
% end