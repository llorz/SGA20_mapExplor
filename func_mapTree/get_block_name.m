function block_name = get_block_name(k1_id, k2_id)

block_name = '[';
if length(k1_id) == 1
    block_name = [block_name, num2str(k1_id(1)),', '];
else
    block_name = [block_name, num2str(k1_id(1)),'-', num2str(k1_id(end)),', '];
end

if length(k2_id) == 1
    block_name = [block_name, num2str(k2_id(1)),']'];
else
    block_name = [block_name, num2str(k2_id(1)),'-', num2str(k1_id(end)),']'];
end
end