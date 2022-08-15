# CAN BE CHANGED BY USER
LIBRARY_PATH = joinpath(@__DIR__,"..","shared_memory.dll")
# END

struct SharedMemoryLibraryError <: Exception
    error_code::Int32
end

function Base.showerror(io::IO, e::SharedMemoryLibraryError)
    error_code = e.error_code
    message::String = ""

    if error_code == -1
        message = "Library path is not set"
    elseif error_code == -2
        message = "Error in accessing shared file (probably file does not exist)"
    elseif error_code == -3
        message = "Can't read library_path from memory"
    elseif error_code == -4
        message = "Can't create shared memory"
    elseif error_code == -5
        message = "New Rank doesn't match the previous rank"
    else
        throw(ArgumentError("Invalid error code is given: " * string(error_code)))
    end
    print(message)
end


function check_library_error(value::Int32)::Int32
    if value >= 0
        return value
    else
        throw(SharedMemoryLibraryError(value))
    end
end


function set_shared_memory_path(path::String)
    check_library_error(ccall((:set_shared_memory_path,LIBRARY_PATH), Cint, (Cstring,),path))
end

function get_shared_memory_flatten_length()::Int64
    return check_library_error(ccall((:get_shared_memory_flatten_length,LIBRARY_PATH), Clonglong, ()))
end

function get_shared_memory_rank()
    return check_library_error(ccall((:get_shared_memory_rank,LIBRARY_PATH), Cint, ()))
end

function get_shared_memory_dimensions()::Vector{UInt64}
    dims = Vector{UInt64}(undef,get_shared_memory_rank())
    
    check_library_error(ccall((:get_shared_memory_dimensions,LIBRARY_PATH), Cint, (Ptr{UInt64},),dims))
    
    return dims
end

function get_shared_memory_flatten_data()::Vector{Float64}
    data = Vector{Float64}(undef, get_shared_memory_flatten_length())
    check_library_error(ccall((:get_shared_memory_flatten_data, LIBRARY_PATH), Cint, (Ptr{Float64},), data))
    return data
end

function get_shared_memory_data()::Int32
    data = get_shared_memory_flatten_data()
    size=get_shared_memory_dimensions()
    temp = reshape(data,Tuple(size))
    return temp
end

function set_shared_memory_data(data::Array)
    temp_dims = convert(Vector{UInt64},collect(size(data)))
    temp_rank = length(temp_dims)
    if eltype(data) != Float64
        println("[Warnning] Data should be type double. Converted automatically.")
        data= convert(Array{Float64},data)
    end
    
    check_library_error(ccall((:set_shared_memory_data, LIBRARY_PATH), Cint, (Ptr{Float64},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
end


function delete_shared_memory()
    check_library_error(ccall((:delete_shared_memory, LIBRARY_PATH), Cint, ()))
end
