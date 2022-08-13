function out = get_shared_memory_dimensions()
    load_library()
    
    out_pointer=libpointer('uint64Ptr', zeros([get_shared_memory_rank(),1],'uint64'));
    [error_code,out]= calllib('shared_memory','get_shared_memory_dimensions',out_pointer);
    
    if error_code~= 0
        error("Error in calling the library. Code: %s",error_code)
    end
end