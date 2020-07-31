function unique_id = find_unique_fMap_with_smallest_lapComm(all_C12, thres_fMap_dist, err_C12)
unique_C12 = {all_C12{1}};
unique_id = 1;
if length(all_C12) > 1
    for ii = 2:length(all_C12)
        dist = cellfun(@(C) norm(all_C12{ii} - C, 'fro')/norm(C,'fro'), unique_C12);
        if sum(dist > thres_fMap_dist) == length(unique_C12) % the map is unique
            unique_C12{end+1} = all_C12{ii};
            unique_id(end+1) = ii;
        else
            [~, id] = min(dist);
            map_id = unique_id(id);
            if err_C12(ii) < err_C12(map_id)
                unique_id(id) = ii;
                unique_C12{id} = all_C12{ii};
            end
        end
    end
    
end
end