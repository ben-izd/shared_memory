function out = get_shared_memory_data()
    load_shared_memory_library()
    out = get_shared_memory_flatten_data();
    dimensions=get_shared_memory_dimensions();
    if length(dimensions) > 1
        out = reshape(out,dimensions');
    end
end