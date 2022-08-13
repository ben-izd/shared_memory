function delete_shared_memory()
    load_library()
    error_code = calllib('shared_memory','delete_shared_memory');
    if error_code ~= 0
        error("Error in sharing data. Code: %s",error_code);
    end
end