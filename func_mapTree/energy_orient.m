function err = energy_orient(S1, S2, C12)
B1 = S1.evecs(:,1:size(C12,2)); B2 = S2.evecs(:,1:size(C12,1));
f1 = zeros(size(B1,2),1); f1(2) = 1;
F1 = B1*f1;
G1 = B2*(C12*f1);

Op1 = OrientationOp(S1, B1, F1);
Op2 = OrientationOp(S2, B2, G1);
scale = max(norm(Op1,'fro'), norm(Op2,'fro'));
Op1 = Op1/scale; Op2 = Op2/scale;
err1 = norm(C12*Op1 - Op2*C12,'fro');
err2 = norm(C12*Op1 + Op2*C12,'fro');
err = err1;
end