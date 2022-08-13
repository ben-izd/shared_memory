int set_shared_memory_data(double const *data,unsigned long long const *dims ,unsigned long long rank);
int delete_shared_memory();
int get_shared_memory_flatten_data(double *array_source);
long long get_shared_memory_flatten_length();
int set_shared_memory_path(unsigned char const *path);
int get_shared_memory_dimensions(unsigned long long *array);
int get_shared_memory_rank();