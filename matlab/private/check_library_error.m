function output = check_library_error(value)
    output = value;
    if value < 0
        switch value
            case -1
                error('Library path is not set')
            case -2
                error('Error in accessing shared file (probably file does not exist)')
            case -3
                error('Can''t read library_path from memory')
            case -4
                error('Can''t create shared memory')
            case -5
                error('New Rank doesn''t match the previous rank')
            otherwise
                error(strcat('Invalid error code is given: ',int2str(value)))
        end
    end
end