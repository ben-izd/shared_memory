"""
 Unlike python interface, all external function call was done in place and the functions are not saved
into variables since all of them are called once.
"""
module shared_memory

export set_shared_memory_path ,
        set_shared_memory_data ,
        get_shared_memory_data ,
        get_shared_memory_data_type ,
        get_shared_memory_dimensions ,
        get_shared_memory_flatten_data ,
        get_shared_memory_flatten_length ,
        delete_shared_memory ,
        get_shared_memory_rank ,
        SharedMemoryLibraryError;

# CAN BE CHANGED BY USER
LIBRARY_PATH::String = joinpath(@__DIR__,"..","shared_memory.dll")
# END


"""
Used to show the proper error based on the value.
Error values reflect values written in Rust library.
# Parameters
- `error_code::Int64`: value of the error. Should be negative.
"""
struct SharedMemoryLibraryError <: Exception
    error_code::Int64
end


"""
Add customize formatting for the SharedMemoryLibraryError error when it's raised.
"""
function Base.showerror(io::IO, e::SharedMemoryLibraryError)
    error_code::Int64 = e.error_code

    if error_code === -1
        print("Library path is not set")
    elseif error_code === -2
        print("Error in accessing shared file (probably file does not exist)")
    elseif error_code === -3
        print("Can't read library_path from memory")
    elseif error_code === -4
        print("Can't create shared memory")
    elseif error_code === -5
        print("New Rank doesn't match the previous rank")
    else
        throw(ArgumentError("Invalid error code is given: $(error_code)"))
    end

end


"""
This function is used to check the return type of all the external functions calls.

# Arguments
- `value::Union{Cint,Clonglong}`: If value is negative, it's error otherwise should be return.

## Return
    If value is negative, an exception is raised, otherwise the value will be returned.
"""
function check_library_error(value::Union{Cint,Clonglong})::Union{Cint,Clonglong}
    if value >= 0
        return value
    else
        throw(SharedMemoryLibraryError(value))
    end
end


"""
Set the shared memory path. Will raise SharedMemoryLibraryError if the operation was no successful.

# Arguments
- `path::String`: A valid path used to access the shared memory. Will be encoded as UTF-8 before calling the function.

## Return
    An int is returned.
"""
function set_shared_memory_path(path::String)::Nothing
    check_library_error(ccall((:set_shared_memory_path,LIBRARY_PATH), Cint, (Cstring,), path))
    nothing
end


"""
Flatten length is the product of dimensions. Will raise SharedMemoryLibraryError if the operation was no successful.

## Return
    Returns the shared memory flatten data length as Int64.
"""
function get_shared_memory_flatten_length()::Int64
    return check_library_error(ccall((:get_shared_memory_flatten_length,LIBRARY_PATH), Clonglong, ()))
end


"""
Will raise SharedMemoryLibraryError if the operation was no successful.

## Return
    Return the shared memory data type that is either numeric data type or String.
"""
function get_shared_memory_data_type()::DataType
    temp::Cint = check_library_error(ccall((:get_shared_memory_data_type,LIBRARY_PATH), Cint, ()));
    return [UInt8,UInt16,UInt32,UInt64,Int8,Int16,Int32,Int64,Float32,Float64,ComplexF32,ComplexF64,String][temp+1]
end


"""
Will raise SharedMemoryLibraryError if the operation was no successful.

## Return
    Return the shared memory data rank.
"""
function get_shared_memory_rank()::Int32
    return check_library_error(ccall((:get_shared_memory_rank,LIBRARY_PATH), Cint, ()))
end


"""
Get the shared memory dimension. Will raise SharedMemoryLibraryError if the operation was no successful.

## Return
    The dimension of store data in shared memory.
"""
function get_shared_memory_dimensions()::Vector{UInt64}
    dims::Vector{UInt64} = Vector{UInt64}(undef,get_shared_memory_rank())
    
    check_library_error(ccall((:get_shared_memory_dimensions,LIBRARY_PATH), Cint, (Ptr{UInt64},),dims))
    
    return dims
end


"""
Will raise SharedMemoryLibraryError if the operation was no successful.

## Return
    Return the shared memory flatten data. Output type is either a Numpy array or a string.
"""
function get_shared_memory_flatten_data()::Union{Vector,String}

    shared_memory_type::DataType = get_shared_memory_data_type();
    shared_memory_flatten_length::Int64 = get_shared_memory_flatten_length();

    if shared_memory_type === UInt8
        data = Vector{UInt8}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_unsigned_8, LIBRARY_PATH), Cint, (Ptr{UInt8},), data))

    elseif shared_memory_type === UInt16
        data = Vector{UInt16}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_unsigned_16, LIBRARY_PATH), Cint, (Ptr{UInt16},), data))

    elseif shared_memory_type === UInt32
        data = Vector{UInt32}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_unsigned_32, LIBRARY_PATH), Cint, (Ptr{UInt32},), data))

    elseif shared_memory_type === UInt64
        data = Vector{UInt64}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_unsigned_64, LIBRARY_PATH), Cint, (Ptr{UInt64},), data))

    elseif shared_memory_type === Int8
        data = Vector{Int8}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_signed_8, LIBRARY_PATH), Cint, (Ptr{Int8},), data))

    elseif shared_memory_type === Int16
        data = Vector{Int16}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_signed_16, LIBRARY_PATH), Cint, (Ptr{Int16},), data))

    elseif shared_memory_type === Int32
        data = Vector{Int32}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_signed_32, LIBRARY_PATH), Cint, (Ptr{Int32},), data))

    elseif shared_memory_type === Int64
        data = Vector{Int64}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_signed_64, LIBRARY_PATH), Cint, (Ptr{Int64},), data))

    elseif shared_memory_type === Float32
        data = Vector{Float32}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_float32, LIBRARY_PATH), Cint, (Ptr{Float32},), data))

    elseif shared_memory_type === Float64
        data = Vector{Float64}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_float64, LIBRARY_PATH), Cint, (Ptr{Float64},), data))

    elseif shared_memory_type === ComplexF32
        data = Vector{ComplexF32}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_float32, LIBRARY_PATH), Cint, (Ptr{Float32},), data))

    elseif shared_memory_type === ComplexF64
        data = Vector{ComplexF64}(undef,shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_flatten_data_float64, LIBRARY_PATH), Cint, (Ptr{Float64},), data))

    elseif shared_memory_type === String
        # data::String
        data = repeat(" ", shared_memory_flatten_length)
        check_library_error(ccall((:get_shared_memory_string, LIBRARY_PATH), Cint, (Cstring,), data))
    end

    return data
end


"""
Will raise SharedMemoryLibraryError if the operation was no successful.

## Return
    Either string or the data store in the shared memory in row-major layout.
"""
function get_shared_memory_data()::Union{Array,String}
    type::DataType = get_shared_memory_data_type()
    data::Union{Vector,String} = get_shared_memory_flatten_data()

    if type === String
        return data
    end
    
    size::Vector{UInt64} = get_shared_memory_dimensions()

    return reshape(data, Tuple(size))
end


"""
Will raise SharedMemoryLibraryError if the operation was no successful.

# Arguments
- `data::String`: data to be stored in shared memory.
"""
function set_shared_memory_data(data::String)::Nothing
    check_library_error(ccall((:set_shared_memory_string,LIBRARY_PATH), Cint, (Cstring,),data))
    nothing
end


"""
Array with float16 type will be converted to float32.
Will raise SharedMemoryLibraryError if the operation was no successful.

# Arguments
- `data::Array`: data to be stored in shared memory. It can be in any dimension with supported types.
"""
function set_shared_memory_data(data::Array)::Nothing
    temp_dims::Vector{UInt64} = convert(Vector{UInt64},collect(size(data)))
    temp_rank::Int = length(temp_dims)
    data_type::DataType = eltype(data)

    if data_type === UInt8
        check_library_error(ccall((:set_shared_memory_data_unsigned_8, LIBRARY_PATH), Cint
                            , (Ptr{UInt8},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === UInt16
        check_library_error(ccall((:set_shared_memory_data_unsigned_16, LIBRARY_PATH), Cint
                            , (Ptr{UInt16},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === UInt32
        check_library_error(ccall((:set_shared_memory_data_unsigned_32, LIBRARY_PATH), Cint
                            , (Ptr{UInt32},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === UInt64
        check_library_error(ccall((:set_shared_memory_data_unsigned_64, LIBRARY_PATH), Cint
                            , (Ptr{UInt64},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === Int8
        check_library_error(ccall((:set_shared_memory_data_signed_8, LIBRARY_PATH), Cint
                            , (Ptr{Int8},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === Int16
        check_library_error(ccall((:set_shared_memory_data_signed_16, LIBRARY_PATH), Cint
                            , (Ptr{Int16},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === Int32
        check_library_error(ccall((:set_shared_memory_data_signed_32, LIBRARY_PATH), Cint
                            , (Ptr{Int32},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === Int64
        check_library_error(ccall((:set_shared_memory_data_signed_64, LIBRARY_PATH), Cint
                            , (Ptr{Int64},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === Float32
        check_library_error(ccall((:set_shared_memory_data_float32, LIBRARY_PATH), Cint
                            , (Ptr{Float32},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === Float64
        check_library_error(ccall((:set_shared_memory_data_float64, LIBRARY_PATH), Cint
                            , (Ptr{Float64},Ptr{UInt64},UInt64)
                            , data,temp_dims,temp_rank))

    elseif data_type === ComplexF32
        check_library_error(ccall((:set_shared_memory_data_complex_float32, LIBRARY_PATH), Cint, (Ptr{Float32},Ptr{UInt64},UInt64), data,temp_dims,temp_rank));

    elseif data_type === ComplexF64
        check_library_error(ccall((:set_shared_memory_data_complex_float64, LIBRARY_PATH), Cint, (Ptr{Float64},Ptr{UInt64},UInt64), data,temp_dims,temp_rank));

    # Convert float16 array to float32 array
    elseif data_type === Float16
        println("Float16 is not supported. Automatically converted to Float32");
        set_shared_memory_data(convert(Array{Float32},data));
    
    # Raise error if type is not supported
    else
        throw(ArgumentError("DataType "*string(data_type)*" is not supported."));
    end
    nothing 
end


"""
Unload the data from memory if it can connect to it, otherwise will remove the specified file.

Will raise SharedMemoryLibraryError if the operation was no successful.
"""
function delete_shared_memory()::Nothing
    check_library_error(ccall((:delete_shared_memory, LIBRARY_PATH), Cint, ()))
    nothing
end

end
