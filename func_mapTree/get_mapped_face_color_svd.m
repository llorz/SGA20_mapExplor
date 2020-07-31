function [S1_col,S2_col]= get_mapped_face_color_svd(S1, S2, map, col_idx)

if nargin < 4, col_idx = [1,2,3]; end

X = S2.surface.VERT;

X_new = X - mean(X);
[U,~,V] = svd(X_new);
X_new = X_new*V;

X_new = X*diag(sign(col_idx));
X_new = X_new(:,abs(col_idx));

g1 = X_new(:,1);
g2 = X_new(:,2);
g3 = X_new(:,3);


g1 = normalize_function(0,1,g1);
g2 = normalize_function(0,1,g2);
g3 = normalize_function(0,1,g3);

g1 = cos(g1);
g2 = cos(g2);
g3 = cos(g3);

g1 = normalize_function(0,1,g1);
g2 = normalize_function(0,1,g2);
g3 = normalize_function(0,1,g3);


f1 = g1(map);
f2 = g2(map);
f3 = g3(map);
S1_col = [f1,f2,f3]; % S1 face color f
S2_col = [g1,g2,g3]; % S2 face color g


end

function fnew = normalize_function(min_new,max_new,f)
fnew = f - min(f);
fnew = (max_new-min_new)*fnew/max(fnew) + min_new;
end