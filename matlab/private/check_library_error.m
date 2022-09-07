function output = check_library_error(value)
    output = value;
    if value < 0
        switch value
            case -1
                throw(MException('SharedMemory:emptyLibraryPathError','Library path is not set'));
%                 error('Library path is not set')
            case -2
                throw(MException('SharedMemory:acessError','Error in accessing shared file (probably file does not exist)'));
%                 error('Error in accessing shared file (probably file does not exist)')
            case -3
                throw(MException('SharedMemory:parsingPathError','Can''t read library_path from memory'));
%                 error('Can''t read library_path from memory')
            case -4
                throw(MException('SharedMemory:canNotCreateSharedMemoryError','Can''t create shared memory'));
%                 error('Can''t create shared memory')
            case -5
                throw(MException('SharedMemory:newRankDoesNotMatchPreviousRankError','New Rank doesn''t match the previous rank'));
%                 error('New Rank doesn''t match the previous rank')
            otherwise
                throw(MException('SharedMemory:invalidErrorCode','Error code (%d) is not valid',value));
%                 error(strcat('Invalid error code is given: ',int2str(value)))
        end
    end
end