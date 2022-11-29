function out = get_shared_memory_flatten_data()
% get_shared_memory_flatten_data() returns the shared memory data.
% Return type is either array of supported type or char.

    load_shared_memory_library()

    error_code = 0;
    switch get_shared_memory_data_type()

        case 'uint8'
            out_pointer = libpointer('uint8Ptr', zeros(1, get_shared_memory_flatten_length(), 'uint8'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_unsigned_8' ...
                                        , out_pointer);

        case 'uint16'
            out_pointer = libpointer('uint16Ptr', zeros(1, get_shared_memory_flatten_length(), 'uint16'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_unsigned_16' ...
                                        , out_pointer);

        case 'uint32'
            out_pointer = libpointer('uint32Ptr', zeros(1, get_shared_memory_flatten_length(), 'uint32'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_unsigned_32' ...
                                        , out_pointer);

        case 'uint64'
            out_pointer = libpointer('uint64Ptr', zeros(1, get_shared_memory_flatten_length(), 'uint64'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_unsigned_64' ...
                                        , out_pointer);

        case 'int8'
            % 'uint8' is used to prevent matlab from confusing array of number by char
            out_pointer = libpointer('uint8Ptr', zeros(1, get_shared_memory_flatten_length(), 'uint8'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_unsigned_8' ...
                                        , out_pointer);

            out = typecast(out, 'int8');

        case 'int16'
            out_pointer = libpointer('int16Ptr', zeros(1, get_shared_memory_flatten_length(), 'int16'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_signed_16' ...
                                        , out_pointer);

        case 'int32'
            out_pointer = libpointer('int32Ptr',zeros(1, get_shared_memory_flatten_length(), 'int32'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_signed_32' ...
                                        , out_pointer);

        case 'int64'
            out_pointer = libpointer('int64Ptr',zeros(1, get_shared_memory_flatten_length(), 'int64'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_signed_64' ...
                                        , out_pointer);

        case 'single'
            out_pointer = libpointer('singlePtr', zeros(1, get_shared_memory_flatten_length(), 'single'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_float32' ...
                                        , out_pointer);

        case 'double'
            out_pointer = libpointer('doublePtr', zeros(1, get_shared_memory_flatten_length(), 'double'));

            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_float64' ...
                                        , out_pointer);

        case 'char'
            out_pointer = libpointer('cstring', blanks(get_shared_memory_flatten_length()));
            [error_code, out] = calllib('shared_memory', 'get_shared_memory_string', out_pointer);

        case 'csingle'
            out_pointer = libpointer('singlePtr', zeros(1, get_shared_memory_flatten_length() * 2, 'single'));
            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_float32' ...
                                        , out_pointer);

            out = complex(out(1:2:end), out(2:2:end));

        case 'cdouble'
            out_pointer = libpointer('doublePtr', zeros(1, get_shared_memory_flatten_length() * 2, 'double'));
            [error_code, out] = calllib('shared_memory', 'get_shared_memory_flatten_data_float64' ...
                                        , out_pointer);

            out = complex(out(1:2:end), out(2:2:end));
            
        otherwise
            error('Retrieving type "%s" is not implemented in Python.', get_shared_memory_data_type())
    end
    
    check_library_error(error_code);
end