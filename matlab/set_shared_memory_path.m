function out = set_shared_memory_path(path)
    load_library()
    if exist(path,"file")
        out = calllib('shared_memory','set_shared_memory_path',char(path));
    else
        error('Invalid path is given')
    end
end