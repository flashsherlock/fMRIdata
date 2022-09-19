function S = catfields(S, T, dim)
% concatenate fields of T to S
    if nargin < 3
        dim = 1;
    end
    fields = fieldnames(S);
    for k = 1:numel(fields)
        aField     = fields{k};
        S.(aField) = cat(dim, S.(aField), T.(aField));
    end
end
