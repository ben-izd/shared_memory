function delete_shared_memory()
% delete_shared_memory() Unload the data from memory if it can connect to it, otherwise will remove the specified file.

    load_shared_memory_library();
    
    check_library_error(calllib('shared_memory','delete_shared_memory'));
    
end