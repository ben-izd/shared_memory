function unload_library()
    if libisloaded('shared_memory')
        unloadlibrary('shared_memory')
    end
end