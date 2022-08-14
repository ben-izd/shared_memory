# Shared Memory - 🚧 Under construction


![poster](https://user-images.githubusercontent.com/56647066/184504837-42af271b-85a1-48a3-b30e-3f725012c919.jpg)

Easily and efficiently share rectangular double-typed data (any dimension) between [Python](https://python.org) - [Julia](https://julialang.org) - [Matlab](https://mathworks.com) - [Wolfram Language (Mathematica)](https://www.wolfram.com/mathematica/) using shared memory. Each language somehow implements sharing data either for its subkernel or same processes but now you can share between them at a fast speed. It's backed by a library written in [Rust](https://rust-lang.org/).

To make your life and mine easier, all the function names are the same (snake_case) except Mathematica which does not support underline and is CamelCase. All of the them have simple logic `action_shared_memory[_property]`, like `get_shared_memory_flatten_length` and have the same functionality.

## Initializations


### Matlab
[`matlab`](https://github.com/ben-izd/shared_memory/tree/main/matlab) folder contain all functions as seperate files, just include the path with [`addpath`](https://uk.mathworks.com/help/matlab/ref/addpath.html) or other solutions to be able to use the functions. Before using any function, you have to first set the [`LIBRARY_PATH_DIRECTORY` in `load_library.m` file](https://github.com/ben-izd/shared_memory/blob/9b97dab3bbc81c122d4c966cee5ce1bf7733cf90/matlab/load_library.m#L3), so it load the library (in windows is `.dll` file).

Now use `set_shared_memory_path` function to set your shared_memory_file, a file use by other program to access the data you'll share or receive.

### Mathematica
Before loading the package, first you have to set `SharedMemory\`libraryPath` to the library_path (in windows is `.dll` file). Then, use [`Get`](https://reference.wolfram.com/language/ref/Get.html) or other functions to load the package.

### Julia
Open [`julia.jl` file](https://github.com/ben-izd/shared_memory/blob/a6dfdc00f4008959facd3b25b5e4320ada532214/julia/julia.jl#L2) and set `LIBRARY_PATH` to the shared library (in windows is `.dll` file).

### Python
Open [`python.py` file](https://github.com/ben-izd/shared_memory/blob/3ba51ce3fa9eae2c57cacb268b686616d222fd7d/python/python.py#L6) and set `LIBRARY_PATH` to the shared library (in windows is `.dll` file).


## How to use it


### Limitations
As of now, library supports:
- Only rectangular double-type arrays
- Setting a different dimension, should match the previous rank (if you want reshape the data and send it manuanly)


### Advance features

## Notes for non-Windows users
The project was built on windows and the `dll` files is included in the repository, but if you're on other operating systems, you have to build the rust project on your platform which thanks to Rust cargo, is suprisingly easy.

### How to build the Rust
1. Install Rust on your computer
2. Make sure you have a internet connection and build the Rust project (rust folder) - You can read [Building for Release](https://doc.rust-lang.org/book/ch01-03-hello-cargo.html#building-for-release) section.
3. Go inside target/release, use the built library.

#### Note
If you don't have Mathematica, you should comment the [`mathematica` module](https://github.com/ben-izd/shared_memory/blob/9b97dab3bbc81c122d4c966cee5ce1bf7733cf90/rust/src/lib.rs#L359) in [`lib.rs`](https://github.com/ben-izd/shared_memory/blob/main/rust/src/lib.rs) and also comment `wolfram-library-link = "0.2.5"` in [`cargo.toml`](https://github.com/ben-izd/shared_memory/blob/main/rust/Cargo.toml) file

