module shared_memory

export set_shared_memory_path,set_shared_memory_data,get_shared_memory_data,get_shared_memory_data_type,get_shared_memory_dimensions,get_shared_memory_flatten_data,get_shared_memory_flatten_length,delete_shared_memory,get_shared_memory_rank,SharedMemoryLibraryError
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


function check_library_error(value)::Int32
    if value >= 0
        return value
    else
        throw(SharedMemoryLibraryError(value))
    end
end

function check_library_error_no_return(value::Int32)
    check_library_error(value)
end


function set_shared_memory_path(path::String)
    check_library_error_no_return(ccall((:set_shared_memory_path,LIBRARY_PATH), Cint, (Cstring,),path))
end

function get_shared_memory_flatten_length()::Int64
    return check_library_error(ccall((:get_shared_memory_flatten_length,LIBRARY_PATH), Clonglong, ()))
end

function get_shared_memory_data_type()
    temp = check_library_error(ccall((:get_shared_memory_data_type,LIBRARY_PATH), Cint, ()));
    return [UInt8,UInt16,UInt32,UInt64,Int8,Int16,Int32,Int64,Float32,Float64,ComplexF32,ComplexF64,String][temp+1]
end

function get_shared_memory_rank()
    return check_library_error(ccall((:get_shared_memory_rank,LIBRARY_PATH), Cint, ()))
end

function get_shared_memory_dimensions()::Vector{UInt64}
    dims = Vector{UInt64}(undef,get_shared_memory_rank())
    
    check_library_error(ccall((:get_shared_memory_dimensions,LIBRARY_PATH), Cint, (Ptr{UInt64},),dims))
    
    return dims
end

function get_shared_memory_flatten_data()::Union{String,Vector}
    shared_memory_type = get_shared_memory_data_type();
    shared_memory_flatten_length = get_shared_memory_flatten_length();
    if shared_memory_type == UInt8
        data = Vector{UInt8}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_unsigned_8, LIBRARY_PATH), Cint, (Ptr{UInt8},), data))
    elseif  shared_memory_type == UInt16
        data = Vector{UInt16}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_unsigned_16, LIBRARY_PATH), Cint, (Ptr{UInt16},), data))
    elseif  shared_memory_type == UInt32
        data = Vector{UInt32}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_unsigned_32, LIBRARY_PATH), Cint, (Ptr{UInt32},), data))
    elseif  shared_memory_type == UInt64
        data = Vector{UInt64}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_unsigned_64, LIBRARY_PATH), Cint, (Ptr{UInt64},), data))
    elseif  shared_memory_type == Int8
        data = Vector{Int8}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_signed_8, LIBRARY_PATH), Cint, (Ptr{Int8},), data))
    elseif  shared_memory_type == Int16
        data = Vector{Int16}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_signed_16, LIBRARY_PATH), Cint, (Ptr{Int16},), data))
    elseif  shared_memory_type == Int32
        data = Vector{Int32}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_signed_32, LIBRARY_PATH), Cint, (Ptr{Int32},), data))
    elseif  shared_memory_type == Int64
        data = Vector{Int64}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_signed_64, LIBRARY_PATH), Cint, (Ptr{Int64},), data))
    elseif  shared_memory_type == Float32
        data = Vector{Float32}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_float32, LIBRARY_PATH), Cint, (Ptr{Float32},), data))
    elseif  shared_memory_type == Float64
        data = Vector{Float64}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_float64, LIBRARY_PATH), Cint, (Ptr{Float64},), data))
    elseif  shared_memory_type == ComplexF32
        data = Vector{ComplexF32}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_float32, LIBRARY_PATH), Cint, (Ptr{Float32},), data))
    elseif  shared_memory_type == ComplexF64
        data = Vector{ComplexF64}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_float64, LIBRARY_PATH), Cint, (Ptr{Float64},), data))
    elseif shared_memory_type == String
        data = repeat(" ", shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_string, LIBRARY_PATH), Cint, (Cstring,), data))
    end

    return data
end

function get_shared_memory_data()::Union{String,Array}
    type= get_shared_memory_data_type()
    data = get_shared_memory_flatten_data()
    if type == String
        return data
    end
    
    size=get_shared_memory_dimensions()
    temp = reshape(data,Tuple(size))
    return temp
end

function set_shared_memory_data(data::String)
    check_library_error(ccall((:set_shared_memory_string,LIBRARY_PATH), Cint, (Cstring,),data))
end



function set_shared_memory_data(data::Array)
    temp_dims = convert(Vector{UInt64},collect(size(data)))
    temp_rank = length(temp_dims)
    data_type= eltype(data)
    if data_type == UInt8
        check_library_error(ccall((:set_shared_memory_data_unsigned_8, LIBRARY_PATH), Cint, (Ptr{UInt8},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == UInt16
        check_library_error(ccall((:set_shared_memory_data_unsigned_16, LIBRARY_PATH), Cint, (Ptr{UInt16},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == UInt32
        check_library_error(ccall((:set_shared_memory_data_unsigned_32, LIBRARY_PATH), Cint, (Ptr{UInt32},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == UInt64
        check_library_error(ccall((:set_shared_memory_data_unsigned_64, LIBRARY_PATH), Cint, (Ptr{UInt64},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == Int8
        check_library_error(ccall((:set_shared_memory_data_signed_8, LIBRARY_PATH), Cint, (Ptr{Int8},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == Int16
        check_library_error(ccall((:set_shared_memory_data_signed_16, LIBRARY_PATH), Cint, (Ptr{Int16},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == Int32
        check_library_error(ccall((:set_shared_memory_data_signed_32, LIBRARY_PATH), Cint, (Ptr{Int32},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == Int64
        check_library_error(ccall((:set_shared_memory_data_signed_64, LIBRARY_PATH), Cint, (Ptr{Int64},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == Float32
        check_library_error(ccall((:set_shared_memory_data_float32, LIBRARY_PATH), Cint, (Ptr{Float32},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == Float64
        check_library_error(ccall((:set_shared_memory_data_float64, LIBRARY_PATH), Cint, (Ptr{Float64},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))

    elseif data_type == ComplexF32
        check_library_error(ccall((:set_shared_memory_data_complex_float32, LIBRARY_PATH), Cint, (Ptr{Float32},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    elseif data_type == ComplexF64
        check_library_error(ccall((:set_shared_memory_data_complex_float64, LIBRARY_PATH), Cint, (Ptr{Float64},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
    # converted
    elseif data_type == Float16
        println("Float16 is not supported. Automatically converted to Float32")
        set_shared_memory_data(convert(Array{Float32},data))
    
    # ERROR
    else
        throw(ArgumentError("Datatype "*string(data_type)*" is not supported."))
    end
    
    # check_library_error(ccall((:set_shared_memory_data, LIBRARY_PATH), Cint, (Ptr{Float64},Ptr{UInt64},UInt64), data,temp_dims,temp_rank))
end


function delete_shared_memory()
    check_library_error(ccall((:delete_shared_memory, LIBRARY_PATH), Cint, ()))
end

end