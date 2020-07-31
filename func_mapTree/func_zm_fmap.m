function [ C12, C21] = func_zm_fmap(S1, S2, C12_ini, C21_ini, para)

s1_id = S1.samples;
s2_id = S2.samples;

B1_all = S1.evecs(s1_id, :);
B2_all = S2.evecs(s2_id, :);

T12 = fMAP.fMap2pMap(B2_all, B1_all, C21_ini);
T21 = fMAP.fMap2pMap(B1_all, B2_all, C12_ini);


for k = para.k_init : para.k_step : para.k_final
    
    B1 = B1_all(:, 1:k);
    B2 = B2_all(:, 1:k);
    
    C21 = B1\ B2(T12,:);
    T12 = knnsearch(B2*C21', B1);
    
    C12 = B2\ B1(T21,:);
    T21 = knnsearch(B1*C12', B2);
end

T12 = fMAP.fMap2pMap(S2.evecs, S1.evecs, C21);
T21 = fMAP.fMap2pMap(S1.evecs, S2.evecs, C12);

end