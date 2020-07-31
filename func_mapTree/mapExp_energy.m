function eval = mapExp_energy(C12_full, C21_full, Ev1, Ev2)
eval = zoomOut_energy(C12_full) + zoomOut_energy(C21_full);
for k = 1:size(C12_full,1)
    C12 = C12_full(1:k, 1:k);
    C21 = C21_full(1:k, 1:k);
    tmp1 = norm(C12*C21 - eye(k), 'fro')^2;
    tmp2 = norm(C21*C12 - eye(k), 'fro')^2;
    tmp3 = norm(C12*diag(Ev1(1:k)) - diag(Ev2(1:k))*C12);
    tmp4 = norm(C21*diag(Ev2(1:k)) - diag(Ev1(1:k))*C21);
    eval = eval + (tmp1 + tmp2 + tmp3 + tmp4)/k;
end
end