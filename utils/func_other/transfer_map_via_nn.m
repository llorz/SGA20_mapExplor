function [T12_, S1_, S2_] = transfer_map_via_nn(T12, s1_name, s2_name, source_dir, target_dir)
S1 = MESH.MESH_IO.read_shape([source_dir, s1_name, '.obj']);
S2 = MESH.MESH_IO.read_shape([source_dir, s2_name, '.obj']);


S1_ = MESH.MESH_IO.read_shape([target_dir, s1_name, '.obj']);
S2_ = MESH.MESH_IO.read_shape([target_dir, s2_name, '.obj']);

T11 = knnsearch(S1.surface.VERT, S1_.surface.VERT);
T22 = knnsearch(S2_.surface.VERT, S2.surface.VERT);
T12_ = T22(T12(T11));
end