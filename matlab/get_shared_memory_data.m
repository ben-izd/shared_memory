function out = get_shared_memory_data()
% get_shared_memory_data() returns the shared memory data in the specified dimension

    load_shared_memory_library()

    out = get_shared_memory_flatten_data();

    % If is empty return empty
    if isempty(out)
        return;
    end

    % If is char, return it
    if strcmp(get_shared_memory_data_type ,'char')
        return;
    end

    % If is array, return it with the specified dimension
    dimensions = get_shared_memory_dimensions();

    if length(dimensions) > 1
        out = reshape(out,dimensions);
    end
end