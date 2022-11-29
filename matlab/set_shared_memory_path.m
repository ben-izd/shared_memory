function out = set_shared_memory_path(path)
% set_shared_memory_path(path) Set the path used to access the shared memory.
% path should be either char or string. Otherwise will raise error.
    
    is_path_char = ischar(path);
    
    if is_path_char || isstring(path)
        load_shared_memory_library();
        
        if is_path_char
            out = check_library_error(calllib('shared_memory' ...
                              ,'set_shared_memory_path', path));
        else
            out = check_library_error(calllib('shared_memory' ...
                              ,'set_shared_memory_path', char(path)));
        end
        
    else
        % path is not valid
        error('Error. Input argument should be of type string or char not a "%s"',path_type);
    end

end