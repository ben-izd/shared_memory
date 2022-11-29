function out = set_shared_memory_data(data)
% set_shared_memory_data(data) will store the datat in shared memory.
% data can be type of array of supported types or char

    load_shared_memory_library()

    data_size = size(data);
    temp_rank = uint64(ndims(data));
    if data_size(1) == 1
        data_size = data_size(2:end);
        temp_rank = temp_rank - 1;
    end
    dimensions_pointer = libpointer('uint64Ptr', uint64(data_size));


    data_type = class(data);
    switch data_type
        case 'uint8'
            data_pointer = libpointer('uint8Ptr', data);
            out = check_library_error(calllib('shared_memory' ...
                                      , 'set_shared_memory_data_unsigned_8' ...
                                      , data_pointer, dimensions_pointer, temp_rank));

        case 'uint16'
            data_pointer = libpointer('uint16Ptr', data);
            out = check_library_error(calllib('shared_memory' ...
                                      , 'set_shared_memory_data_unsigned_16' ...
                                      , data_pointer, dimensions_pointer, temp_rank));

        case 'uint32'
            data_pointer = libpointer('uint32Ptr', data);
            out = check_library_error(calllib('shared_memory' ...
                                      , 'set_shared_memory_data_unsigned_32' ...
                                      , data_pointer, dimensions_pointer, temp_rank));

        case 'uint64'
            data_pointer = libpointer('uint64Ptr', data);
            out = check_library_error(calllib('shared_memory' ...
                                      , 'set_shared_memory_data_unsigned_64' ...
                                      , data_pointer, dimensions_pointer, temp_rank));

        case 'int8'
            % typecast is used to prevent matlab from confusing array of number by char
            data_pointer = libpointer('uint8Ptr', typecast(data(:),'uint8'));
            out = check_library_error(calllib('shared_memory' ...
                                      , 'set_shared_memory_data_signed_8' ...
                                      , data_pointer, dimensions_pointer, temp_rank));

        case 'int16'
            data_pointer = libpointer('int16Ptr', data);
            out = check_library_error(calllib('shared_memory' ...
                                      , 'set_shared_memory_data_signed_16' ...
                                      , data_pointer, dimensions_pointer, temp_rank));

        case 'int32'
            data_pointer = libpointer('int32Ptr', data);
            out = check_library_error(calllib('shared_memory' ...
                                      , 'set_shared_memory_data_signed_32' ...
                                      , data_pointer, dimensions_pointer, temp_rank));

        case 'int64'
            data_pointer = libpointer('int64Ptr', data);
            out = check_library_error(calllib('shared_memory' ...
                                      , 'set_shared_memory_data_signed_64' ...
                                      , data_pointer, dimensions_pointer, temp_rank));

        case 'char'
            out=check_library_error(calllib('shared_memory','set_shared_memory_string' ...
                                            ,data));

        case 'string'
            out=check_library_error(calllib('shared_memory','set_shared_memory_string' ...
                                            ,char(data)));

        otherwise
            % Because class() return single for both single numbers and single complex numbers, \
            % first we check the real arrays, then complex one

            if isreal(data)
                if strcmp(data_type, 'single')
                    data_pointer = libpointer('singlePtr', data);
                    out = check_library_error(calllib('shared_memory' ...
                                              , 'set_shared_memory_data_float32' ...
                                              , data_pointer, dimensions_pointer, temp_rank));

                elseif strcmp(data_type, 'double')
                    data_pointer = libpointer('doublePtr', data);
                    out = check_library_error(calllib('shared_memory' ...
                                              , 'set_shared_memory_data_float64' ...
                                              , data_pointer, dimensions_pointer, temp_rank));
                else
                    error("Type ""%s"" is not supported.",data_type);
                end
            else
                % complex-64 (single)
                if strcmp(data_type, 'single')
                    data_real = real(data);
                    data_imag = imag(data);
                    temp = [data_real(:)';data_imag(:)'];
                    data_pointer = libpointer('singlePtr', temp);
                    out = check_library_error(calllib('shared_memory' ...
                                              , 'set_shared_memory_data_complex_float32' ...
                                              , data_pointer, dimensions_pointer, temp_rank));

                % complex-128 (double)                
                elseif strcmp(data_type, 'double')
                    data_real = real(data);
                    data_imag = imag(data);
                    temp = [data_real(:)';data_imag(:)'];
                    data_pointer = libpointer('doublePtr', temp);
                    out = check_library_error(calllib('shared_memory' ...
                                                      , 'set_shared_memory_data_complex_float64' ...
                                                      , data_pointer, dimensions_pointer ...
                                                      , temp_rank));
                else
                    error("Type ""%s"" is not supported.",data_type);
                end
            end
    end  
    
end