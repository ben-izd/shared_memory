function load_shared_memory_library()
% load_shared_memory_library() load the 'shared_memory' library.
% If you changed the structure of the project, manually define library_path variable.
% This function will be called before all operations calling the shared library functions.
% Header files containing the signatures of functions, \
% should present next to the shared library.

    % Find the directory based on the path and structure of the project
    shared_memory_functions_directory = fileparts(which('set_shared_memory_path'));
    
    library_path = fullfile(shared_memory_functions_directory ...
                            ,'..' ...
                            ,'shared_memory');
    
    if ~libisloaded('shared_memory')
        loadlibrary(library_path)
    end

end