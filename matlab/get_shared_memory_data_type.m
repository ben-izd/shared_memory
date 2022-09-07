function out = get_shared_memory_data_type()
    load_shared_memory_library()
    out = check_library_error(calllib('shared_memory','get_shared_memory_data_type'));
    switch out
        case 0
            out = 'uint8';
        case 1
            out = 'uint16';
        case 2
            out = 'uint32';
        case 3
            out = 'uint64';
        case 4
            out = 'int8';
        case 5
            out = 'int16';
        case 6
            out = 'int32';
        case 7
            out = 'int64';
        case 8
            out = 'single';
        case 9
            out = 'double';
        case 10
            out = 'csingle';
        case 11
            out = 'cdouble';
        case 12
            out = 'char';
    end
end