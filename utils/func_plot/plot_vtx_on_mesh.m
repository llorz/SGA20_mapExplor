function [] = plot_vtx_on_mesh(S,vid)
trimesh(S.surface.TRIV, S.surface.X, S.surface.Y, S.surface.Z, ...
    'FaceColor',[0.7 0.7 0.7], 'EdgeColor', 'none','FaceAlpha',0.65); axis equal; axis off;
hold on;
scatter3(S.surface.X(vid),S.surface.Y(vid),S.surface.Z(vid),20,'filled'); hold off;
end