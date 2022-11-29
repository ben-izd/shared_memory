function out = get_shared_memory_rank()
% get_shared_memory_rank() return shared memory data rank.
% For string 1 will be returned.

    load_shared_memory_library()

    out = check_library_error(calllib('shared_memory', 'get_shared_memory_rank'));
end