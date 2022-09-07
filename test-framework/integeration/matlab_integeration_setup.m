
counter_path = fullfile(shared_memory_functions_directory,'test-framework','integeration','integeration_test_counter');
number_of_software = 4;
set_shared_memory_path(counter_path)
set_shared_memory_data([number_of_software])
