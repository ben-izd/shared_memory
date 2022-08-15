function load_shared_memory_library()
    if ~libisloaded('shared_memory')
        loadlibrary('shared_memory')
    end
end