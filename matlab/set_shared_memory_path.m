function out = set_shared_memory_path(path)
    load_shared_memory_library()
    
    out = check_library_error(calllib('shared_memory','set_shared_memory_path',char(path)));
    
end