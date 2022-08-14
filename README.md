# Shared Memory - 🚧 Under construction


![poster](https://user-images.githubusercontent.com/56647066/184504837-42af271b-85a1-48a3-b30e-3f725012c919.jpg)

Easily and efficiently share rectangular double-typed data (any dimension) between [Python](https://python.org) - [Julia](https://julialang.org) - [Matlab](https://mathworks.com) - [Wolfram Language (Mathematica)](https://www.wolfram.com/mathematica/) using shared memory. Each language somehow implements sharing data either for its subkernel or same processes but now you can share between them at a fast speed. It's backed by a library written in [Rust](https://rust-lang.org/).

## File Structure

### Matlab
### Mathematica
### Julia
### Python

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
If you don't have Mathematica, you should comment the `mathematica` module in [`lib.rs`](https://github.com/ben-izd/shared_memory/blob/main/rust/src/lib.rs) and also comment `wolfram-library-link = "0.2.5"` in [`cargo.toml`](https://github.com/ben-izd/shared_memory/blob/main/rust/Cargo.toml) file

