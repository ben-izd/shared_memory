function out = set_shared_memory_data(data)
    load_shared_memory_library()

    data_size=size(data);
    temp_rank = uint64(ndims(data));
    if data_size(1) == 1
        data_size=data_size(2:end);
        temp_rank = temp_rank - 1;
    end
    dimensions_pointer=libpointer('uint64Ptr', uint64(data_size));

    
% isa(data,'uint8')
    data_type = class(data);
    switch data_type
        case 'uint8'
            data_pointer=libpointer('uint8Ptr', data);
            out=check_library_error(calllib('shared_memory','set_shared_memory_data_unsigned_8',data_pointer,dimensions_pointer,temp_rank));
        case 'uint16'
            data_pointer=libpointer('uint16Ptr', data);
            out=check_library_error(calllib('shared_memory','set_shared_memory_data_unsigned_16',data_pointer,dimensions_pointer,temp_rank));
        case 'uint32'
            data_pointer=libpointer('uint32Ptr', data);
            out=check_library_error(calllib('shared_memory','set_shared_memory_data_unsigned_32',data_pointer,dimensions_pointer,temp_rank));
        case 'uint64'
            data_pointer=libpointer('uint64Ptr', data);
            out=check_library_error(calllib('shared_memory','set_shared_memory_data_unsigned_64',data_pointer,dimensions_pointer,temp_rank));
        case 'int8'
            % voidPtr
            % data_pointer=libpointer('int8Ptr', data);
            data_pointer=libpointer('uint8Ptr', typecast(data(:),'uint8'));
            out=check_library_error(calllib('shared_memory','set_shared_memory_data_signed_8',data_pointer,dimensions_pointer,temp_rank));
        case 'int16'
            data_pointer=libpointer('int16Ptr', data);
            out=check_library_error(calllib('shared_memory','set_shared_memory_data_signed_16',data_pointer,dimensions_pointer,temp_rank));
        case 'int32'
            data_pointer=libpointer('int32Ptr', data);
            out=check_library_error(calllib('shared_memory','set_shared_memory_data_signed_32',data_pointer,dimensions_pointer,temp_rank));
        case 'int64'
            data_pointer=libpointer('int64Ptr', data);
            out=check_library_error(calllib('shared_memory','set_shared_memory_data_signed_64',data_pointer,dimensions_pointer,temp_rank));
        case 'char'
            out=check_library_error(calllib('shared_memory','set_shared_memory_string',data));
        otherwise
            if ~isreal(data) && isa(data,'single') % complex double - 128
                data_real = real(data);
                data_imag = imag(data);
                temp=[data_real(:)';data_imag(:)'];
                data_pointer=libpointer('singlePtr', temp);
                out=check_library_error(calllib('shared_memory','set_shared_memory_data_complex_float32',data_pointer,dimensions_pointer,temp_rank));
            elseif ~isreal(data) && isa(data,'double') % complex double - 256 
                data_real = real(data);
                data_imag = imag(data);
                temp=[data_real(:)';data_imag(:)'];
                data_pointer=libpointer('doublePtr', temp);
                out=check_library_error(calllib('shared_memory','set_shared_memory_data_complex_float64',data_pointer,dimensions_pointer,temp_rank));
            elseif strcmp(data_type ,'single')
                data_pointer=libpointer('singlePtr', data);
                out=check_library_error(calllib('shared_memory','set_shared_memory_data_float32',data_pointer,dimensions_pointer,temp_rank));
            elseif strcmp(data_type ,'double')
                data_pointer=libpointer('doublePtr', data);
                out=check_library_error(calllib('shared_memory','set_shared_memory_data_float64',data_pointer,dimensions_pointer,temp_rank));
            else
                error("Type is not supported.")
            end
    end
%     if ~isnumeric(data) || ~isa(data,'double')
%         data=typecast(data,'double');
%         warnning("Only double matrices can be shared. Data will be converted automatically.")
%     end

%     temp_dims = size(data);

    
    
end