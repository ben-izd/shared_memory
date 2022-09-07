function unload_shared_memory_library()
%     shared_memory_functions_directory = which('set_shared_memory_path');
%     library_path=fullfile(shared_memory_functions_directory,'..','shared_memory.dll');
    if libisloaded('shared_memory')
        unloadlibrary('shared_memory')
    end
end