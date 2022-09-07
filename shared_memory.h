signed int set_shared_memory_data_unsigned_8(unsigned char const *data      ,unsigned long long const *dims ,unsigned long long rank);
signed int set_shared_memory_data_unsigned_16(unsigned short const *data    ,unsigned long long const *dims ,unsigned long long rank);
signed int set_shared_memory_data_unsigned_32(unsigned long const *data     ,unsigned long long const *dims ,unsigned long long rank);
signed int set_shared_memory_data_unsigned_64(unsigned long long const *data,unsigned long long const *dims ,unsigned long long rank);

// const
signed int set_shared_memory_data_signed_8(unsigned char const * data      ,unsigned long long const *dims ,unsigned long long rank);

signed int set_shared_memory_data_signed_16(signed short const *data    ,unsigned long long const *dims ,unsigned long long rank);
signed int set_shared_memory_data_signed_32(signed long const *data     ,unsigned long long const *dims ,unsigned long long rank);
signed int set_shared_memory_data_signed_64(signed long long const *data,unsigned long long const *dims ,unsigned long long rank);

signed int set_shared_memory_data_float32(float const *data ,unsigned long long const *dims ,unsigned long long rank);
signed int set_shared_memory_data_float64(double const *data,unsigned long long const *dims ,unsigned long long rank);

signed int set_shared_memory_data_complex_float32(float const *data ,unsigned long long const *dims ,unsigned long long rank);
signed int set_shared_memory_data_complex_float64(double const *data,unsigned long long const *dims ,unsigned long long rank);

signed int get_shared_memory_flatten_data_unsigned_8(unsigned char *array_source);
signed int get_shared_memory_flatten_data_unsigned_16(unsigned short *array_source);
signed int get_shared_memory_flatten_data_unsigned_32(unsigned long *array_source);
signed int get_shared_memory_flatten_data_unsigned_64(unsigned long long *array_source);

signed int get_shared_memory_flatten_data_signed_8(unsigned char * array_source);
signed int get_shared_memory_flatten_data_signed_16(signed short *array_source);
signed int get_shared_memory_flatten_data_signed_32(signed long *array_source);
signed int get_shared_memory_flatten_data_signed_64(signed long long *array_source);

signed int get_shared_memory_flatten_data_float32(float *array_source);
signed int get_shared_memory_flatten_data_float64(double *array_source);

signed int delete_shared_memory();
signed long long get_shared_memory_flatten_length();

// const
signed int set_shared_memory_path(char const * path);

signed int get_shared_memory_dimensions(unsigned long long *array);
signed int get_shared_memory_rank();
signed int get_shared_memory_data_type();

signed int get_shared_memory_string(char const * path);
signed int set_shared_memory_string(char * path);
