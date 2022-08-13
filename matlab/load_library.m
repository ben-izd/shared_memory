function load_library()
    if ~libisloaded('shared_memory')
        addpath('LIBRARY_PATH_DIRECTORY')
        loadlibrary('shared_memory')
    end
end