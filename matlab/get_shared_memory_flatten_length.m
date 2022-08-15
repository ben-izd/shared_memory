function out = get_shared_memory_flatten_length()
    load_shared_memory_library()
    out = check_library_error(calllib('shared_memory','get_shared_memory_flatten_length'));
end