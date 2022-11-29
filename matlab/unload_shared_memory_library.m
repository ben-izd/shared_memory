function unload_shared_memory_library()
% unload_shared_memory_library() will unload 'shared_memory' library.
% See also load_shared_memory_library
    
    if libisloaded('shared_memory')
        unloadlibrary('shared_memory')
    end
end