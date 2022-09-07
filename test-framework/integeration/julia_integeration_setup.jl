include(joinpath(@__DIR__,"..","..","julia","shared_memory.jl"))
using .shared_memory

counter_path = joinpath(@__DIR__,"integeration_test_counter")

# default
number_of_software = 4
try
    if length(ARGS) > 0
        global number_of_software = parse(Int64,ARGS[1])
        println("number_of_software="*string(number_of_software)*";")
    end
catch

end

set_shared_memory_path(counter_path)
set_shared_memory_data([number_of_software])


