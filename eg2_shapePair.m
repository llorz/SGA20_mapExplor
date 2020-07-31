clc; clf; clear;
%%
rng(2)
addpath(genpath('./utils/'));
addpath(genpath('./func_mapTree/'));
%%
para.num_samples_on_shape = 200; %
para.num_eigs = 50; % num eigenfunctions to compute (= stop_dim)
para.thres_lapcomm = 1.5; % threshold for the Laplacian Commutativity 
para.thres_ortho = 0.5; % threshold for the orthogonality
para.thres_fmap_dist = 0.5; % if the normalized distance between two fmaps is smaller than this threshold, we assume these two maps are equivalent after applying zoomout
para.stop_dim = 20; % the maximum depth of the tree
para.max_width = 10; % the largest width of the tree at each depth (to speed up with expanding the tree too wide)
para.num_maps_keep = 8; % the number of maps that are selected from the map tree
para.thres_repeating_eigs = 0.1; % threshold 

%%
mesh_dir = './dataset/FAUST/';
s1_name = 'tr_reg_000.off';
s2_name = 'tr_reg_001.off';

mesh_dir = './dataset/SHREC19_remeshed/';
s1_name = '2.obj';
s2_name = '20.obj';


S1 = MESH.MESH_IO.read_shape([mesh_dir, s1_name]);
S2 = MESH.MESH_IO.read_shape([mesh_dir, s2_name]);
[all_T12, all_T21] = find_mulitple_maps_shape_pair(S1, S2, para);
%% visualize the computed maps
view_pos = [0,90];
figure(2); clf;
num = length(all_T12);
subplot(4,ceil((num+1)/4),1); visualize_map_on_source(S1, S2, all_T12{1}); view(view_pos); title('Source')
for i = 1:num
    T12 = all_T12{i};
    subplot(4,ceil((num+1)/4),i+1); visualize_map_on_target(S1, S2, T12); view(view_pos);
    title(['map ',num2str(i,'%02d')]);
end
