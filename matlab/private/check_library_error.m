function value = check_library_error(value)
% check_library_error(value) Used to show the proper error based on the value.
% Error values reflect values written in Rust library.

    if value < 0
        switch value
            case -1
                throw(MException('SharedMemory:emptyLibraryPathError','Library path is not set'));
            case -2
                throw(MException('SharedMemory:acessError','Error in accessing shared file (probably file does not exist)'));
            case -3
                throw(MException('SharedMemory:parsingPathError','Can''t read library_path from memory'));
            case -4
                throw(MException('SharedMemory:canNotCreateSharedMemoryError','Can''t create shared memory'));
            case -5
                throw(MException('SharedMemory:newRankDoesNotMatchPreviousRankError','New Rank doesn''t match the previous rank'));
            otherwise
                throw(MException('SharedMemory:invalidErrorCode','Error code (%d) is not valid',value));
        end
    end
end