function cnew = func_grad_on_vtx(S1, F1)
G = face_grads(S1, F1);
vn  = sqrt(sum(G'.^2))';
vn = vn + eps;
vn = repmat(vn,1,3);
G = G./vn;
c = G;
cnew = zeros(S1.nv,1);
cnew(:,1) = face2vertex(c(:,1),S1.surface.TRIV,S1.nv);
cnew(:,2) = face2vertex(c(:,2),S1.surface.TRIV,S1.nv);
cnew(:,3) = face2vertex(c(:,3),S1.surface.TRIV,S1.nv);
end