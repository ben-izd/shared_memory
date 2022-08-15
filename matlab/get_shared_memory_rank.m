function out = get_shared_memory_rank()
    load_shared_memory_library()
    out = check_library_error(calllib('shared_memory','get_shared_memory_rank'));
end