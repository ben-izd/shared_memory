function out = set_shared_memory_data(data)
    load_shared_memory_library()
    
    
    if ~isnumeric(data) || ~isa(data,'double')
        data=typecast(data,'double');
        warnning("Only double matrices can be shared. Data will be converted automatically.")
    end
    data_pointer=libpointer('doublePtr', data);
    dimensions_pointer=libpointer('uint64Ptr', uint64(size(data)));
    
%     temp_dims = size(data);
    temp_rank = ndims(data);
    out=check_library_error(calllib('shared_memory','set_shared_memory_data',data_pointer,dimensions_pointer,uint64(temp_rank)));
    
end