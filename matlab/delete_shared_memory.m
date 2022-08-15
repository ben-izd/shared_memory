function out=delete_shared_memory()
    load_shared_memory_library()
    out= check_library_error(calllib('shared_memory','delete_shared_memory'));
    
end