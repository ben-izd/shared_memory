"""
This script is written to test the integration of interface of SharedMemory library written for Julia with other interfaces

Author: Benyamin Izadpanah
Copyright: Benyamin Izadpanah
Github Repository: https://github.com/ben-izd/shared_memory
Start Date: 2022-8
Last date modified: 2022-11
Version used for testing: Julia 1.8.3

Requirement:
    - Make sure run this file in ".\\test-framework\\interface" directory (depends on @__DIR__)
"""

using Logging
using Test

include(joinpath(@__DIR__, "..", "..", "julia", "shared_memory.jl"))
using .shared_memory

data_path = joinpath(@__DIR__, "integration_test_data")
counter_path = joinpath(@__DIR__, "integration_test_counter")


# default
number_of_software = 5
try
    if length(ARGS) > 0
        global number_of_software = parse(Int64,ARGS[1])
        println("number_of_software = "*string(number_of_software)*";")
    end
catch

end

JULIA_TYPES= [UInt8, UInt16, UInt32,UInt64,Int8, Int16, Int32,Int64,Float32,Float64,ComplexF32,ComplexF64]
datasets = []
dataset_1 = [32 46 76 12 42][:]
dataset_2 = [[5 9 12];[43 21 36]]
dataset_3 = [[[60 68 44 31];[109 26 25 124]];;;[[88 18 48 39];[52 25 87 37]];;;[[14 67 98 125];[80 16 22 20]]]

# convert our sample dataset to all the possible formats
for dataset = (dataset_1,dataset_2,dataset_3)
    for type = JULIA_TYPES
        push!(datasets,convert(Array{type}, dataset))
    end
end

# function log_my_message(text::String)
#     open(joinpath(@__DIR__,"log.txt"), "a") do io
#         write(io, text*"\n")
#     end;
# end

function get_counter()
    set_shared_memory_path(counter_path)
    get_shared_memory_data()[1]
end

function increment_counter()
    set_shared_memory_path(counter_path)
    temp=get_shared_memory_data()[1]
    set_shared_memory_data([temp+1])
    # log_my_message("[JULIA] "*string(temp)*"++")
    println("->"*string(temp+1))
end

function share_data(data)
    set_shared_memory_path(data_path)
    set_shared_memory_data(data)
    # log_my_message("[JULIA][SHARE] Dimensions: "*string(size(data))*" - Type: "*string(typeof(data))*" - Data: "*array_to_string(data))
end

function reshare(index)
    set_shared_memory_path(data_path)
    actual_dataset = get_shared_memory_data()
    expected_dataset = datasets[index]
    # log_my_message("[JULIA] - " * string(expected_dataset==actual_dataset) * " - Expected: " * array_to_string(expected_dataset) * " Actual: " * array_to_string(actual_dataset))
    
    # Type equality
    @test eltype(expected_dataset) == eltype(actual_dataset)

    @test expected_dataset == actual_dataset
    
    set_shared_memory_data(actual_dataset)
    # log_my_message("[JULIA][RE-SHARE] Dimensions: "*string(size(actual_dataset))*" - Type: "*string(typeof(actual_dataset))*" - Data: "*array_to_string(actual_dataset))
end

function array_to_string(data::Array)
    if eltype(data) == ComplexF32 || eltype(data) == ComplexF64
        return string(data);
    else
        return string(Int.(data));
    end
end

@testset "test" begin
    global counter=get_counter()
    
    # offset = counter-number_of_software
    offset = counter % number_of_software
    println("offset " * string(offset))
    
    # as long as you can upload data - keep running
    while counter <= (36 * number_of_software) + 1 
        # starting point - this script will set data

        # is my turn
        if (counter - offset) % number_of_software == 0
            index = Int64(floor((counter - offset) / number_of_software));

            if offset != 0
                reshare(index)

            else # chain point - this script will just echo what it received
                
                # if it's not the first data - check it with what it should be
                if index > 1 && index <= (length(datasets)+1)
                    set_shared_memory_path(data_path);
                    actual_dataset = get_shared_memory_data();
                    expected_dataset = datasets[index-1];
                    # log_my_message("[JULIA][CHECK] " * string(expected_dataset==actual_dataset) * " - Expected: " * array_to_string(expected_dataset) * " - Actual: " * array_to_string(actual_dataset))

                    # Type equality
                    @test eltype(expected_dataset) == eltype(actual_dataset)
                    
                    @test expected_dataset == actual_dataset

                end
                if index <= length(datasets)
                    share_data(datasets[index])
                end
            end
            increment_counter()
        end
        print(".")
        sleep(0.05)
        global counter = get_counter()
    end
end