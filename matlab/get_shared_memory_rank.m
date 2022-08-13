function out = get_shared_memory_rank()
    load_library()
    out = calllib('shared_memory','get_shared_memory_rank');
end