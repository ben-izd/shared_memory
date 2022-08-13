function out = get_shared_memory_flatten_length()
    load_library()
    out = calllib('shared_memory','get_shared_memory_flatten_length');
end