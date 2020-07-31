function [all_C12_block] = get_all_possible_blocks(k1, k2)
if k1 > 1
    all_combs = dec2base(0:k1^k2-1,k1)-'0'+1;  %//  generate all tuples to match k2 to k1
else
    all_combs = ones(k2, 1);
end
all_signs = dec2base(0:2^k2-1,2)-'0'+1;
all_C12_block = cell((2*k1)^k2,1);
count = 1;
for id = 1:size(all_combs,1)
    comb = all_combs(id,:);
    for i_sign = 1:length(all_signs)
        sign = all_signs(i_sign,:);
        all_C12_block{count} = sparse(1:k2, comb, (-1).^sign, k2, k1);
        count = count + 1;
    end
end
end