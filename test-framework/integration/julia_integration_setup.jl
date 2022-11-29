"""
This script is written to reset the integration test

Author: Benyamin Izadpanah
Copyright: Benyamin Izadpanah
Github Repository: https://github.com/ben-izd/shared_memory
Start Date: 2022-8
Last date modified: 2022-11
Version used for testing: Julia 1.8.3

Requirement:
    - Make sure run this file in ".\\test-framework\\integration" directory (depends on @__DIR__)

Options:
    - First command-line argument can be used to specify number of particpant in the integration test (default is 5)
"""

include(joinpath(@__DIR__,"..","..","julia","shared_memory.jl"))
using .shared_memory

counter_path = joinpath(@__DIR__,"integration_test_counter")

# default
number_of_software = 5

try
    if length(ARGS) > 0
        global number_of_software = parse(Int64, ARGS[1])
        println("number_of_software=" * string(number_of_software) * ";")
    end
catch

end

set_shared_memory_path(counter_path)

set_shared_memory_data([number_of_software])


