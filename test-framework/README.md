Testing the project is done in 2 phase:

1- 🔨 Interface (checking all the functions work properly\
2- ⚒️ Integration (checking pair of interfaces work with each other)

All the code can be executed in command-line.
Open a command-line and change the directory to the root of repository. (This is important because some code depend on the current folder and project structure)

## Interface

### Python
Execute the following code in cmd:
```
python ./test-framework/interface/python_interface_test.py
```

### Julia
Execute the following code in cmd:
```
julia ./test-framework/interface/julia_interface_test.jl
```

### Mathematica
Execute the following code in cmd:
```
wolframscript -f ./test-framework/interface/mathematica_interface_test.wls
```

### Matlab
Run the following function in Matlab:
```
matlab_interface_test()
```

### Java
Because Junit was involved in the testing, we first have to compile the java code, then run the code with junit platform. A copy of the library which test was done is included in java\libraries folder.

To compile the interface execute in cmd:
```
javac -cp "./java/libraries/junit-platform-console-standalone-1.9.1.jar;./java" "test-framework\interface\java\java_interface_test.java" --enable-preview -source 19
```

To run the test, execute in cmd:
```
java --enable-preview -jar "./java/libraries/junit-platform-console-standalone-1.9.1.jar" -cp "./test-framework/interface/java;./java" -c java_interface_test --disable-ansi-colors
```
## Integration

Generally we have two mode, One language uploads the data and other recieves it. To be more flexible, each file was implemented to be both, depending on the order of execution.

For keeping order and avoiding two interfaces manipulate the data simoutenously, two files are used:
- integration_test_data (stores the actual data)
- integration_test_counter (stores counter)

To test, 3 set of exact data in 3 dimension in supported types is embedded for each language.

The first language get executed, will share the first batch and increases the couter.When the second language get executed, it'll only retrieve the data, check it with its own datasets, re-share the exact data and increase the counter. After that the first one comes in check the existing data and share a new set and this loops repeated untill all datasets are checked.

Note:
You have to specify the number of participant, if you want to test only 2 language, provide 2 (Python, Julia, Mathematica, Java as command-line argument, Matlab as function argument). 

Default number of participant is 5, meaning you have to run 5 files in order the loop get iterated.

To start the counter or restarting it before executing a new pair, use LANGUAGE_integration_setup.FORMAT file.


### Python

To prepare the counter, execute the following code:

```
python ./test-framework/integration/python_integration_setup.py
```

You can add command-line argument to specify the number of participant. Here we say we want to test 2 language:

```
python ./test-framework/integration/python_integration_setup.py 2
```

To run the test, execute the following code:

```
python ./test-framework/integration/python_integration_test.py
```

### Julia

To prepare the counter, execute the following code:

```
julia ./test-framework/integration/julia_integration_setup.jl
```

You can add command-line argument to specify the number of participant. Here we say we want to test 2 language:

```
julia ./test-framework/integration/julia_integration_setup.jl 2
```

To run the test, execute the following code:

```
julia ./test-framework/integration/julia_integration_test.jl
```

### Mathematica

To prepare the counter, execute the following code:

```
wolframscript ./test-framework/integration/mathematica_integration_setup.wls
```

You can add command-line argument to specify the number of participant. Here we say we want to test 2 language:

```
wolframscript ./test-framework/integration/mathematica_integration_setup.wls 2
```

To run the test, execute the following code:

```
wolframscript ./test-framework/integration/mathematica_integration_test.wls
```

### Matlab

To prepare the counter, run the following function:

```matlab
matlab_integration_setup()
```

You can add optioanl argument to specify the number of participant. Here we say we want to test 2 language:

```matlab
matlab_integration_setup(2)
```

To run the test, run the following function:

```matlab
matlab_integration_test()
```

### Java

Since Java has no notion of complex values unlike other interfaces, it won't share or check the data on the complex batch. You'll get 6 failed test if you start the Java first (ComplexF32 != Float64 and ComplexF64 != Float64 are failed cases for 3 datasets (expected != actual)).

> Here we'll use Java 11 feature, executing a single Java file.


To prepare the counter, execute the following code:
```
java -cp "./java;./java/libraries/junit-platform-console-standalone-1.9.1.jar" --enable-preview --source 19 ".\test-framework\integration\java_integration_setup.java"
```

You can add command-line argument to specify the number of participant. Here we say we want to test 2 language:

```
java -cp "./java;./java/libraries/junit-platform-console-standalone-1.9.1.jar" --enable-preview --source 19 ".\test-framework\integration\java_integration_setup.java" 2
```

To run the test, execute the following code:
```
java -cp "./java;./java/libraries/junit-platform-console-standalone-1.9.1.jar" --enable-preview --source 19 ".\test-framework\integration\java_integration_test.java"
```