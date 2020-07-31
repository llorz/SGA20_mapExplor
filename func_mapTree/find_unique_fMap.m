function unique_id = find_unique_fMap(all_C12, thres_fMap_dist)
unique_C12 = {all_C12{1}};
unique_id = 1;
if length(all_C12) > 1
    for ii = 2:length(all_C12)
        dist = cellfun(@(C) norm(all_C12{ii} - C, 'fro')/norm(C,'fro'), unique_C12);
        if sum(dist > thres_fMap_dist) == length(unique_C12)
            unique_C12{end+1} = all_C12{ii};
            unique_id(end+1) = ii;
        end
    end
    
end
end