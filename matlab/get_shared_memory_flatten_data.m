function out = get_shared_memory_flatten_data()
    load_library()
    
    %out_pointer=libpointer('int64Ptr', zeros([shared_memory_rank(),1],'uint64'));
    out_pointer = libpointer('doublePtr',zeros(1,get_shared_memory_flatten_length(),'double'));
    [error_code,out]= calllib('shared_memory','get_shared_memory_flatten_data',out_pointer);
    if error_code ~= 0
        error("Error in calling the library. Code: %s",error_code);
    end
end