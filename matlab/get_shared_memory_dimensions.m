function out = get_shared_memory_dimensions()
% get_shared_memory_dimensions() returns the shared memory dimension.
% For string it's the length of string without null character.

    load_shared_memory_library()
    
    % pre-allocate array to store dimension
    out_pointer = libpointer('uint64Ptr', zeros([1, get_shared_memory_rank()], 'uint64'));
    
    [error_code, out] = calllib('shared_memory', 'get_shared_memory_dimensions', out_pointer);
    
    check_library_error(error_code);
end