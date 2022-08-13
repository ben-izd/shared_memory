// Because of the nature of the program, testing should be done on a single thread (rust default is multi-threaded)
// Use  "cargo test -- --test-threads=1" to run the test

extern crate core;

#[cfg(test)]
mod test {

    use std::os::raw::{c_ulonglong,c_longlong,c_int};
    use crate::general::*;
    use crate::*;

    // Scenario 1|2 include:
    // setting a path
    // sharing an array
    // retrieving array's flatten length, rank, dimension
    // comparing the shared memory_data with the original data

    // scenario 3 is like the 1|2 but include some repetition to discover hiccups

    // This scenario should be run first to set the path for the future uses.
    #[test]
    fn scenario_1_length_3_with_setup() {
        let path: String = r"D:\projects\Mathematica\community\31. shared_memory\data".to_string();
        internal_set_shared_memory_path(path);
        complete_test_scenario::<1,3>(&[11., 22., 33.],&[3]);
    }

    #[test]
    fn scenario_2_length_11() {
        let data = [11., 22., 33., 44., 55., 66., 77., 88., 99., 100., 110.];
        complete_test_scenario::<1,11>(&data,&[11]);
    }

    #[test]
    fn scenario_3_length_4_repeated() {
        const DATA: [ArrayType; 6] = [11., 22., 33., 44.,55.,66.];
        const DATA_LENGTH: usize = DATA.len();
        const DIMS:[u64;2]=[2,3];

        let error_code1_1 = set_shared_memory_data(DATA.as_ptr(), DIMS.as_ptr(), 2);
        let error_code1_2 = set_shared_memory_data(DATA.as_ptr(), DIMS.as_ptr(), 2);
        let error_code1_3 = set_shared_memory_data(DATA.as_ptr(), DIMS.as_ptr(), 2);
        if error_code1_1 == 0 && error_code1_2 == 0 && error_code1_3 == 0 {
            assert_eq!(get_shared_memory_rank(), 2);
            assert_eq!(get_shared_memory_rank(), 2);
            assert_eq!(get_shared_memory_rank(), 2);

            assert_eq!(get_shared_memory_flatten_length(), 6);
            assert_eq!(get_shared_memory_flatten_length(), 6);
            assert_eq!(get_shared_memory_flatten_length(), 6);

            {
                let temp_dim = [0; 2];
                get_shared_memory_dimensions(temp_dim.as_ptr() as *mut u64);
                assert_eq!(temp_dim, DIMS);
            }

            {
                let temp_dim = [0; 2];
                get_shared_memory_dimensions(temp_dim.as_ptr() as *mut u64);
                assert_eq!(temp_dim, DIMS);
            }

            {
                let temp_dim = [0; 2];
                get_shared_memory_dimensions(temp_dim.as_ptr() as *mut u64);
                assert_eq!(temp_dim, DIMS);
            }

            {// change dimension
                let new_dim = [3,2];
                let error_code3 = set_shared_memory_dimensions(new_dim.as_ptr());
                if error_code3 != 0 {
                    panic!("ERROR in changin dimensions");
                }
            }

            {
                let temp_dim:[u64;2] = [0; 2];
                get_shared_memory_dimensions(temp_dim.as_ptr() as *mut u64);
                assert_eq!(temp_dim, [3u64, 2u64]);
            }

            assert_eq!(get_shared_memory_rank(), 2);

            assert_eq!(get_shared_memory_flatten_length(), 6);

            let mut temp = [0.0; DATA_LENGTH];
            let error_code2_1 = get_shared_memory_flatten_data(temp.as_mut_ptr());
            let error_code2_2 = get_shared_memory_flatten_data(temp.as_mut_ptr());
            let error_code2_3 = get_shared_memory_flatten_data(temp.as_mut_ptr());
            if error_code2_1 == 0 && error_code2_2 == 0 && error_code2_3 == 0 {
                assert_eq!(temp, DATA);
            } else {
                panic!("ERROR in retrieving the data, {:?} ", (error_code2_1,error_code2_2,error_code2_3));
            }
        } else {
            panic!("ERROR in sharing data, {:?}",( error_code1_1, error_code1_2, error_code1_3));
        }
    }

    #[test]
    fn scenario_3_empty() {
        complete_test_scenario::<1,0>(&[],&[0]);
    }

    #[test]
    fn final_scenario(){
        delete_shared_memory();
    }

    fn complete_test_scenario<const RANK:usize,const FLATTEN_LENGTH:usize>(data:&[ArrayType], dims:&[c_ulonglong]) {
        let error_code_1 = set_shared_memory_data(data.as_ptr(), [FLATTEN_LENGTH.try_into().unwrap()].as_ptr(), RANK as c_ulonglong);
        if error_code_1 == 0 {

            assert_eq!(get_shared_memory_rank(), RANK as c_int);

            assert_eq!(get_shared_memory_flatten_length(), FLATTEN_LENGTH as c_longlong);

            let temp_dim = [0; RANK];
            get_shared_memory_dimensions(temp_dim.as_ptr() as *mut u64);
            assert_eq!(temp_dim, dims);

            let mut temp = [0.0; FLATTEN_LENGTH];
            let error_code_2 = get_shared_memory_flatten_data(temp.as_mut_ptr());
            if error_code_2 == 0 {
                assert_eq!(temp, data);
            } else {
                panic!("ERROR in retrieving the data, {} ", error_code_2);
            }
        } else {
            panic!("ERROR in sharing data, {}", error_code_1);
        }
    }
}

// TENSOR CODE WHERE TensorType should be change also
pub type ArrayType = f64;
pub type ArrayTypeRaw = std::os::raw::c_double;

// This module is the core of the library and is used
//  by Julia, Matlab and Python
mod general {
    use std::ffi::CStr;
    use std::os::raw::{c_longlong, c_int, c_char, c_ulonglong};
    use shared_memory::*;
    use crate::{ArrayType, ArrayTypeRaw};
    use std::ptr::copy_nonoverlapping;
    // Possible errors - all are negative
    const EMPTY_LIBRARY_PATH_ERROR_CODE: c_int = -1;
    const ACCESS_ERROR_CODE: c_int = -2;
    const PARSING_PATH_STRING_ERROR: c_int = -3;
    const CAN_NOT_CREATE_SHARED_MEMORY_ERROR:c_int=-4;
    const NEW_RANK_DOES_NOT_MATCH_PREVIOUS_RANK_ERROR:c_int=-5;

    // GLOBAL VARIABLE
    // Used to store the shared memory path
    pub static mut SHARED_MEMORY_FILE_PATH: Option<String> = None;

    pub fn internal_get_shared_memory_path<'a>() -> Result<&'a String, c_int> {
        match unsafe { &SHARED_MEMORY_FILE_PATH } {
            Some(ref v) => {
                Ok(v)
            }
            None => Err(EMPTY_LIBRARY_PATH_ERROR_CODE)
        }
    }

    // read the data rank - should provide a shared_memory
    pub fn internal_get_shared_memory_rank_raw(shared_memory: &Shmem) -> usize {
        unsafe { (*(shared_memory.as_ptr() as *const u64)) as usize }
    }

    // read the data rank - optional - (can be used with None)
    pub fn internal_get_shared_memory_rank(shared_memory: Option<&Shmem>) -> Result<usize, c_int> {
        // internal_get_shared_memory_rank_raw(shared_memory.unwrap_or(&(internal_open_shared_memory()?)))
        match shared_memory {
            Some(v) => Ok(internal_get_shared_memory_rank_raw(v)),

            // None will call the function again with a new created shared memory
            None => internal_get_shared_memory_rank(Some(&(internal_open_shared_memory()?)))
        }
    }

    // Try to access the shared memory
    pub fn internal_open_shared_memory() -> Result<Shmem, c_int> {
        let path = internal_get_shared_memory_path()?;
        ShmemConf::new().flink(path).open().map_err(|_| ACCESS_ERROR_CODE)
    }

    // read data dimensions
    pub fn internal_get_shared_memory_dimensions_raw(shared_memory: &Shmem) -> &[u64] {
        let len = internal_get_shared_memory_rank_raw(shared_memory);
        unsafe { std::slice::from_raw_parts(shared_memory.as_ptr().offset(8) as *const u64, len) }
    }

    // read data dimensions - optional
    pub fn internal_get_shared_memory_flatten_length(shared_memory: &Shmem) -> usize {
        internal_get_shared_memory_dimensions_raw(shared_memory).iter().product::<u64>() as usize
    }

    // Set the shared memory path so other functions can work seamlessly
    pub fn internal_set_shared_memory_path(path: String) {
        unsafe { SHARED_MEMORY_FILE_PATH = Some(path) }
    }

    // new dimension should match with previous rank
    #[no_mangle]
    pub extern "C" fn set_shared_memory_dimensions(new_dimensions_raw:*const c_ulonglong) -> c_int {
        let shared_memory =match internal_open_shared_memory() {
            Ok(v) => v,
            Err(e) => {return e}
        };
        let shared_memory_address = shared_memory.as_ptr();
        let current_rank = internal_get_shared_memory_rank_raw(&shared_memory);

        let new_dimensions = unsafe { std::slice::from_raw_parts(new_dimensions_raw,current_rank)};
        let new_flatten_length = new_dimensions.iter().product::<u64>() as usize;
        if new_flatten_length == internal_get_shared_memory_flatten_length(&shared_memory) {
            unsafe {
                copy_nonoverlapping::<u64>(new_dimensions_raw as *const u64, shared_memory_address.offset(8) as *mut u64,current_rank);
            }
            0
        }else{
            NEW_RANK_DOES_NOT_MATCH_PREVIOUS_RANK_ERROR
        }
    }

    #[no_mangle]
    pub extern "C" fn get_shared_memory_rank() -> c_int {
        match internal_get_shared_memory_rank(None) {
            Ok(v) => v as c_int,
            Err(e) => e
        }
    }

    #[no_mangle]
    pub extern "C" fn get_shared_memory_dimensions(array: *mut c_ulonglong) -> c_int {
        let shared_memory = match internal_open_shared_memory() {
            Ok(v) => v,
            Err(e) => { return e; }
        };
        let dims = internal_get_shared_memory_dimensions_raw(&shared_memory);
        unsafe { copy_nonoverlapping::<u64>(dims.as_ptr() as *const u64, array, dims.len()); }
        0
    }

    #[no_mangle]
    pub extern "C" fn set_shared_memory_path(path: *const c_char) -> c_int {
        match unsafe { CStr::from_ptr(path).to_str() } {
            Ok(v) => {
                internal_set_shared_memory_path(v.to_string());
                0
            }
            Err(_) => {
                PARSING_PATH_STRING_ERROR
            }
        }
    }

    #[no_mangle]
    pub extern "C" fn get_shared_memory_flatten_length() -> c_longlong {
        match internal_open_shared_memory() {
            Ok(ref v) => internal_get_shared_memory_flatten_length(v) as c_longlong,
            Err(e) => {
                e as c_longlong
            }
        }
    }


    #[no_mangle]
    pub extern "C" fn get_shared_memory_flatten_data(array_source: *mut ArrayTypeRaw) -> c_int {
        match internal_open_shared_memory() {
            Ok(ref shared_memory) => {
                let dims = internal_get_shared_memory_dimensions_raw(shared_memory);
                let rank = dims.len();
                let data_flatten_length = dims.iter().product::<u64>() as usize;
                if data_flatten_length > 0 {
                    unsafe { copy_nonoverlapping::<f64>((shared_memory.as_ptr().offset((rank as isize + 1) * 8)) as *const ArrayType, array_source, data_flatten_length); }
                }
                0
            }
            Err(e) => e
        }
    }


    #[no_mangle]
    pub extern "C" fn delete_shared_memory() -> c_int {
        let path = match internal_get_shared_memory_path() {
            Ok(v) => v,
            Err(e) => { return e; }
        };
        let mut shared_memory = match internal_open_shared_memory() {
            Ok(m) => m,
            Err(e) => {
                return e;
            }
        };

        // make this the owner
        shared_memory.set_owner(true);

        // remove the file shared memory used
        let _ = std::fs::remove_file(path);
        0
    }


    #[no_mangle]
    pub extern "C" fn set_shared_memory_data(
        data: *const ArrayTypeRaw,
        dims_raw: *const c_ulonglong,
        rank: c_ulonglong,
    ) -> c_int {
        let path = match internal_get_shared_memory_path() {
            Ok(v) => v,
            Err(e) => { return e; }
        };

        delete_shared_memory();

        let rank_usize = rank as usize;
        let dims = unsafe { std::slice::from_raw_parts(dims_raw, rank_usize) };

        let data_flatten_length = dims.iter().product::<u64>() as usize;

        // .force_create_flink()
        // create the shared memory - size is the 8*flatten_length assuming a f64 is given
        let mut shared_memory = match ShmemConf::new().size(data_flatten_length * 8 + (rank_usize + 1) * 8).flink(path).create() {
            Ok(m) => m,
            Err(_) => {
                return CAN_NOT_CREATE_SHARED_MEMORY_ERROR;
            }
        };

        let shared_memory_address = shared_memory.as_ptr();
        unsafe {
            // first - write the rank
            *(shared_memory_address as *mut u64) = rank as u64;

            // second - write the dimensions
            copy_nonoverlapping::<u64>(dims_raw as *const u64, shared_memory_address.offset(8) as *mut u64, rank_usize);

            // third - dump the data from Mathematica to shared memory (probably volatile is a better choice)
            copy_nonoverlapping::<ArrayType>(data, shared_memory_address.offset((rank_usize as isize + 1) * 8) as *mut ArrayType, data_flatten_length);
        }

        // remove the ownership, will be used in delete_shared_memory
        shared_memory.set_owner(false);
        0
    }
}

// This module is for Wolfram Language (Mathematica)
// If you don't have or won't use it, comment this section + it's dependency in Cargo.toml (wolfram-library-link)
mod mathematica {
    use wolfram_library_link::sys::{WolframLibraryData, mint, MArgument, MType_Real, MTensor, MType_Integer};
    use crate::general::{delete_shared_memory, set_shared_memory_data, get_shared_memory_flatten_data, internal_set_shared_memory_path, get_shared_memory_rank, internal_get_shared_memory_flatten_length, internal_open_shared_memory, internal_get_shared_memory_dimensions_raw, set_shared_memory_dimensions};
    use std::os::raw::{c_int, c_ulonglong};
    use std::ptr::copy_nonoverlapping;

    pub const TENSOR_TYPE: u32 = MType_Real;

    use wolfram_library_link as wll;


    #[wll::export]
    fn set_shared_memory_path_mathematica(new_path: String) {
        internal_set_shared_memory_path(new_path)
    }

    #[wll::export]
    fn get_shared_memory_rank_mathematica() -> i64 {
        get_shared_memory_rank() as i64
    }


    #[no_mangle]
    pub unsafe extern "C" fn get_shared_memory_flatten_length_mathematica(
        _lib_data: WolframLibraryData,
        _arg_count: mint,
        _args: *mut MArgument,
        res: MArgument,
    ) -> c_int {
        let shared_memory = match internal_open_shared_memory() {
            Ok(v) => v,
            Err(e) => { return e; }
        };
        *res.integer = internal_get_shared_memory_flatten_length(&shared_memory) as mint;
        0
    }

    #[no_mangle]
    pub unsafe extern "C" fn set_shared_memory_dimensions_mathematica(
        lib_data: WolframLibraryData,
        _arg_count: mint,
        args: *mut MArgument,
        _res: MArgument,
    ) -> c_int {
        let new_dimensions_tensor = *((*args).tensor);

        // tensor data pointer
        let new_dimensions_raw = (*lib_data).MTensor_getIntegerData.unwrap()(new_dimensions_tensor);

        let new_dimensions_rank = (*lib_data).MTensor_getFlattenedLength.unwrap()(new_dimensions_tensor) as usize;
        let new_dimension = std::slice::from_raw_parts(new_dimensions_raw, new_dimensions_rank).iter().map(|x: &mint| *x as u64).collect::<Vec<u64>>();

        set_shared_memory_dimensions(new_dimension.as_ptr() as *const c_ulonglong)
    }

    #[no_mangle]
    pub unsafe extern "C" fn get_shared_memory_dimensions_mathematica(
        lib_data: WolframLibraryData,
        _arg_count: mint,
        _args: *mut MArgument,
        res: MArgument,
    ) -> c_int {
        let mut output: MTensor = std::ptr::null_mut();

        match internal_open_shared_memory() {
            Ok(ref v) => {
                let dims = internal_get_shared_memory_dimensions_raw(v);

                let error_code = ((*lib_data).MTensor_new.unwrap())(MType_Integer.into(), 1, [dims.len()].as_ptr() as *const mint, &mut output as *mut MTensor);
                if error_code == 0 {
                    copy_nonoverlapping::<i64>(dims.as_ptr() as *const i64, ((*lib_data).MTensor_getIntegerData.unwrap())(output), dims.len());
                    *res.tensor = output
                }
                error_code
            }
            Err(e) => e
        }
    }

    #[no_mangle]
    pub unsafe extern "C" fn get_shared_memory_flatten_data_mathematica(
        lib_data: WolframLibraryData,
        _arg_count: mint,
        _args: *mut MArgument,
        res: MArgument,
    ) -> c_int {
        let mut output: MTensor = std::ptr::null_mut();

        {
            let data_flatten_length = match internal_open_shared_memory() {
                Ok(v) => internal_get_shared_memory_flatten_length(&v),
                Err(e) => { return e; }
            };

            ((*lib_data).MTensor_new.unwrap())(TENSOR_TYPE.into(), 1, [data_flatten_length as mint].as_ptr(), &mut output as *mut MTensor);
        }
        let error_code= get_shared_memory_flatten_data(((*lib_data).MTensor_getRealData.unwrap())(output));
        if error_code == 0 {
            *res.tensor = output;
        }

        error_code
    }

    #[no_mangle]
    pub unsafe extern "C" fn delete_shared_memory_mathematica(
        _lib_data: WolframLibraryData,
        _arg_count: mint,
        _args: *mut MArgument,
        _res: MArgument,
    ) -> c_int {
        delete_shared_memory()
    }

    #[no_mangle]
    pub unsafe extern "C" fn set_shared_memory_data_mathematica(
        lib_data: WolframLibraryData,
        _arg_count: mint,
        args: *mut MArgument,
        _res: MArgument,
    ) -> c_int {

        // get the tensor (assuming f64|Real64)
        let data = *((*args).tensor);

        // tensor data pointer
        let data_raw = (*lib_data).MTensor_getRealData.unwrap()(data);

        let data_dims_raw = (*lib_data).MTensor_getDimensions.unwrap()(data);
        let data_rank = (*lib_data).MTensor_getRank.unwrap()(data) as usize;
        let data_dims = std::slice::from_raw_parts(data_dims_raw, data_rank).iter().map(|x: &mint| *x as u64).collect::<Vec<u64>>();

        set_shared_memory_data(data_raw, data_dims.as_ptr() as *const c_ulonglong, data_rank as c_ulonglong)
    }
}