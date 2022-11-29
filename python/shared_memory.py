"""
Title: SharedMemory
Summary: With this package you can share data with other interfaces exist in the github repository in memory.

Author: Benyamin Izadpanah
Copyright: Benyamin Izadpanah
Github Repository: https://github.com/ben-izd/shared_memory
Start Date: 2022-8
Last date modified: 2022-11
Version used for testing: 3.11

Requirements:
    - numpy module
    - LIBRARY_PATH should be set as shared library path (by default it will follow project structure and find the library).
        The library code and its compiled version is available at github repository.
"""

import numpy as np
import ctypes
from typing import Union,Tuple

# CAN BE CHANGED BY USER
import os
LIBRARY_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "shared_memory.dll")
# END

__all__ = ['set_shared_memory_path'
           , 'get_shared_memory_dimensions'
           , 'get_shared_memory_data_type'
           , 'get_shared_memory_rank'
           , 'delete_shared_memory'
           , 'get_shared_memory_flatten_length'
           , 'get_shared_memory_flatten_data'
           , 'get_shared_memory_data'
           , 'set_shared_memory_data'
           , 'SharedMemoryLibraryError']


lib: np.ctypeslib.ctypes.cdll = np.ctypeslib.load_library("shared_memory", LIBRARY_PATH)

# Access native functions
_c_library_set_shared_memory_data_complex_float32 = lib.set_shared_memory_data_complex_float32
_c_library_set_shared_memory_data_complex_float64 = lib.set_shared_memory_data_complex_float64

_c_library_set_shared_memory_string = lib.set_shared_memory_string
_c_library_get_shared_memory_string = lib.get_shared_memory_string
_c_library_set_shared_memory_data_float32 = lib.set_shared_memory_data_float32
_c_library_set_shared_memory_data_float64 = lib.set_shared_memory_data_float64
_c_library_set_shared_memory_data_signed_8 = lib.set_shared_memory_data_signed_8
_c_library_set_shared_memory_data_signed_16 = lib.set_shared_memory_data_signed_16
_c_library_set_shared_memory_data_signed_32 = lib.set_shared_memory_data_signed_32
_c_library_set_shared_memory_data_signed_64 = lib.set_shared_memory_data_signed_64
_c_library_set_shared_memory_data_unsigned_8 = lib.set_shared_memory_data_unsigned_8
_c_library_set_shared_memory_data_unsigned_16 = lib.set_shared_memory_data_unsigned_16
_c_library_set_shared_memory_data_unsigned_32 = lib.set_shared_memory_data_unsigned_32
_c_library_set_shared_memory_data_unsigned_64 = lib.set_shared_memory_data_unsigned_64

_c_library_get_shared_memory_flatten_data_float32 = lib.get_shared_memory_flatten_data_float32
_c_library_get_shared_memory_flatten_data_float64 = lib.get_shared_memory_flatten_data_float64

_c_library_get_shared_memory_flatten_data_signed_8 = lib.get_shared_memory_flatten_data_signed_8
_c_library_get_shared_memory_flatten_data_signed_16 = lib.get_shared_memory_flatten_data_signed_16
_c_library_get_shared_memory_flatten_data_signed_32 = lib.get_shared_memory_flatten_data_signed_32
_c_library_get_shared_memory_flatten_data_signed_64 = lib.get_shared_memory_flatten_data_signed_64
_c_library_get_shared_memory_flatten_data_unsigned_8 = lib.get_shared_memory_flatten_data_unsigned_8
_c_library_get_shared_memory_flatten_data_unsigned_16 = lib.get_shared_memory_flatten_data_unsigned_16
_c_library_get_shared_memory_flatten_data_unsigned_32 = lib.get_shared_memory_flatten_data_unsigned_32
_c_library_get_shared_memory_flatten_data_unsigned_64 = lib.get_shared_memory_flatten_data_unsigned_64

_c_library_get_shared_memory_data_type = lib.get_shared_memory_data_type
_c_library_delete_shared_memory = lib.delete_shared_memory
_c_library_get_shared_memory_flatten_length = lib.get_shared_memory_flatten_length
_c_library_set_shared_memory_path = lib.set_shared_memory_path
_c_library_get_shared_memory_dimensions = lib.get_shared_memory_dimensions
_c_library_get_shared_memory_rank = lib.get_shared_memory_rank

# Declare argument and return type
_c_library_get_shared_memory_rank.argtypes = []
_c_library_get_shared_memory_rank.restype = np.intc
_c_library_get_shared_memory_data_type.argtypes = []
_c_library_get_shared_memory_data_type.restype = np.intc
_c_library_get_shared_memory_flatten_length.argtypes = []
_c_library_get_shared_memory_flatten_length.restype = np.longlong

_c_library_get_shared_memory_dimensions.argtypes = [
    np.ctypeslib.ndpointer(np.ulonglong, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_dimensions.restype = np.intc

_c_library_delete_shared_memory.argtypes = []
_c_library_delete_shared_memory.restype = np.intc
_c_library_set_shared_memory_path.argtypes = [ctypes.c_char_p]
_c_library_set_shared_memory_path.restype = np.intc

_c_library_get_shared_memory_string.argtypes = [ctypes.c_char_p]
_c_library_get_shared_memory_string.restype = np.intc

_c_library_set_shared_memory_string.argtypes = [ctypes.c_char_p]
_c_library_set_shared_memory_string.restype = np.intc

_c_library_set_shared_memory_data_unsigned_8.argtypes = [np.ctypeslib.ndpointer(np.uint8, flags='aligned,C_CONTIGUOUS'),
                                                        np.ctypeslib.ndpointer(np.ulonglong,
                                                                               flags='aligned,C_CONTIGUOUS'),
                                                        ctypes.c_uint64]
_c_library_set_shared_memory_data_unsigned_8.restype = np.intc

_c_library_set_shared_memory_data_unsigned_16.argtypes = [
    np.ctypeslib.ndpointer(np.uint16, flags='aligned,C_CONTIGUOUS'),
    np.ctypeslib.ndpointer(np.ulonglong, flags='aligned,C_CONTIGUOUS'), ctypes.c_uint64]
_c_library_set_shared_memory_data_unsigned_16.restype = np.intc

_c_library_set_shared_memory_data_unsigned_32.argtypes = [
    np.ctypeslib.ndpointer(np.uint32, flags='aligned,C_CONTIGUOUS'),
    np.ctypeslib.ndpointer(np.ulonglong, flags='aligned,C_CONTIGUOUS'), ctypes.c_uint64]
_c_library_set_shared_memory_data_unsigned_32.restype = np.intc

_c_library_set_shared_memory_data_unsigned_64.argtypes = [
    np.ctypeslib.ndpointer(np.uint64, flags='aligned,C_CONTIGUOUS'),
    np.ctypeslib.ndpointer(np.ulonglong, flags='aligned,C_CONTIGUOUS'), ctypes.c_uint64]
_c_library_set_shared_memory_data_unsigned_64.restype = np.intc

_c_library_set_shared_memory_data_signed_8.argtypes = [np.ctypeslib.ndpointer(np.int8, flags='aligned,C_CONTIGUOUS'),
                                                      np.ctypeslib.ndpointer(np.ulonglong,
                                                                             flags='aligned,C_CONTIGUOUS'),
                                                      ctypes.c_uint64]
_c_library_set_shared_memory_data_signed_8.restype = np.intc

_c_library_set_shared_memory_data_signed_16.argtypes = [np.ctypeslib.ndpointer(np.int16, flags='aligned,C_CONTIGUOUS'),
                                                       np.ctypeslib.ndpointer(np.ulonglong,
                                                                              flags='aligned,C_CONTIGUOUS'),
                                                       ctypes.c_uint64]
_c_library_set_shared_memory_data_signed_16.restype = np.intc

_c_library_set_shared_memory_data_signed_32.argtypes = [np.ctypeslib.ndpointer(np.int32, flags='aligned,C_CONTIGUOUS'),
                                                       np.ctypeslib.ndpointer(np.ulonglong,
                                                                              flags='aligned,C_CONTIGUOUS'),
                                                       ctypes.c_uint64]
_c_library_set_shared_memory_data_signed_32.restype = np.intc

_c_library_set_shared_memory_data_signed_64.argtypes = [np.ctypeslib.ndpointer(np.int64, flags='aligned,C_CONTIGUOUS'),
                                                       np.ctypeslib.ndpointer(np.ulonglong,
                                                                              flags='aligned,C_CONTIGUOUS'),
                                                       ctypes.c_uint64]
_c_library_set_shared_memory_data_signed_64.restype = np.intc

_c_library_set_shared_memory_data_float32.argtypes = [np.ctypeslib.ndpointer(np.float32, flags='aligned,C_CONTIGUOUS'),
                                                     np.ctypeslib.ndpointer(np.ulonglong, flags='aligned,C_CONTIGUOUS'),
                                                     ctypes.c_uint64]
_c_library_set_shared_memory_data_float32.restype = np.intc

_c_library_set_shared_memory_data_float64.argtypes = [np.ctypeslib.ndpointer(np.float64, flags='aligned,C_CONTIGUOUS'),
                                                     np.ctypeslib.ndpointer(np.ulonglong, flags='aligned,C_CONTIGUOUS'),
                                                     ctypes.c_uint64]
_c_library_set_shared_memory_data_float64.restype = np.intc

_c_library_set_shared_memory_data_complex_float32.argtypes = [
    np.ctypeslib.ndpointer(np.float32, flags='aligned,C_CONTIGUOUS'),
    np.ctypeslib.ndpointer(np.ulonglong, flags='aligned,C_CONTIGUOUS'), ctypes.c_uint64]
_c_library_set_shared_memory_data_complex_float32.restype = np.intc

_c_library_set_shared_memory_data_complex_float64.argtypes = [
    np.ctypeslib.ndpointer(np.float64, flags='aligned,C_CONTIGUOUS'),
    np.ctypeslib.ndpointer(np.ulonglong, flags='aligned,C_CONTIGUOUS'), ctypes.c_uint64]
_c_library_set_shared_memory_data_complex_float64.restype = np.intc

_c_library_get_shared_memory_flatten_data_unsigned_8.argtypes = [
    np.ctypeslib.ndpointer(np.uint8, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_unsigned_8.restype = np.intc

_c_library_get_shared_memory_flatten_data_unsigned_16.argtypes = [
    np.ctypeslib.ndpointer(np.uint16, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_unsigned_16.restype = np.intc

_c_library_get_shared_memory_flatten_data_unsigned_32.argtypes = [
    np.ctypeslib.ndpointer(np.uint32, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_unsigned_32.restype = np.intc

_c_library_get_shared_memory_flatten_data_unsigned_64.argtypes = [
    np.ctypeslib.ndpointer(np.uint64, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_unsigned_64.restype = np.intc

_c_library_get_shared_memory_flatten_data_signed_8.argtypes = [
    np.ctypeslib.ndpointer(np.int8, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_signed_8.restype = np.intc

_c_library_get_shared_memory_flatten_data_signed_16.argtypes = [
    np.ctypeslib.ndpointer(np.int16, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_signed_16.restype = np.intc

_c_library_get_shared_memory_flatten_data_signed_32.argtypes = [
    np.ctypeslib.ndpointer(np.int32, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_signed_32.restype = np.intc

_c_library_get_shared_memory_flatten_data_signed_64.argtypes = [
    np.ctypeslib.ndpointer(np.int64, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_signed_64.restype = np.intc

_c_library_get_shared_memory_flatten_data_float32.argtypes = [
    np.ctypeslib.ndpointer(np.float32, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_float32.restype = np.intc

_c_library_get_shared_memory_flatten_data_float64.argtypes = [
    np.ctypeslib.ndpointer(np.float64, flags='aligned,C_CONTIGUOUS,WRITEABLE')]
_c_library_get_shared_memory_flatten_data_float64.restype = np.intc


class SharedMemoryLibraryError(Exception):
    """
    Used to show the proper error based on the value.
    Error values reflect values written in Rust library.
    """

    def __init__(self, error_code: int):
        """
        :param error_code: value of the error. Should be negative.
        """
        self.error_code = error_code
        message: str = ""
        if error_code == -1:
            message = "Library path is not set"
        elif error_code == -2:
            message = "Error in accessing shared file (probably file does not exist)"
        elif error_code == -3:
            message = "Can't read library_path from memory"
        elif error_code == -4:
            message = "Can't create shared memory"
        elif error_code == -5:
            message = "New Rank doesn't match the previous rank"
        else:
            raise ValueError("Invalid error code is given: " + str(error_code))
        super().__init__(message)


def _check_library_error(value: int):
    """
    This function is used to check the return type of all the external functions calls.

    :param value: If value is negative, it's error otherwise should be return
    :return: If value is negative, an exception is raised, otherwise the value will be returned
    """
    if value >= 0:
        return value
    else:
        raise SharedMemoryLibraryError(value)


def _column_major_to_row_major(data: np.ndarray) -> np.ndarray:
    """
    This function is used to transform the data retrieved from shared memory.

    :param data: An array in any dimension with supported types.
    :return: return the corresponding array but with a changed layout implemented in python
    """

    new_dimensions1: np.ndarray = np.flip(data.shape)
    new_dimensions2: np.ndarray = np.arange(len(new_dimensions1))

    if len(new_dimensions1) > 1:
        new_dimensions2[-2:] = new_dimensions2[[-1, -2]]

    return np.transpose(np.reshape(data, new_dimensions1, order='C'), new_dimensions2)


def _row_major_to_column_major(data: np.ndarray) -> np.ndarray:
    """
    This function is used before sending the data to be stored in shared memory.

    :param data: An array in any dimension with supported types.
    :return: return the corresponding array but with a changed layout implemented in python
    """

    # dimensions is Tuple of int
    dimensions: Tuple = data.shape

    new_dimensions1: np.ndarray = np.arange(len(dimensions))
    new_dimensions2: np.ndarray = np.flip(dimensions)

    if len(dimensions) > 1:
        new_dimensions1[[-2, -1]] = new_dimensions1[[-1, -2]]
        new_dimensions2[:2] = new_dimensions2[[1, 0]]

    return np.ascontiguousarray(np.reshape(np.transpose(data, new_dimensions1), new_dimensions2, 'C'))


def set_shared_memory_path(path: str) -> int:
    """
    Set the path used to access the shared memory.

    :param path: A valid path used to access the shared memory. Will be encoded as UTF-8 before calling the function
    :return: An int is returned.
    :raise TypeError if path is not of type str
    :raise SharedMemoryLibraryError if the operation was unsuccessful.
    """
    if type(path) == str:
        return _check_library_error(_c_library_set_shared_memory_path(path.encode('utf-8')))
    else:
        raise TypeError(f'Path should be of type str. Type "{type(path)}" is given.')


def get_shared_memory_dimensions() -> np.ndarray:
    """
    Get the shared memory dimension. Will raise SharedMemoryLibraryError if the operation was no successful.

    :return: The dimension of store data in shared memory.
    """
    output: np.ndarray = np.repeat(np.array(0, dtype=np.uint64), _c_library_get_shared_memory_rank())
    _check_library_error(_c_library_get_shared_memory_dimensions(output))
    return output


def get_shared_memory_data_type() -> type:
    """
    Will raise SharedMemoryLibraryError if the operation was no successful.

    :return: Return the shared memory data type that is either np.TYPE or str
    """

    return [np.uint8, np.uint16, np.uint32, np.uint64, np.int8, np.int16, np.int32, np.int64, np.float32, np.float64,
            np.complex64, np.complex128, str][_check_library_error(_c_library_get_shared_memory_data_type())]


def get_shared_memory_rank() -> int:
    """
    Will raise SharedMemoryLibraryError if the operation was no successful.

    :return: Return the shared memory data rank
    """

    return _check_library_error(_c_library_get_shared_memory_rank())


def delete_shared_memory():
    """
    Unload the data from memory if it can connect to it, otherwise will remove the specified file.

    Will raise SharedMemoryLibraryError if the operation was no successful.
    """

    _check_library_error(_c_library_delete_shared_memory())


def get_shared_memory_flatten_length() -> int:
    """
    Flatten length is the product of dimensions. Will raise SharedMemoryLibraryError if the operation was no successful.

    :return: Return the shared memory flatten data length
    """
    return _check_library_error(_c_library_get_shared_memory_flatten_length())


def get_shared_memory_flatten_data() -> Union[np.ndarray, str]:
    """
    Will raise SharedMemoryLibraryError if the operation was no successful.

    :return: Return the shared memory flatten data. Output type is either a Numpy array or a string
    """

    shared_memory_type: type = get_shared_memory_data_type()

    if shared_memory_type == str:
        output: bytes = b' ' * get_shared_memory_flatten_length()
        _check_library_error(_c_library_get_shared_memory_string(output))
        return output.decode('utf-8')

    output: np.ndarray = np.repeat(np.array(0, dtype=shared_memory_type, order='C'), get_shared_memory_flatten_length())

    if shared_memory_type == np.uint8:
        _check_library_error(_c_library_get_shared_memory_flatten_data_unsigned_8(output))
    elif shared_memory_type == np.uint16:
        _check_library_error(_c_library_get_shared_memory_flatten_data_unsigned_16(output))
    elif shared_memory_type == np.uint32:
        _check_library_error(_c_library_get_shared_memory_flatten_data_unsigned_32(output))
    elif shared_memory_type == np.uint64:
        _check_library_error(_c_library_get_shared_memory_flatten_data_unsigned_64(output))
    elif shared_memory_type == np.int8:
        _check_library_error(_c_library_get_shared_memory_flatten_data_signed_8(output))
    elif shared_memory_type == np.int16:
        _check_library_error(_c_library_get_shared_memory_flatten_data_signed_16(output))
    elif shared_memory_type == np.int32:
        _check_library_error(_c_library_get_shared_memory_flatten_data_signed_32(output))
    elif shared_memory_type == np.int64:
        _check_library_error(_c_library_get_shared_memory_flatten_data_signed_64(output))
    elif shared_memory_type == np.float32:
        _check_library_error(_c_library_get_shared_memory_flatten_data_float32(output))
    elif shared_memory_type == np.float64:
        _check_library_error(_c_library_get_shared_memory_flatten_data_float64(output))
    elif shared_memory_type == np.complex64:
        _check_library_error(_c_library_get_shared_memory_flatten_data_float32(output.view(np.float32)))
    elif shared_memory_type == np.complex128:
        _check_library_error(_c_library_get_shared_memory_flatten_data_float64(output.view(np.float64)))
    else:
        raise ValueError(f'Retrieving type "{shared_memory_type}" is not implemented in Python.')

    return output


def get_shared_memory_data() -> Union[np.ndarray, str]:
    """
    Will raise SharedMemoryLibraryError if the operation was no successful.

    :return: either string or the data store in the shared memory in row-major layout
    """

    output: Union[np.ndarray,str] = get_shared_memory_flatten_data()

    if get_shared_memory_data_type() == str:
        return output

    return _column_major_to_row_major(np.reshape(output, get_shared_memory_dimensions(), order='C'))


def set_shared_memory_data(data: Union[np.ndarray, str]):
    """
    Array with float16 type will be converted to float32.
    Will raise SharedMemoryLibraryError if the operation was no successful.

    :param data: data to be stored in shared memory. It can be in any dimension with supported types or a string.
    """
    
    input_data_type: type = type(data)
    
    if input_data_type == str:
        _check_library_error(_c_library_set_shared_memory_string(data.encode('utf-8')))
        return

    # Convert list of elements to np.array
    if input_data_type == list:
        data = np.asarray(data, order='C')
        input_data_type = type(data)

    if input_data_type != np.ndarray:
        raise TypeError("Data should be a numpy array")

    if not data.flags['C_CONTIGUOUS']:
        data = np.ascontiguousarray(data)

    if not data.flags['ALIGNED']:
        data.setflags(align=True)

    data: np.ndarray = _row_major_to_column_major(data)

    data_type: type = data.dtype
    temp_rank: int = data.ndim
    temp_dims: np.ndarray = np.array(data.shape, dtype=np.uint64, order='C')

    if data_type == np.uint8:
        _check_library_error(_c_library_set_shared_memory_data_unsigned_8(data, temp_dims, temp_rank))
    elif data_type == np.uint16:
        _check_library_error(_c_library_set_shared_memory_data_unsigned_16(data, temp_dims, temp_rank))
    elif data_type == np.uint32:
        _check_library_error(_c_library_set_shared_memory_data_unsigned_32(data, temp_dims, temp_rank))
    elif data_type == np.uint64:
        _check_library_error(_c_library_set_shared_memory_data_unsigned_64(data, temp_dims, temp_rank))
    elif data_type == np.int8:
        _check_library_error(_c_library_set_shared_memory_data_signed_8(data, temp_dims, temp_rank))
    elif data_type == np.int16:
        _check_library_error(_c_library_set_shared_memory_data_signed_16(data, temp_dims, temp_rank))
    elif data_type == np.int32:
        _check_library_error(_c_library_set_shared_memory_data_signed_32(data, temp_dims, temp_rank))
    elif data_type == np.int64:
        _check_library_error(_c_library_set_shared_memory_data_signed_64(data, temp_dims, temp_rank))
    elif data_type == np.float32:
        _check_library_error(_c_library_set_shared_memory_data_float32(data, temp_dims, temp_rank))
    elif data_type == np.float64:
        _check_library_error(_c_library_set_shared_memory_data_float64(data, temp_dims, temp_rank))
    elif data_type == np.complex64:
        _check_library_error(
            _c_library_set_shared_memory_data_complex_float32(data.view(np.float32), temp_dims, temp_rank))
    elif data_type == np.complex128:
        _check_library_error(
            _c_library_set_shared_memory_data_complex_float64(data.view(np.float64), temp_dims, temp_rank))

    # Convert float16 array to float32 array
    elif data_type == np.float16:
        print("[SharedMemory][INFO] float16 is not supported. Automatically converted to float32.")
        converted_data = data.astype(np.float32, copy=True)
        set_shared_memory_data(converted_data)

    # Raise error if type is not supported
    else:
        raise TypeError(f'Type "{data_type}" is not suppored.')
