function repeatedID = get_repeated_eigenvalues(Ev1, thres)

rest_Ev1 = Ev1;
eps = 1e-6;
repeatedID = {};
i = 0;
if nargin < 2
    thres = 2;
end

while(~isempty(rest_Ev1))
    id = find(rest_Ev1 < thres *i + eps);
    if ~isempty(id)
        repeatedID{end+1} = find(ismember(Ev1, rest_Ev1(id)));
    end
    rest_Ev1(id) = [];
    i = i+1;
end
end