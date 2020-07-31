function f_new = cross_of_function_pair(S,fun1,fun2)
B = S.evecs;
[~,~,G1] = OrientationOp(S,B,fun1);
[~,~,G2] = OrientationOp(S,B,fun2);
n = S.normals_face;
c = zeros(size(G1));
for i = 1:size(G1,1)
    c(i,:) = cross(G1(i,:),G2(i,:));
end
cnew = zeros(S.nv,1);
cnew(:,1) = face2vertex(c(:,1),S.surface.TRIV,S.nv);
cnew(:,2) = face2vertex(c(:,2),S.surface.TRIV,S.nv);
cnew(:,3) = face2vertex(c(:,3),S.surface.TRIV,S.nv);
 
f_new = diag(cnew*S.normals_vtx');
end

function [ SymOp, HOp, G, JGsrc, tmp] = OrientationOp( surface, Lb , H)
% compute its gradient
G = face_grads(surface, H);

% normalize it so that it has unit norm
vn  = sqrt(sum(G'.^2))';
vn = vn + eps;
vn = repmat(vn,1,3);
G = G./vn;

% rotate it by pi/2 using cross product with the normal
JGsrc = -J(surface,G);

% create 1st order differential operators associated with the vector fields
tmp = vf2op(surface, JGsrc);
SymOp = Lb'*surface.A*vf2op(surface, JGsrc)*Lb;
HOp = Lb'*surface.A*vf2op(surface, G)*Lb;
end

