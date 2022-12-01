# Shared Memory

![Image poster shows multiple languages are connected using shared memory](https://user-images.githubusercontent.com/56647066/204623755-ad350362-d6db-4687-9b71-c0233efe08b6.jpg)


Easily and efficiently share rectangular (any dimension, any type) or String between [Python](https://python.org), [Julia](https://julialang.org), [Matlab](https://mathworks.com) - [Wolfram Language (Mathematica)](https://www.wolfram.com/mathematica/), [Java](https://www.java.com/) using shared memory. Each language somehow implements sharing data either for its sub-kernel or the same processes but now you can share between them at a super fast speed. It's backed by a library written in [Rust](https://rust-lang.org/).

To make your life and mine easier, all the function names are the same (snake_case) except Mathematica which does not support underline and is PascalCase and Java which is a convention to be camelCase. All of them have simple logic `action_shared_memory[_property]`, like `get_shared_memory_flatten_length` in Julia, Python and Matlab which is `GetSharedMemoryFlattenLength` in Mathematica and all have the same functionality. (Due to Java's strict type syntax, some intermediate methods was introduced)

## Simple Example
Let's suppose you have a matrix in julia and you would like to apply [`Numpy.sin`](https://numpy.org/doc/stable/reference/generated/numpy.sin.html) function on it then use Matlab [`mpower`](https://uk.mathworks.com/help/matlab/ref/mpower.html), then in Mathematica use [`Minors`](https://reference.wolfram.com/language/ref/Minors.html) and share that result with Java, how would you do it? Saving in a file? use socket?

If we ignore the Java, just reading and writing a 1000x1000 double matrix to disk on my system took around __8 seconds__ while using the shared memory it's __under 1 second (0.26)__. It not only helps you to share data, it can share it super fast, far suprior than disk or socket. Here is the steps for a small matrix with this library:

First, we assume, you've downloaded the repository in your `C:\download` directory.

1. Julia
```Julia
# Setup
include(raw"C:\download\shared_memory\julia\shared_memory.jl")
set_shared_memory_path(raw"C:\download\shared_memory\data")

# Sample Matrix
data = [1 2 3 ; 4 5 6 ; 7 8 9];

# Share
set_shared_memory_data(data) 
```

2. Python
```python
import numpy
import sys

# Setup
sys.path.append(r'C:\download\shared_memory\python')
from shared_memory import *
set_shared_memory_path(r'C:\download\shared_memory\data')

# Receive
data = get_shared_memory_data()

# Manipulate
new_data = numpy.sin(data);

# Share
set_shared_memory_data(new_data)
```
3. Matlab
```matlab
% Setup
addpath("C:\\download\\shared_memory");
addpath("C:\\download\\shared_memory\\matlab");
set_shared_memory_path("C:\\download\\shared_memory\\data")

% Receive
data = get_shared_memory_data();

% Manipulate
new_data = mpower(data,2);

% Share
set_shared_memory_data(new_data)
```
4. Mathematica (Wolfram Language)
```wolfram
(* Setup *)
SharedMemory`libraryPath = "C:\\download\\shared_memory\\shared_memory.dll";
Get["C:\\download\\shared_memory\\mathematica\\shared_memory.wl"];
SetSharedMemoryPath["C:\\download\\shared_memory\\data"];

(* Receive *)
data = GetSharedMemoryData[];

(* Manipulate *)
newData = Minors[data];

(* Share *)
SetSharedMemoryData[newData];
```

4. Java

```java
import com.github.ben_izd.shared_memory.SharedMemory;
import java.nio.file.Path;

public class Sample {
    public static void main(String[] args) {
        
        // Setup
        var libraryPath = Path.of("C:\\download\\shared_memory\\shared_memory.dll");
        try(SharedMemory sharedMemory = new SharedMemory(libraryPath)) {
            sharedMemory.setSharedMemoryPath("C:\\download\\shared_memory\\data");

            // Receive
            var data = sharedMemory.getSharedMemoryDouble2D();
        }
    }
}
```

## Advance Example

### Sharing Image
Assume you have an image inside Mathematica and you want to share it with other interfaces.

#### Mathematica
First we share our image (stored in `sampleImage` variable):
```wolfram
(* Setup *)
SharedMemory`libraryPath = "C:\\download\\shared_memory\\shared_memory.dll";
Get["C:\\download\\shared_memory\\mathematica\\shared_memory.wl"]
SetSharedMemoryPath["C:\\download\\shared_memory\\sample_image"]

(* Share *)
SetSharedMemoryData @ NumericArray @ ImageData[sampleImage, "Byte"]
```
#### Matlab
```matlab
% Setup
addpath("C:\\download\\shared_memory");
addpath("C:\\download\\shared_memory\\matlab");
set_shared_memory_path("C:\\download\\shared_memory\\sample_image");

% Receive
data = get_shared_memory_data();
image = permute(data,[3 1 2])
```

#### Python
```python
# Setup
import sys
sys.path.append(r'C:\download\shared_memory\python')
from shared_memory import *
from PIL import Image

set_shared_memory_path("C:\download\shared_memory\sample_image")

# Receive
data = get_shared_memory_data()
image = Image.fromarray(data, 'RGB')
```

#### Julia
```julia
# Setup
include(raw"C:\download\shared_memory\julia\shared_memory.jl")
using .shared_memory
import Images: colorview, RGB
set_shared_memory_path(raw"C:\download\shared_memory\sample_image")

# Receive
data = get_shared_memory_data()
image = colorview(RGB, permutedims(data, [2 3 1]) /255)
```

#### Java
```java
import com.github.ben_izd.shared_memory.SharedMemory;
import java.nio.file.Path;
import java.awt.image.BufferedImage;

public class Sample {
    public static void main(String[] args) throws Throwable {
        var libraryPath = Path.of("E:\\projects\\Mathematica\\community\\31. shared_memory\\shared_memory.dll");
        try(SharedMemory sharedMemory = new SharedMemory(libraryPath)) {
            
            sharedMemory.setSharedMemoryPath(Path.of("E:\\projects\\Mathematica\\community\\31. shared_memory\\example\\image\\imageData"));
            var data = sharedMemory.getSharedMemoryByte3D();
            var image = readImage(data);
        }
    }

    public static BufferedImage readImage(byte[][][] data) {
        int width = data[0].length;
        int height = data.length;
        BufferedImage bufferedImage = new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);
        int red,green,blue,rgb;
        for (int row = 0; row < height; row++) {
            for (int column = 0; column < width; column++) {

                red = data[row][column][0] & 0xFF;
                green = data[row][column][1] & 0xFF;
                blue = data[row][column][2] & 0xFF;
                rgb = (red << 16) | (green << 8) | blue;
                bufferedImage.setRGB(column,row,rgb);
            }
        }
        return bufferedImage;
    }
}
```


----

## Initializations

### Matlab
[`matlab`](https://github.com/ben-izd/shared_memory/tree/main/matlab) folder contains all functions as separate files, just include that folder and the root (in windows folder contains `.dll`) to path variable with [`addpath`](https://uk.mathworks.com/help/matlab/ref/addpath.html) or other methods to be able to use the functions.

Now use `set_shared_memory_path` function to set your shared memory file, a file used by other programs to access the data you'll share or want to receive.

> Advance Tip: If you want to move the shared library (in windows that `shared_memory.dll` file), also move the head file `shared_memory.h` with it.

### Mathematica
Before loading the package, first you have to set ```SharedMemory`libraryPath``` to the library path (in windows is `.dll` file). Then, use [`Get`](https://reference.wolfram.com/language/ref/Get.html) or other functions to load the package.

### Julia
Just include the `shared_memory.jl` in your code.

If you moved the `shared_memory.jl` or `shared_memory.dll` file, then open [`shared_memory.jl` file](https://github.com/ben-izd/shared_memory/blob/main/julia/shared_memory.jl) and set `LIBRARY_PATH` to the shared library (in windows is `shared_memory.dll` file).

### Python
You need [`Numpy`](https://pypi.org/project/numpy/) installed first.
Add the `python` folder to your path with `sys` module and import the file like below:
```python
import sys
sys.path.append(r'C:\download\shared_memory\python')

from shared_memory import *
```

If you moved the `shared_memory.py` or `shared_memory.dll` file, then open [`shared_memory.py` file](https://github.com/ben-izd/shared_memory/blob/main/python/shared_memory.py) and set `LIBRARY_PATH` to the shared library (in windows is `.dll` file).

### Java

Add `java` folder to you class path and give the path of shared library (in windows  `shared_memory.dll`) file to the SharedMemory constructor.

### Limitations
- Only rectangular arrays or single String
- Data stored in shared memory is column-major like Julia and Matlab but Mathematica and python (by default) are row-major, sending and receiving data from Python, Mathematica and Java will apply the necessary transformations.
- Java does not have a complex notion. Because of that, you can't share or receive complex values within Java.


## Documentation
Check all the functions and names in different interfaces in the [Wiki](https://github.com/ben-izd/shared_memory/wiki) section.


## Notes for non-Windows users
The project was built on windows and the `dll` files is included in the repository, but if you're on other operating systems, you have to build the rust project on your platform which thanks to Rust cargo, is surprisingly easy.

### How to build the Rust
1. Install Rust on your computer
2. Make sure you have an internet connection and build the Rust project (rust folder) - You can read [Building for Release](https://doc.rust-lang.org/book/ch01-03-hello-cargo.html#building-for-release) section.
3. Go inside target/release, and use the built library.

#### Note
If you don't have Mathematica, you can comment the [`mathematica` module](https://github.com/ben-izd/shared_memory/blob/main/rust/src/lib.rs#L359) in [`lib.rs`](https://github.com/ben-izd/shared_memory/blob/main/rust/src/lib.rs) and also comment `wolfram-library-link = ...` in [`cargo.toml`](https://github.com/ben-izd/shared_memory/blob/main/rust/Cargo.toml) file

