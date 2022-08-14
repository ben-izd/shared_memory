# CAN BE CHANGED BY USER
LIBRARY_PATH = joinpath(@__DIR__,"..","shared_memory.dll")
# END

function set_shared_memory_path(path::String)
    return ccall((:set_shared_memory_path,LIBRARY_PATH), Cvoid, (Cstring,),path)
end

function get_shared_memory_flatten_length()::Int64
    return ccall((:get_shared_memory_flatten_length,LIBRARY_PATH), Clonglong, ())
end

function get_shared_memory_rank()::UInt64
    return ccall((:get_shared_memory_rank,LIBRARY_PATH), Clonglong, ())
end

function get_shared_memory_dimensions()::Vector{UInt64}
    dims = Vector{UInt64}(undef,get_shared_memory_rank())
    
    error_code= ccall((:get_shared_memory_dimensions,LIBRARY_PATH), Cint, (Ptr{UInt64},),dims)
    if error_code != 0
        println("Error code: ",error_code)
    end
    
    dims
end

function get_shared_memory_flatten_data()::Vector{Float64}

    data = Vector{Float64}(undef, get_shared_memory_flatten_length())
    
    error_code = ccall((:get_shared_memory_flatten_data, LIBRARY_PATH), Int32, (Ptr{Float64},), data)
    
    if error_code != 0
        println("Error Code:",error_code)
    end
    return data

end

function get_shared_memory_data()
    data = get_shared_memory_flatten_data()
    size=get_shared_memory_dimensions()
    temp = reshape(data,Tuple(size))
    return temp

end

function set_shared_memory_data(data::Array)
    temp_dims = convert(Vector{UInt64},collect(size(data)))
    temp_rank = ndims(temp_dims)
    if eltype(data) != Float64
        println("Data should be type double. Converted automatically.")
        data= convert(Arrat{Float64},data)
    end

    error_code = ccall((:set_shared_memory_data, LIBRARY_PATH), Cint, (Ptr{Float64},Ptr{UInt64},UInt64), data,temp_dims,temp_rank)
    if error_code != 0
        pritnln("Error in sharing data, Code: ",error_code)
    end
end


function delete_shared_memory()
    error_code = ccall((:delete_shared_memory, LIBRARY_PATH), Cint, ())
    if error_code != 0
        println("Error in closing shared memory. Code ",error_code)
    end
end

