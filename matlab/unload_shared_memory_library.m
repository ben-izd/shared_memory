function unload_shared_memory_library()
    if libisloaded('shared_memory')
        unloadlibrary('shared_memory')
    end
end