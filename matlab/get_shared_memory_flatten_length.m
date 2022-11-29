function out = get_shared_memory_flatten_length()
% get_shared_memory_flatten_length() return the product of dimensions.

    load_shared_memory_library()

    out = check_library_error(calllib('shared_memory', 'get_shared_memory_flatten_length'));
end