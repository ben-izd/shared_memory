package com.github.ben_izd.shared_memory;
// import java.lang.foreign.*;
import java.lang.foreign.MemorySession;
import java.lang.foreign.ValueLayout;
import java.lang.foreign.MemorySegment;
import java.lang.foreign.MemoryAddress;
import java.lang.foreign.Linker;
import java.lang.foreign.FunctionDescriptor;
import java.lang.foreign.SymbolLookup;

import java.lang.invoke.MethodHandle;
import java.nio.file.Path;
import java.io.Closeable;
import java.util.Arrays;
import java.util.NoSuchElementException;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

/**
 * @author Benyamin Izadpanah
 * Copyright: Benyamin Izadpanah
 * Start Date: 2022-11-5 (year-month-day)
 * Last Date Modified: 2022-11-26
 * Last JDK Used: JDK 19
 * Github Repository: <a href="https://github.com/ben-izd/">Repository Link</a>
 *
 * Summary:
 * With this package you can share data with other interfaces exist in the github repository in memory.
 *
 * Requirement:
 * This class is just an interface for the shared_memory library. You'll need the shared library before using this class.
 * For obtain to the shared library and other interfaces, you can visit <a href="https://github.com/ben-izd/shared_memory">shared_memory Github</a>
 *
 * @implSpec Due to nature of Java off-heap memory management, Each instance of SharedMemory should be either close manually \
 * or with try-with-resource.
 * Other than few internally used method, no public method tolerate null values. All of them are annotated with \
 * NotNull and almost no checked was applied before use. Make sure you have a valid data before calling these methods or \
 * rely on IDE features.
 * Loops were design to get and send to in column-major format, any change in this underlying assumption, will invalidate most \
 * of the get and send methods.
 *
 * @implNote For performance reason, getting shared memory data for 2D, 3D and 4D has duplicated bodies. this can be mitigated via a switch expression
 * inside the for loops or lambda expression but would affect the performance.
 *
 * @version 1
 */
public final class SharedMemory implements Closeable {

    private final MemorySession memorySession;
    private final SymbolLookup symbolLookup;
    private boolean closed = false;
    private static final Linker cLinker = Linker.nativeLinker();
    private final MethodHandle
            // These two handles are for complex number which Java don't have built-in support, Not implemented in this interface
            // c_library_set_shared_memory_data_complex_float32,
            // c_library_set_shared_memory_data_complex_float64,
            c_library_set_shared_memory_string,
            c_library_get_shared_memory_string,
            c_library_set_shared_memory_data_float32,
            c_library_set_shared_memory_data_float64,
            c_library_set_shared_memory_data_signed_8,
            c_library_set_shared_memory_data_signed_16,
            c_library_set_shared_memory_data_signed_32,
            c_library_set_shared_memory_data_signed_64,
            c_library_set_shared_memory_data_unsigned_8,
            c_library_set_shared_memory_data_unsigned_16,
            c_library_set_shared_memory_data_unsigned_32,
            c_library_set_shared_memory_data_unsigned_64,
            c_library_get_shared_memory_flatten_data_float32,
            c_library_get_shared_memory_flatten_data_float64,
            c_library_get_shared_memory_flatten_data_signed_8,
            c_library_get_shared_memory_flatten_data_signed_16,
            c_library_get_shared_memory_flatten_data_signed_32,
            c_library_get_shared_memory_flatten_data_signed_64,
            c_library_get_shared_memory_flatten_data_unsigned_8,
            c_library_get_shared_memory_flatten_data_unsigned_16,
            c_library_get_shared_memory_flatten_data_unsigned_32,
            c_library_get_shared_memory_flatten_data_unsigned_64,
            c_library_get_shared_memory_data_type,
            c_library_delete_shared_memory,
            c_library_get_shared_memory_flatten_length,
            c_library_set_shared_memory_path,
            c_library_get_shared_memory_dimensions,
            c_library_get_shared_memory_rank, c_library_set_shared_memory_dimensions;

    /**
     * @param methodName is the name of method
     * @param functionDescriptor is the signature of the method
     *
     * @return methodHandle match the name and function descriptor
     * @throws IllegalStateException if the provided function descriptor is not supported by this linker
     * @throws NoSuchElementException if the function does not exist in the library
     * */
    @SuppressWarnings("OptionalGetWithoutIsPresent")
    private MethodHandle getRawMethodHandle(@NotNull String methodName, @NotNull FunctionDescriptor functionDescriptor) {
        return cLinker.downcallHandle(symbolLookup.lookup(methodName).get(), functionDescriptor);
    }

    /**
     * Set a SharedMemory instance. Assigning all the methodHandles by searching the library specified by libraryPath.
     *
     * @param libraryPath is the path of shared library containing all the functions
     * @throws IllegalStateException if the library does not contain the functions with the given signature
     * @throws RuntimeException if it could not find all the methodHandles
     * */
    public SharedMemory(@NotNull Path libraryPath) {
        this.memorySession = MemorySession.openConfined();
        symbolLookup = SymbolLookup.libraryLookup(libraryPath, memorySession);

        try {
            final var setDataSignature = FunctionDescriptor.of(ValueLayout.JAVA_INT
                    , ValueLayout.ADDRESS
                    , ValueLayout.ADDRESS
                    , ValueLayout.JAVA_LONG);

            this.c_library_set_shared_memory_data_unsigned_8 = getRawMethodHandle("set_shared_memory_data_unsigned_8",
                                                                                  setDataSignature);

            this.c_library_set_shared_memory_data_unsigned_16 = getRawMethodHandle("set_shared_memory_data_unsigned_16",
                                                                                   setDataSignature);

            this.c_library_set_shared_memory_data_unsigned_32 = getRawMethodHandle("set_shared_memory_data_unsigned_32",
                                                                                   setDataSignature);

            this.c_library_set_shared_memory_data_unsigned_64 = getRawMethodHandle("set_shared_memory_data_unsigned_64",
                                                                                   setDataSignature);

            this.c_library_set_shared_memory_data_signed_8 = getRawMethodHandle("set_shared_memory_data_signed_8",
                                                                                setDataSignature);

            this.c_library_set_shared_memory_data_signed_16 = getRawMethodHandle("set_shared_memory_data_signed_16",
                                                                                 setDataSignature);

            this.c_library_set_shared_memory_data_signed_32 = getRawMethodHandle("set_shared_memory_data_signed_32",
                                                                                 setDataSignature);

            this.c_library_set_shared_memory_data_signed_64 = getRawMethodHandle("set_shared_memory_data_signed_64",
                                                                                 setDataSignature);

            this.c_library_set_shared_memory_data_float32 = getRawMethodHandle("set_shared_memory_data_float32",
                                                                               setDataSignature);

            this.c_library_set_shared_memory_data_float64 = getRawMethodHandle("set_shared_memory_data_float64",
                                                                               setDataSignature);

            this.c_library_set_shared_memory_path = getRawMethodHandle("set_shared_memory_path",
                                                                       FunctionDescriptor.of(ValueLayout.JAVA_INT,
                                                                                             ValueLayout.ADDRESS));

            this.c_library_set_shared_memory_string = getRawMethodHandle("set_shared_memory_string",
                                                                         FunctionDescriptor.of(ValueLayout.JAVA_INT,
                                                                                               ValueLayout.ADDRESS));

            this.c_library_set_shared_memory_dimensions = getRawMethodHandle("set_shared_memory_dimensions",
                                                                             FunctionDescriptor.of(ValueLayout.JAVA_INT,
                                                                                                   ValueLayout.ADDRESS));

            this.c_library_get_shared_memory_dimensions = getRawMethodHandle("get_shared_memory_dimensions",
                                                                             FunctionDescriptor.of(ValueLayout.JAVA_INT,
                                                                                                   ValueLayout.ADDRESS));

            this.c_library_get_shared_memory_rank = getRawMethodHandle("get_shared_memory_rank",
                                                                       FunctionDescriptor.of(ValueLayout.JAVA_INT));

            this.c_library_get_shared_memory_data_type = getRawMethodHandle("get_shared_memory_data_type",
                                                                            FunctionDescriptor.of(
                                                                                    ValueLayout.JAVA_INT));

            this.c_library_get_shared_memory_flatten_length = getRawMethodHandle("get_shared_memory_flatten_length",
                                                                                 FunctionDescriptor.of(
                                                                                         ValueLayout.JAVA_LONG));

            this.c_library_delete_shared_memory = getRawMethodHandle("delete_shared_memory",
                                                                     FunctionDescriptor.of(ValueLayout.JAVA_INT));

            final var getFlattenSignature = FunctionDescriptor.of(ValueLayout.JAVA_INT, ValueLayout.ADDRESS);

            this.c_library_get_shared_memory_flatten_data_signed_8 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_signed_8", getFlattenSignature);

            this.c_library_get_shared_memory_flatten_data_unsigned_8 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_unsigned_8", getFlattenSignature);

            this.c_library_get_shared_memory_flatten_data_signed_16 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_signed_16", getFlattenSignature);

            this.c_library_get_shared_memory_flatten_data_unsigned_16 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_unsigned_16", getFlattenSignature);

            this.c_library_get_shared_memory_flatten_data_signed_32 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_signed_32", getFlattenSignature);

            this.c_library_get_shared_memory_flatten_data_unsigned_32 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_unsigned_32", getFlattenSignature);

            this.c_library_get_shared_memory_flatten_data_signed_64 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_signed_64", getFlattenSignature);

            this.c_library_get_shared_memory_flatten_data_unsigned_64 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_unsigned_64", getFlattenSignature);

            this.c_library_get_shared_memory_flatten_data_float32 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_float32", getFlattenSignature);

            this.c_library_get_shared_memory_flatten_data_float64 = getRawMethodHandle(
                    "get_shared_memory_flatten_data_float64", getFlattenSignature);

            this.c_library_get_shared_memory_string = getRawMethodHandle("get_shared_memory_string",
                                                                         getFlattenSignature);
        } catch (NoSuchElementException e) {
            e.printStackTrace();
            throw new RuntimeException("Could not find the methods in the specified library.");
        }
    }

    /**
     * @param existingError used to make initCause
     * @param methodHandle used in the error message
     * @return an IllegalStateException initCaused by existingError
     * */
    @NotNull
    private static IllegalStateException makeIllegalStateExceptionFrom(@NotNull Throwable existingError,
                                                                       @NotNull MethodHandle methodHandle) {
        return new IllegalStateException(String.format("Error in invoking %s", methodHandle), existingError);
    }

    /**
     * @param path used to access the shared memory.
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryPath(@NotNull Path path) {
        final MemorySegment pathSegment = memorySession.allocateUtf8String(path.toString());
        checkError((int) invokeMethod(this.c_library_set_shared_memory_path, pathSegment.address()));
    }

    /**
     * The newDimensions rank should match the existing one.
     * @param newDimensions replaces the current shared memory dimension with newDimensions
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryDimensions(int @NotNull [] newDimensions) {
        final MemorySegment memorySegment = memorySession.allocateArray(ValueLayout.JAVA_INT, newDimensions);
        checkError((int) invokeMethod(this.c_library_set_shared_memory_dimensions, memorySegment.address()));
    }

    /**
     * Set shared memory data with a string
     * @param data: a string to save in shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(@NotNull String data) {
        final MemorySegment inputSegment = memorySession.allocateUtf8String(data);
        checkError((int) invokeMethod(this.c_library_set_shared_memory_string, inputSegment.address()));
    }

    /**
     * Set shared memory data with byte short type
     * @param data: a 1D array of byte
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(byte @NotNull [] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 1D array of byte
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(byte @NotNull [] data, boolean isSigned) {
        checkError(setSharedMemoryRaw1D(Primitives.BYTE, data, data.length, isSigned));
    }

    /**
     * Set shared memory data with byte short type
     * @param data: a 2D array of byte
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(byte @NotNull [][] data) {
        setSharedMemoryData(data, false);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 2D array of byte
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(byte @NotNull [][] data, boolean isSigned) {
        final var dimensions = checkRank2D(data.length, data[0].length);
        checkError(setSharedMemoryRaw2D(Primitives.BYTE, data, dimensions, isSigned));
    }

    /**
     * Set shared memory data with byte short type
     * @param data: a 3D array of byte
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(byte @NotNull [][][] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 3D array of byte
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(byte @NotNull [][][] data, boolean isSigned) {
        final var dimensions = checkRank3D(data.length, data[0] == null ? 0 : data[0].length,
                                           data[0] == null ? 0 : (data[0][0] == null ? 0 : data[0][0].length));
        checkError(setSharedMemoryRaw3D(Primitives.BYTE, data, dimensions, isSigned));
    }

    /**
     * Set shared memory data with signed short type
     * @param data: a 1D array of short
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(short @NotNull [] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 1D array of short
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(short @NotNull [] data, boolean isSigned) {
        checkError(setSharedMemoryRaw1D(Primitives.SHORT, data, data.length, isSigned));
    }

    /**
     * Set shared memory data with signed short type
     * @param data: a 2D array of short
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(short @NotNull [][] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 2D array of short
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(short @NotNull [][] data, boolean isSigned) {
        final var dimensions = checkRank2D(data.length, data[0].length);
        checkError(setSharedMemoryRaw2D(Primitives.SHORT, data, dimensions, isSigned));
    }

    /**
     * Set shared memory data with signed short type
     * @param data: a 3D array of short
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(short @NotNull [][][] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 3D array of short
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(short @NotNull [][][] data, boolean isSigned) {
        final var dimensions = checkRank3D(data.length, data[0] == null ? 0 : data[0].length,
                                           data[0] == null ? 0 : (data[0][0] == null ? 0 : data[0][0].length));
        checkError(setSharedMemoryRaw3D(Primitives.SHORT, data, dimensions, isSigned));
    }

    /**
     * Set shared memory data with signed int type
     * @param data: a 1D array of int
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(int @NotNull [] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 1D array of int
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(int @NotNull [] data, boolean isSigned) {
        checkError(setSharedMemoryRaw1D(Primitives.INT, data, data.length, isSigned));
    }

    /**
     * Set shared memory data with signed int type
     * @param data: a 2D array of int
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(int @NotNull [][] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 2D array of int
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(int @NotNull [][] data, boolean isSigned) {
        final var dimensions = checkRank2D(data.length, data[0].length);
        checkError(setSharedMemoryRaw2D(Primitives.INT, data, dimensions, isSigned));
    }

    /**
     * Set shared memory data with signed int type
     * @param data: a 3D array of int
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(int @NotNull [][][] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 3D array of int
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(int @NotNull [][][] data, boolean isSigned) {
        final var dimensions = checkRank3D(data.length, data[0] == null ? 0 : data[0].length,
                                           data[0] == null ? 0 : (data[0][0] == null ? 0 : data[0][0].length));
        checkError(setSharedMemoryRaw3D(Primitives.INT, data, dimensions, isSigned));
    }

    /**
     * Set shared memory data with signed long type
     * @param data: a 1D array of long
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(long @NotNull [] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 1D array of long
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(long @NotNull [] data, boolean isSigned) {
        setSharedMemoryRaw1D(Primitives.LONG, data, data.length, isSigned);
    }

    /**
     * Set shared memory data with signed long type
     * @param data: a 2D array of long
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(long @NotNull [][] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 2D array of long
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(long @NotNull [][] data, boolean isSigned) {
        final var dimensions = checkRank2D(data.length, data[0].length);
        checkError(setSharedMemoryRaw2D(Primitives.LONG, data, dimensions, isSigned));
    }

    /**
     * Set shared memory data with signed long type
     * @param data: a 3D array of long
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(long @NotNull [][][] data) {
        setSharedMemoryData(data, true);
    }

    /**
     * Set shared memory data with the specified sign
     * @param data: a 3D array of long
     * @param isSigned determines the type of shared memory
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(long @NotNull [][][] data, boolean isSigned) {
        final var dimensions = checkRank3D(data.length, data[0] == null ? 0 : data[0].length,
                                           data[0] == null ? 0 : (data[0][0] == null ? 0 : data[0][0].length));
        checkError(setSharedMemoryRaw3D(Primitives.LONG, data, dimensions, isSigned));
    }

    /**
     * Set shared memory data
     * @param data: a 1D array of float
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(float @NotNull [] data) {
        setSharedMemoryRaw1D(Primitives.FLOAT, data, data.length, false);
    }

    /**
     * Set shared memory data
     * @param data: a 2D array of float
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(float @NotNull [][] data) {
        final var dimensions = checkRank2D(data.length, data[0].length);
        checkError(setSharedMemoryRaw2D(Primitives.FLOAT, data, dimensions, false));
    }

    /**
     * Set shared memory data
     * @param data: a 3D array of float
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(float @NotNull [][][] data) {
        final var dimensions = checkRank3D(data.length, data[0] == null ? 0 : data[0].length,
                                           data[0] == null ? 0 : (data[0][0] == null ? 0 : data[0][0].length));
        checkError(setSharedMemoryRaw3D(Primitives.FLOAT, data, dimensions, false));
    }

    /**
     * Set shared memory data
     * @param data: a 1D array of double
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(double @NotNull [] data) {
        checkError(setSharedMemoryRaw1D(Primitives.DOUBLE, data, data.length, false));
    }

    /**
     * Set shared memory data
     * @param data: a 2D array of double
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(double @NotNull [][] data) {
        final var dimensions = checkRank2D(data.length, data[0].length);
        checkError(setSharedMemoryRaw2D(Primitives.DOUBLE, data, dimensions, false));
    }

    /**
     * Set shared memory data
     * @param data: a 3D array of double
     * @throws RuntimeException if the operation was unsuccessful
     * */
    public void setSharedMemoryData(double @NotNull [][][] data) {
        final var dimensions = checkRank3D(data.length, data[0] == null ? 0 : data[0].length,
                                           data[0] == null ? 0 : (data[0][0] == null ? 0 : data[0][0].length));
        checkError(setSharedMemoryRaw3D(Primitives.DOUBLE, data, dimensions, false));
    }

    /**
     * This is a general function usually used to get primitive value from shared memory.
     * @param methodHandle the method to be invoked
     * @return the Object returned by invokeMethodRaw
     * @throws RuntimeException if the operation was unsuccessful
     * @see SharedMemory::invokeMethodRaw()
     * */
    @NotNull
    private Object invokeMethod(@NotNull MethodHandle methodHandle) {
        return invokeMethodRaw(methodHandle, 0, null, null, null);
    }

    /**
     * This is a general function usually used to get a 1D data from shared memory.
     * @param methodHandle the method to be invoked
     * @param memoryAddress address of generally 1D data
     * @return the Object returned by invokeMethodRaw
     * @throws RuntimeException if the operation was unsuccessful
     * @see SharedMemory::invokeMethodRaw()
     * */
    @NotNull
    private Object invokeMethod(@NotNull MethodHandle methodHandle, @NotNull MemoryAddress memoryAddress) {
        return invokeMethodRaw(methodHandle, 1, memoryAddress, null, null);
    }

    /**
     * This general function used to set the shared memory data.
     *
     * @param methodHandle specified the handle to be invoked
     * @param memoryAddress1 address of data
     * @param memoryAddress2 address of dimension of data
     * @param rank specifies data rank
     *
     * @return the Object returned by invokeMethodRaw
     * @throws RuntimeException if the operation was unsuccessful
     * @see SharedMemory::invokeMethodRaw()
     * */
    @NotNull
    private Object invokeMethod(@NotNull MethodHandle methodHandle,
                                @NotNull MemoryAddress memoryAddress1,
                                @NotNull MemoryAddress memoryAddress2,
                                long rank) {
        return invokeMethodRaw(methodHandle, 3, memoryAddress1, memoryAddress2, rank);
    }

    /**
     * This function is a generalized form of invoking used to invoke foreign functions.
     *
     * @param methodHandle is the handle gets invoked
     * @param numberOfArgument specifies the number of types should used in invoking
     * @param i1 is an Object could be passed to method handle. Can be null.
     * @param i2 is an Object could be passed to method handle. Can be null.
     * @param i3 is an Object could be passed to method handle. Can be null.
     *
     * @return the value foreign function return as an Object (it should be numeric).
     * @throws IllegalStateException if this is closed or numberOfArgument is a value other than 0, 1 and 3
     * @throws RuntimeException if the operation was unsuccessful
     * */
    @NotNull
    private Object invokeMethodRaw(@NotNull MethodHandle methodHandle,
                                   int numberOfArgument,
                                   @Nullable Object i1,
                                   @Nullable Object i2,
                                   @Nullable Object i3) {

        checkIsClosed();

        try {
            final Object result = switch (numberOfArgument) {
                case 0 -> methodHandle.invoke();
                case 1 -> methodHandle.invoke(i1);
                case 3 -> methodHandle.invoke(i1, i2, i3);
                default -> throw new IllegalStateException("Unexpected value: " + numberOfArgument);
            };
            checkError((int) result);
            return result;

        } catch (Throwable e) {
            throw makeIllegalStateExceptionFrom(e, methodHandle);
        }
    }

    /**
     * This function is used to check the return type of all the external functions calls.
     * Errors number reflect the errors written in Rust library.
     *
     * @param value: If value is negative, it's error otherwise should be return
     *
     * @return If value is negative, an exception is raised, otherwise the value will be returned
     * @throws RuntimeException if value is negative.
     * */
    private int checkError(int value) {
        if (value < 0) {
            switch (value) {
                case -1 -> throw new RuntimeException("Library path is not set");
                case -2 -> throw new RuntimeException("Error in accessing shared file (probably file does not exist)");
                case -3 -> throw new RuntimeException("Can't read library_path from memory");
                case -4 -> throw new RuntimeException("Can't create shared memory");
                case -5 -> throw new RuntimeException("New Rank doesn't match the previous rank");
                default -> throw new RuntimeException(String.format("Invalid error code is given: %s%n", value));
            }
        }
        return value;
    }

    private enum Primitives {BYTE, SHORT, INT, LONG, FLOAT, DOUBLE}


    /**
     * This function is a generic-like form for setting the shared memory data a 1D array.
     * The body of each switch case is similar but with subtle difference in their types.
     *
     * @param type       specifies the data type.
     * @param data       is the actual data but casted as an Object
     * @param isSigned   determines which method handle should be called. It will determine the sign of shared memory data type.
     * @return an int passed by the foreign function indicating the success of the operation
     */
    private int setSharedMemoryRaw1D(@NotNull Primitives type, @NotNull Object data, int dataLength, boolean isSigned) {

        final MemorySegment dimensionSegment = memorySession.allocate(8L);
        dimensionSegment.set(ValueLayout.JAVA_LONG, 0, dataLength);

        return checkError((int) switch (type) {
            case BYTE -> {
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_BYTE, (byte[]) data);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_8,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(),
                                       1L);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_8,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), 1L);
                }
            }
            case SHORT -> {
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_SHORT, (short[]) data);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_16,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), 1L);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_16,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), 1L);
                }
            }
            case INT -> {
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_INT, (int[]) data);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_32,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), 1L);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_32,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), 1L);
                }
            }
            case LONG -> {
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_LONG, (long[]) data);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_64,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), 1L);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_64,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), 1L);
                }
            }
            case FLOAT -> {
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_FLOAT, (float[]) data);
                yield invokeMethod(this.c_library_set_shared_memory_data_float32, arraySegment.asReadOnly().address(),
                                   dimensionSegment.asReadOnly().address(), 1L);

            }
            case DOUBLE -> {
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_DOUBLE, (double[]) data);
                yield invokeMethod(this.c_library_set_shared_memory_data_float64, arraySegment.asReadOnly().address(),
                                   dimensionSegment.asReadOnly().address(), 1L);

            }
        });
    }

    /**
     * This function is a generic-like form for setting the shared memory data a 2D array.
     * The body of each switch case is similar but with subtle difference in their types.
     *
     * @param type       specifies the data type.
     * @param data       is the actual data but casted as an Object
     * @param dimensions is the dimension of data. Should contain 2 element.
     * @param isSigned   determines which method handle should be called. It will determine the sign of shared memory data type.
     * @return an int passed by the foreign function indicating the success of the operation
     * @throws RuntimeException If dimensions parameter doesn't have 2 element
     */
    private int setSharedMemoryRaw2D(@NotNull Primitives type,
                                     @NotNull Object data,
                                     int @NotNull [] dimensions,
                                     boolean isSigned) {
        if (dimensions.length < 2) {
            throw new IllegalArgumentException(
                    String.format("Parameter dimensions should contain 2 element. \"%d\" is given.", dimensions.length));
        }

        final MemorySegment dimensionSegment = memorySession.allocate(16L);
        final int d1Length = dimensions[0];
        final int d2Length = dimensions[1];
        dimensionSegment.set(ValueLayout.JAVA_LONG, 0, d1Length);
        dimensionSegment.set(ValueLayout.JAVA_LONG, 8, d2Length);
        final long rank = 2;
        return checkError((int) switch (type) {
            case BYTE -> {
                final byte[] flattenData = new byte[d1Length * d2Length];
                final byte[][] dataArray = (byte[][]) data;
                for (int i = 0; i < d2Length; i++) {
                    for (int j = 0; j < d1Length; j++) {
                        flattenData[i * d1Length + j] = dataArray[j][i];
                    }
                }
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_BYTE, flattenData);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_8,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(),
                                       rank);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_8,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(),
                                       rank);
                }
            }
            case SHORT -> {
                final short[] flattenData = new short[d1Length * d2Length];
                final short[][] dataArray = (short[][]) data;
                for (int i = 0; i < d2Length; i++) {
                    for (int j = 0; j < d1Length; j++) {
                        flattenData[i * d1Length + j] = dataArray[j][i];
                    }
                }
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_SHORT, flattenData);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_16,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(),
                                       rank);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_16,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(),
                                       rank);
                }
            }
            case INT -> {
                final int[] flattenData = new int[d1Length * d2Length];
                final int[][] dataArray = (int[][]) data;
                for (int i = 0; i < d2Length; i++) {
                    for (int j = 0; j < d1Length; j++) {
                        flattenData[i * d1Length + j] = dataArray[j][i];
                    }
                }
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_INT, flattenData);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_32,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(),
                                       rank);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_32,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(),
                                       rank);
                }
            }
            case LONG -> {
                final long[] flattenData = new long[d1Length * d2Length];
                final long[][] dataArray = (long[][]) data;
                for (int i = 0; i < d2Length; i++) {
                    for (int j = 0; j < d1Length; j++) {
                        flattenData[i * d1Length + j] = dataArray[j][i];
                    }
                }

                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_LONG, flattenData);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_64,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(),
                                       rank);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_64,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(),
                                       rank);
                }
            }
            case FLOAT -> {
                final float[] flattenData = new float[d1Length * d2Length];
                final float[][] dataArray = (float[][]) data;
                for (int i = 0; i < d2Length; i++) {
                    for (int j = 0; j < d1Length; j++) {
                        flattenData[i * d1Length + j] = dataArray[j][i];
                    }
                }

                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_FLOAT, flattenData);
                yield invokeMethod(this.c_library_set_shared_memory_data_float32, arraySegment.asReadOnly().address(),
                                   dimensionSegment.asReadOnly().address(), rank);

            }
            case DOUBLE -> {
                final double[] flattenData = new double[d1Length * d2Length];
                final double[][] dataArray = (double[][]) data;
                for (int i = 0; i < d2Length; i++) {
                    for (int j = 0; j < d1Length; j++) {
                        flattenData[i * d1Length + j] = dataArray[j][i];
                    }
                }

                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_DOUBLE, flattenData);
                yield invokeMethod(this.c_library_set_shared_memory_data_float64, arraySegment.asReadOnly().address(),
                                   dimensionSegment.asReadOnly().address(), rank);
            }
        });
    }

    /**
     * This function is a generic-like form for setting the shared memory data a 3D array.
     * The body of each switch case is similar but with subtle difference in their types.
     *
     * @param type       specifies the data type.
     * @param data       is the actual data but casted as an Object
     * @param dimensions is the dimension of data. Should contain 3 element.
     * @param isSigned   determines which method handle should be called. It will determine the sign of shared memory data type.
     * @return an int passed by the foreign function indicating the success of the operation
     * @throws RuntimeException If dimensions parameter doesn't have 3 element
     */
    private int setSharedMemoryRaw3D(@NotNull Primitives type, @NotNull Object data, int @NotNull [] dimensions, boolean isSigned) {

        if (dimensions.length < 3) {
            throw new IllegalArgumentException(
                    String.format("Parameter dimensions should contain 3 element. \"%d\" is given.", dimensions.length));
        }

        final MemorySegment dimensionSegment = memorySession.allocate(24L);
        final int d1Length = dimensions[0];
        final int d2Length = dimensions[1];
        final int d3Length = dimensions[2];
        dimensionSegment.set(ValueLayout.JAVA_LONG, 0, d2Length);
        dimensionSegment.set(ValueLayout.JAVA_LONG, 8, d3Length);
        dimensionSegment.set(ValueLayout.JAVA_LONG, 16, d1Length);
        final long rank = 3;

        return checkError((int) switch (type) {
            case BYTE -> {
                final byte[] flattenData = new byte[d1Length * d2Length * d3Length];
                final byte[][][] dataArray = (byte[][][]) data;
                for (int d1 = 0; d1 < d1Length; d1++) {
                    for (int d2 = 0; d2 < d2Length; d2++) {
                        for (int d3 = 0; d3 < d3Length; d3++)
                            flattenData[d1 * d2Length * d3Length + d3 * d2Length + d2] = dataArray[d1][d2][d3];
                    }
                }
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_BYTE, flattenData);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_8,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), rank);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_8,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), rank);
                }
            }
            case SHORT -> {
                final short[] flattenData = new short[d1Length * d2Length * d3Length];
                final short[][][] dataArray = (short[][][]) data;
                for (int d1 = 0; d1 < d1Length; d1++) {
                    for (int d2 = 0; d2 < d2Length; d2++) {
                        for (int d3 = 0; d3 < d3Length; d3++)
                            flattenData[d1 * d2Length * d3Length + d3 * d2Length + d2] = dataArray[d1][d2][d3];
                    }
                }
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_SHORT, flattenData);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_16,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), rank);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_16,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), rank);
                }
            }
            case INT -> {
                final int[] flattenData = new int[d1Length * d2Length * d3Length];
                final int[][][] dataArray = (int[][][]) data;
                for (int d1 = 0; d1 < d1Length; d1++) {
                    for (int d2 = 0; d2 < d2Length; d2++) {
                        for (int d3 = 0; d3 < d3Length; d3++)
                            flattenData[d1 * d2Length * d3Length + d3 * d2Length + d2] = dataArray[d1][d2][d3];
                    }
                }
                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_INT, flattenData);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_32,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), rank);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_32,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), rank);
                }
            }
            case LONG -> {
                final long[] flattenData = new long[d1Length * d2Length * d3Length];
                final long[][][] dataArray = (long[][][]) data;
                for (int d1 = 0; d1 < d1Length; d1++) {
                    for (int d2 = 0; d2 < d2Length; d2++) {
                        for (int d3 = 0; d3 < d3Length; d3++)
                            flattenData[d1 * d2Length * d3Length + d3 * d2Length + d2] = dataArray[d1][d2][d3];
                    }
                }

                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_LONG, flattenData);
                if (isSigned) {
                    yield invokeMethod(this.c_library_set_shared_memory_data_signed_64,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), rank);
                } else {
                    yield invokeMethod(this.c_library_set_shared_memory_data_unsigned_64,
                                       arraySegment.asReadOnly().address(), dimensionSegment.asReadOnly().address(), rank);
                }
            }
            case FLOAT -> {
                final float[] flattenData = new float[d1Length * d2Length * d3Length];
                final float[][][] dataArray = (float[][][]) data;
                for (int d1 = 0; d1 < d1Length; d1++) {
                    for (int d2 = 0; d2 < d2Length; d2++) {
                        for (int d3 = 0; d3 < d3Length; d3++)
                            flattenData[d1 * d2Length * d3Length + d3 * d2Length + d2] = dataArray[d1][d2][d3];
                    }
                }

                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_FLOAT, flattenData);
                yield invokeMethod(this.c_library_set_shared_memory_data_float32, arraySegment.asReadOnly().address(),
                                   dimensionSegment.asReadOnly().address(), rank);
            }
            case DOUBLE -> {
                final double[] flattenData = new double[d1Length * d2Length * d3Length];
                final double[][][] dataArray = (double[][][]) data;
                for (int d1 = 0; d1 < d1Length; d1++) {
                    for (int d2 = 0; d2 < d2Length; d2++) {
                        for (int d3 = 0; d3 < d3Length; d3++)
                            flattenData[d1 * d2Length * d3Length + d3 * d2Length + d2] = dataArray[d1][d2][d3];
                    }
                }

                final MemorySegment arraySegment = memorySession.allocateArray(ValueLayout.JAVA_DOUBLE, flattenData);
                yield invokeMethod(this.c_library_set_shared_memory_data_float64, arraySegment.asReadOnly().address(),
                                   dimensionSegment.asReadOnly().address(), rank);
            }
        });
    }

    /**
     * This function get the shared memory type and size and copy the content to a MemorySegment.
     * This MemorySegment used further by all the getSharedMemory___ functions.
     *
     * @return MemorySegment containing shared memory data
     * @throws RuntimeException if the requested type does not match shared memory data type
     */
    @NotNull
    private MemorySegment getSharedMemoryDataRaw(@NotNull SharedMemoryDataType inputType) {
        final var type = getSharedMemoryDataType();

        if (inputType.byteSize != type.byteSize) {
            throw new RuntimeException(String.format(
                    "Shared memory contain %s data, can not be converted to a %d-bit data type. Use %d-bit caller instead.%n",
                    type, inputType.byteSize * 8, type.byteSize * 8));
        }
        final MemorySegment outputSegment = memorySession.allocate(
                this.getSharedMemoryFlattenLength() * inputType.byteSize);
        switch (inputType) {
            case BYTE -> invokeMethod(c_library_get_shared_memory_flatten_data_signed_8, outputSegment.address());
            case UNSIGNED_BYTE -> invokeMethod(c_library_get_shared_memory_flatten_data_unsigned_8, outputSegment.address());
            case SHORT -> invokeMethod(c_library_get_shared_memory_flatten_data_signed_16, outputSegment.address());
            case UNSIGNED_SHORT ->
                    invokeMethod(c_library_get_shared_memory_flatten_data_unsigned_16, outputSegment.address());
            case INT -> invokeMethod(c_library_get_shared_memory_flatten_data_signed_32, outputSegment.address());
            case UNSIGNED_INT -> invokeMethod(c_library_get_shared_memory_flatten_data_unsigned_32, outputSegment.address());
            case LONG -> invokeMethod(c_library_get_shared_memory_flatten_data_signed_64, outputSegment.address());
            case UNSIGNED_LONG ->
                    invokeMethod(c_library_get_shared_memory_flatten_data_unsigned_64, outputSegment.address());
            case FLOAT -> invokeMethod(c_library_get_shared_memory_flatten_data_float32, outputSegment.address());
            case DOUBLE -> invokeMethod(c_library_get_shared_memory_flatten_data_float64, outputSegment.address());
        }
        return outputSegment;
    }


    /**
     * @return The shared memory string
     * @throws IllegalStateException if the shared memory data type is a type other than string.
     */
    @NotNull
    public String getSharedMemoryString() {
        final var sharedMemoryDataType = getSharedMemoryDataType();
        if (sharedMemoryDataType != SharedMemoryDataType.STRING)
            throw new IllegalStateException(
                    String.format("Shared memory contains %s data, can not convert it to String.%n",
                                  sharedMemoryDataType));

        final MemorySegment resultSegment = memorySession.allocate(getSharedMemoryFlattenLength() + 1);
        invokeMethod(this.c_library_get_shared_memory_string, resultSegment.address());
        return resultSegment.getUtf8String(0);
    }

    /**
     * @return shared memory flatten data as a byte array
     * @throws RuntimeException if operation was not successful.
     */
    public byte @NotNull [] getSharedMemoryFlattenDataByte() {
        return getSharedMemoryDataRaw(checkType(getSharedMemoryDataType(), SharedMemoryDataType.BYTE,
                                                SharedMemoryDataType.UNSIGNED_BYTE)).toArray(ValueLayout.JAVA_BYTE);
    }


    /**
     * @return shared memory flatten data as a short array
     * @throws RuntimeException if operation was not successful.
     */
    public short @NotNull [] getSharedMemoryFlattenDataShort() {
        return getSharedMemoryDataRaw(checkType(getSharedMemoryDataType(), SharedMemoryDataType.SHORT,
                                                SharedMemoryDataType.UNSIGNED_SHORT)).toArray(ValueLayout.JAVA_SHORT);
    }

    /**
     * @return shared memory flatten data as an int array
     * @throws RuntimeException if operation was not successful.
     */
    public int @NotNull [] getSharedMemoryFlattenDataInt() {
        return getSharedMemoryDataRaw(checkType(getSharedMemoryDataType(), SharedMemoryDataType.INT,
                                                SharedMemoryDataType.UNSIGNED_INT)).toArray(ValueLayout.JAVA_INT);
    }

    /**
     * @return shared memory flatten data as a long array
     * @throws RuntimeException if operation was not successful.
     */
    public long @NotNull [] getSharedMemoryFlattenDataLong() {

        return getSharedMemoryDataRaw(checkType(getSharedMemoryDataType(), SharedMemoryDataType.LONG,
                                                SharedMemoryDataType.UNSIGNED_LONG)).toArray(ValueLayout.JAVA_LONG);
    }

    /**
     * @return shared memory flatten data as a float array
     * @throws RuntimeException if operation was not successful.
     */
    public float @NotNull [] getSharedMemoryFlattenDataFloat() {
        return getSharedMemoryDataRaw(SharedMemoryDataType.FLOAT).toArray(ValueLayout.JAVA_FLOAT);
    }

    /**
     * @return shared memory flatten data as a double array
     * @throws RuntimeException if operation was not successful.
     */
    public double @NotNull [] getSharedMemoryFlattenDataDouble() {
        return getSharedMemoryDataRaw(SharedMemoryDataType.DOUBLE).toArray(ValueLayout.JAVA_DOUBLE);
    }

    /**
     * @return shared memory flatten data as a 1-dimension byte array
     * @throws RuntimeException if operation was not successful.
     */
    public byte @NotNull [] getSharedMemoryByte1D() {
        return getSharedMemoryFlattenDataByte();
    }

    /**
     * @return shared memory flatten data as a 1-dimension short array
     * @throws RuntimeException if operation was not successful.
     */
    public short @NotNull [] getSharedMemoryShort1D() {
        return getSharedMemoryFlattenDataShort();
    }

    /**
     * @return shared memory flatten data as a 1-dimension int array
     * @throws RuntimeException if operation was not successful.
     */
    public int @NotNull [] getSharedMemoryInt1D() {
        return getSharedMemoryFlattenDataInt();
    }

    /**
     * @return shared memory flatten data as a 1-dimension long array
     * @throws RuntimeException if operation was not successful.
     */
    public long @NotNull [] getSharedMemoryLong1D() {
        return getSharedMemoryFlattenDataLong();
    }

    /**
     * @return shared memory flatten data as a 1-dimension float array
     * @throws RuntimeException if operation was not successful.
     */
    public float @NotNull [] getSharedMemoryFloat1D() {
        return getSharedMemoryFlattenDataFloat();
    }

    /**
     * @return shared memory flatten data as a 1-dimension double array
     * @throws RuntimeException if operation was not successful.
     */
    public double @NotNull [] getSharedMemoryDouble1D() {
        return getSharedMemoryFlattenDataDouble();
    }

    /**
     * @return shared memory flatten data as a 2-dimension byte array
     * @throws RuntimeException if operation was not successful.
     */
    public byte @NotNull [][] getSharedMemoryByte2D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 2);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.BYTE, SharedMemoryDataType.UNSIGNED_BYTE));
        final byte[][] result = new byte[(int) dimensions[0]][(int) dimensions[1]];

        final long d1Length = dimensions[0];
        final long d2Length = dimensions[1];

        for (int column = 0; column < d2Length; column++) {
            for (int row = 0; row < dimensions[0]; row++) {
                result[row][column] = resultRaw.get(ValueLayout.JAVA_BYTE, row + column * d1Length);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 2-dimension short array
     * @throws RuntimeException if operation was not successful.
     */
    public short @NotNull [][] getSharedMemoryShort2D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 2);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.SHORT, SharedMemoryDataType.UNSIGNED_SHORT));
        final short[][] result = new short[(int) dimensions[0]][(int) dimensions[1]];
        final long d1Length = dimensions[0];
        final long d2Length = dimensions[1];

        for (int column = 0; column < d2Length; column++) {
            for (int row = 0; row < dimensions[0]; row++) {
                result[row][column] = resultRaw.getAtIndex(ValueLayout.JAVA_SHORT, row + column * d1Length);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 2-dimension int array
     * @throws RuntimeException if operation was not successful.
     */
    public int @NotNull [][] getSharedMemoryInt2D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 2);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.INT, SharedMemoryDataType.UNSIGNED_INT));
        final int[][] result = new int[(int) dimensions[0]][(int) dimensions[1]];
        final long d1Length = dimensions[0];
        final long d2Length = dimensions[1];

        for (int column = 0; column < d2Length; column++) {
            for (int row = 0; row < dimensions[0]; row++) {
                result[row][column] = resultRaw.getAtIndex(ValueLayout.JAVA_INT, row + column * d1Length);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 2-dimension long array
     * @throws RuntimeException if operation was not successful.
     */
    public long @NotNull [][] getSharedMemoryLong2D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 2);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.LONG, SharedMemoryDataType.UNSIGNED_LONG));
        final long[][] result = new long[(int) dimensions[0]][(int) dimensions[1]];

        final long d1Length = dimensions[0];
        final long d2Length = dimensions[1];

        for (int column = 0; column < d2Length; column++) {
            for (int row = 0; row < dimensions[0]; row++) {
                result[row][column] = resultRaw.getAtIndex(ValueLayout.JAVA_LONG, row + column * d1Length);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 2-dimension float array
     * @throws RuntimeException if operation was not successful.
     */
    public float @NotNull [][] getSharedMemoryFloat2D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 2);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.FLOAT));
        final float[][] result = new float[(int) dimensions[0]][(int) dimensions[1]];

        final long d1Length = dimensions[0];
        final long d2Length = dimensions[1];

        for (int column = 0; column < d2Length; column++) {
            for (int row = 0; row < dimensions[0]; row++) {
                result[row][column] = resultRaw.getAtIndex(ValueLayout.JAVA_FLOAT, row + column * d1Length);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 2-dimension double array
     * @throws RuntimeException if operation was not successful.
     */
    public double @NotNull [][] getSharedMemoryDouble2D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 2);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.DOUBLE));
        final double[][] result = new double[(int) dimensions[0]][(int) dimensions[1]];

        final long d1Length = dimensions[0];
        final long d2Length = dimensions[1];

        for (int column = 0; column < d2Length; column++) {
            for (int row = 0; row < dimensions[0]; row++) {
                result[row][column] = resultRaw.getAtIndex(ValueLayout.JAVA_DOUBLE, row + column * d1Length);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 3-dimension byte array
     * @throws RuntimeException if operation was not successful.
     */
    public byte @NotNull [][][] getSharedMemoryByte3D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 3);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.BYTE, SharedMemoryDataType.UNSIGNED_BYTE));
        final byte[][][] result = new byte[(int) dimensions[2]][(int) dimensions[0]][(int) dimensions[1]];

        final long d2Length = dimensions[0];
        final long d3Length = dimensions[1];
        final long d1Length = dimensions[2];
        for (int d1 = 0; d1 < d1Length; d1++) {
            for (int d2 = 0; d2 < d2Length; d2++) {
                for (int d3 = 0; d3 < d3Length; d3++)
                    result[d1][d2][d3] = resultRaw.get(ValueLayout.JAVA_BYTE,
                                                       d1 * d2Length * d3Length + d3 * d2Length + d2);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 3-dimension short array
     * @throws RuntimeException if operation was not successful.
     */
    public short @NotNull [][][] getSharedMemoryShort3D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 3);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.SHORT, SharedMemoryDataType.UNSIGNED_SHORT));
        final short[][][] result = new short[(int) dimensions[2]][(int) dimensions[0]][(int) dimensions[1]];

        final long d2Length = dimensions[0];
        final long d3Length = dimensions[1];
        final long d1Length = dimensions[2];
        for (int d1 = 0; d1 < d1Length; d1++) {
            for (int d2 = 0; d2 < d2Length; d2++) {
                for (int d3 = 0; d3 < d3Length; d3++)
                    result[d1][d2][d3] = resultRaw.getAtIndex(ValueLayout.JAVA_SHORT,
                                                              d1 * d2Length * d3Length + d3 * d2Length + d2);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 3-dimension int array
     * @throws RuntimeException if operation was not successful.
     */
    public int @NotNull [][][] getSharedMemoryInt3D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 3);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.INT, SharedMemoryDataType.UNSIGNED_INT));
        final int[][][] result = new int[(int) dimensions[2]][(int) dimensions[0]][(int) dimensions[1]];

        final long d2Length = dimensions[0];
        final long d3Length = dimensions[1];
        final long d1Length = dimensions[2];
        for (int d1 = 0; d1 < d1Length; d1++) {
            for (int d2 = 0; d2 < d2Length; d2++) {
                for (int d3 = 0; d3 < d3Length; d3++)
                    result[d1][d2][d3] = resultRaw.getAtIndex(ValueLayout.JAVA_INT,
                                                              d1 * d2Length * d3Length + d3 * d2Length + d2);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 3-dimension long array
     * @throws RuntimeException if operation was not successful.
     */
    public long @NotNull [][][] getSharedMemoryLong3D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 3);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.LONG, SharedMemoryDataType.UNSIGNED_LONG));
        final long[][][] result = new long[(int) dimensions[2]][(int) dimensions[0]][(int) dimensions[1]];

        final long d2Length = dimensions[0];
        final long d3Length = dimensions[1];
        final long d1Length = dimensions[2];
        for (int d1 = 0; d1 < d1Length; d1++) {
            for (int d2 = 0; d2 < d2Length; d2++) {
                for (int d3 = 0; d3 < d3Length; d3++)
                    result[d1][d2][d3] = resultRaw.getAtIndex(ValueLayout.JAVA_LONG,
                                                              d1 * d2Length * d3Length + d3 * d2Length + d2);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 3-dimension float array
     * @throws RuntimeException if operation was not successful.
     */
    public float @NotNull [][][] getSharedMemoryFloat3D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 3);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.FLOAT));
        final float[][][] result = new float[(int) dimensions[2]][(int) dimensions[0]][(int) dimensions[1]];

        final long d2Length = dimensions[0];
        final long d3Length = dimensions[1];
        final long d1Length = dimensions[2];
        for (int d1 = 0; d1 < d1Length; d1++) {
            for (int d2 = 0; d2 < d2Length; d2++) {
                for (int d3 = 0; d3 < d3Length; d3++)
                    result[d1][d2][d3] = resultRaw.getAtIndex(ValueLayout.JAVA_FLOAT,
                                                              d1 * d2Length * d3Length + d3 * d2Length + d2);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 3-dimension double array
     * @throws RuntimeException if operation was not successful.
     */
    public double @NotNull [][][] getSharedMemoryDouble3D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 3);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.DOUBLE));
        final double[][][] result = new double[(int) dimensions[2]][(int) dimensions[0]][(int) dimensions[1]];

        final long d2Length = dimensions[0];
        final long d3Length = dimensions[1];
        final long d1Length = dimensions[2];
        for (int d1 = 0; d1 < d1Length; d1++) {
            for (int d2 = 0; d2 < d2Length; d2++) {
                for (int d3 = 0; d3 < d3Length; d3++)
                    result[d1][d2][d3] = resultRaw.getAtIndex(ValueLayout.JAVA_DOUBLE,
                                                              d1 * d2Length * d3Length + d3 * d2Length + d2);
            }
        }
        return result;
    }

    /**
     * @return shared memory flatten data as a 4-dimension byte array
     * @throws RuntimeException if operation was not successful.
     */
    public byte @NotNull [][][][] getSharedMemoryByte4D() {
        final long[] dimensions = getSharedMemoryDimension();
        checkDimension(dimensions, 4);
        final MemorySegment resultRaw = getSharedMemoryDataRaw(
                checkType(getSharedMemoryDataType(), SharedMemoryDataType.BYTE, SharedMemoryDataType.UNSIGNED_BYTE));
        final byte[][][][] result = new byte[(int) dimensions[3]][(int) dimensions[2]][(int) dimensions[0]][(int) dimensions[1]];
        final long d3Length = dimensions[0];
        final long d4Length = dimensions[1];
        final long d2Length = dimensions[2];
        final long d1Length = dimensions[3];

        for (int d1 = 0; d1 < d1Length; d1++) {
            for (int d2 = 0; d2 < d2Length; d2++) {
                for (int d3 = 0; d3 < d3Length; d3++)
                    for (int d4 = 0; d4 < d4Length; d4++)
                        result[d1][d2][d3][d4] = resultRaw.get(ValueLayout.JAVA_BYTE,
                                                               d1 * d2Length * d4Length * d3Length + d2 * d3Length * d4Length + d4 * d3Length + d3);
            }
        }
        return result;
    }


    /**
     * Unload the data from memory if it can connect to it, otherwise will remove the specified file.
     *
     * @throws RuntimeException if operation was not successful.
     */
    public void deleteSharedMemory() {
        checkError((int) invokeMethod(this.c_library_delete_shared_memory));
    }

    /**
     * @return shared memory data rank.
     * @throws RuntimeException if operation was not successful.
     */
    public int getSharedMemoryRank() {
        return checkError((int) invokeMethod(this.c_library_get_shared_memory_rank));
    }

    /**
     * @return the product of shared memory data dimension.
     * @throws IllegalStateException if an error raise in invoking foreign function.
     * @throws RuntimeException      if operation was not successful.
     * @implNote Because this function is the only function return long (all the other return int), special treatment should be apply
     * for checking error type.
     */
    public long getSharedMemoryFlattenLength() {
        try {
            final var result = (long) this.c_library_get_shared_memory_flatten_length.invoke();
            if (result < 0L) {
                checkError((int) result);
            }
            return result;
        } catch (Throwable e) {
            throw makeIllegalStateExceptionFrom(e, this.c_library_get_shared_memory_flatten_length);
        }
    }

    /**
     * Represent supported types to store and retrieve from shared memory.
     *
     * @implNote Each type except complex ones and string have a byte size.
     */
    public enum SharedMemoryDataType {
        UNSIGNED_BYTE(1), UNSIGNED_SHORT(2), UNSIGNED_INT(4), UNSIGNED_LONG(8), BYTE(1), SHORT(2), INT(4), LONG(
                8), FLOAT(4), DOUBLE(8), COMPLEX_FLOAT(8), COMPLEX_DOUBLE(16), STRING(1);
        private final int byteSize;

        SharedMemoryDataType(int byteSize) {
            this.byteSize = byteSize;

        }

        /**
         * @throws NoSuchFieldError if this is a complex or string type
         */
        public int getByteSize() {
            if (this == COMPLEX_FLOAT || this == COMPLEX_DOUBLE || this == STRING) {
                throw new NoSuchFieldError(String.format("Type %s does not have a supported byte size", this));
            }
            return byteSize;
        }

    }


    /**
     * Return shared memory dimension.
     *
     * @throws IllegalStateException if this is closed.
     */
    public long @NotNull [] getSharedMemoryDimension() {
        final MemorySegment memorySegment = memorySession.allocate(getSharedMemoryRank() * 8L);
        invokeMethod(this.c_library_get_shared_memory_dimensions, memorySegment.address());
        checkError((int) invokeMethod(this.c_library_get_shared_memory_dimensions, memorySegment.address()));
        return memorySegment.toArray(ValueLayout.JAVA_LONG);
    }

    /**
     * Return the shared memory type
     *
     * @throws IllegalStateException if the data stored in the shared memory is complex or this is closed.
     */
    @NotNull
    public SharedMemoryDataType getSharedMemoryDataType() {
        final int typeID = (int) invokeMethod(this.c_library_get_shared_memory_data_type);

        return switch (typeID) {
            case 0 -> SharedMemoryDataType.UNSIGNED_BYTE;
            case 1 -> SharedMemoryDataType.UNSIGNED_SHORT;
            case 2 -> SharedMemoryDataType.UNSIGNED_INT;
            case 3 -> SharedMemoryDataType.UNSIGNED_LONG;
            case 4 -> SharedMemoryDataType.BYTE;
            case 5 -> SharedMemoryDataType.SHORT;
            case 6 -> SharedMemoryDataType.INT;
            case 7 -> SharedMemoryDataType.LONG;
            case 8 -> SharedMemoryDataType.FLOAT;
            case 9 -> SharedMemoryDataType.DOUBLE;
            case 10 -> SharedMemoryDataType.COMPLEX_FLOAT;
            case 11 -> SharedMemoryDataType.COMPLEX_DOUBLE;
            case 12 -> SharedMemoryDataType.STRING;
            default -> throw new IllegalStateException(String.format("Invalid data typeID (%s)%n", typeID));
        };
    }


    /**
     * Closes the memory session used for sharing data and between java and shared library.
     *
     * @throws IllegalStateException – if this is kept alive by another client.
     * @throws WrongThreadException  – if this method is called from a thread other than the thread owning this memory session.
     */
    @Override
    public void close() {
        this.memorySession.close();
        this.closed = true;
    }

    /**
     * @throws IllegalStateException if this is closed.
     */
    private void checkIsClosed() {
        if (this.closed) {
            throw new IllegalStateException("Library is in close state.");
        }
    }

    /**
     * @return actual type if matched with expectedType1 or expectedType1
     * @throws RuntimeException if actualType does not match expectedType1 and expectedType1
     */
    private static SharedMemoryDataType checkType(SharedMemoryDataType actualType,
                                                  SharedMemoryDataType expectedType1,
                                                  SharedMemoryDataType expectedType2) {
        if (actualType != expectedType1 && actualType != expectedType2) {
            throw new RuntimeException(
                    String.format("Type \"%s\" or \"%s\" does not match shared memory data type \"%s\".", expectedType1,
                                  expectedType2, actualType));
        }
        return actualType;
    }

    /**
     * @return actual type if matched with expectedType
     * @throws RuntimeException if actualType does not match expectedType
     */
    private static SharedMemoryDataType checkType(SharedMemoryDataType actualType, SharedMemoryDataType expectedType) {
        if (actualType != expectedType) {
            throw new RuntimeException(
                    String.format("Type \"%s\" does not match shared memory data type \"%s\".", expectedType,
                                  actualType));
        }
        return actualType;
    }


    /**
     * Make sure the dimension match the expected rank.
     *
     * @throws IllegalArgumentException if the rank does not match or dimension contain 0.
     */
    private static void checkDimension(long @NotNull [] dimensions, int expectedRank) {
        if (dimensions.length < expectedRank) {
            throw new IllegalArgumentException(
                    String.format("Shared data has %s dimension which is not compatible with %d rank",
                                  Arrays.toString(dimensions), expectedRank));
        }
        for (int i = 0; i < dimensions.length; i++) {
            if (dimensions[i] == 0)
                throw new IllegalStateException(String.format("Dimension contain 0 element at rank %d", i));
        }
    }

    /**
     * This function is used to check the length of array and length of its first element.
     *
     * @return int[] used to store dimension
     * @throws IllegalArgumentException if either the length of array or its first element is zero.
     */
    private static int @NotNull [] checkRank2D(int dimension1Length, int dimension2Length) {
        if (dimension1Length == 0)
            throw new IllegalArgumentException("Argument has no element. It should be rank 2.");
        if (dimension2Length == 0)
            throw new IllegalArgumentException("Argument first element has 0 element. It should be rank 2.");
        return new int[]{dimension1Length, dimension2Length};
    }

    /**
     * This function is used to check the length of array and length of its first element.
     *
     * @return int[] used to store dimension
     * @throws IllegalArgumentException if either the length of array or its first element or the first element of its first \
     *                                  element is zero.
     */
    private static int @NotNull [] checkRank3D(int dimension1Length, int dimension2Length, int dimension3Length) {
        if (dimension1Length == 0)
            throw new IllegalArgumentException("Argument has no element. It should be rank 3.");
        if (dimension2Length == 0)
            throw new IllegalArgumentException("Argument first element has 0 element. It should be rank 3.");
        if (dimension3Length == 0)
            throw new IllegalArgumentException(
                    "Argument first element of first dimension has 0 element. It should be rank 3.");
        return new int[]{dimension1Length, dimension2Length, dimension3Length};
    }
}


