import numpy as np
import ctypes
import os

# CAN BE CHANGED BY USER
LIBRARY_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)),"..","shared_memory.dll")
# END



lib = np.ctypeslib.load_library("shared_memory.dll",LIBRARY_PATH)

c_library_set_shared_memory_data_complex_float32 = lib.set_shared_memory_data_complex_float32
c_library_set_shared_memory_data_complex_float64 = lib.set_shared_memory_data_complex_float64

c_library_set_shared_memory_data_float32 = lib.set_shared_memory_data_float32
c_library_set_shared_memory_data_float64 = lib.set_shared_memory_data_float64
c_library_set_shared_memory_data_signed_8 = lib.set_shared_memory_data_signed_8
c_library_set_shared_memory_data_signed_16 = lib.set_shared_memory_data_signed_16
c_library_set_shared_memory_data_signed_32 = lib.set_shared_memory_data_signed_32
c_library_set_shared_memory_data_signed_64 = lib.set_shared_memory_data_signed_64
c_library_set_shared_memory_data_unsigned_8 = lib.set_shared_memory_data_unsigned_8
c_library_set_shared_memory_data_unsigned_16 = lib.set_shared_memory_data_unsigned_16
c_library_set_shared_memory_data_unsigned_32 = lib.set_shared_memory_data_unsigned_32
c_library_set_shared_memory_data_unsigned_64 = lib.set_shared_memory_data_unsigned_64


c_library_get_shared_memory_flatten_data_float32 = lib.get_shared_memory_flatten_data_float32
c_library_get_shared_memory_flatten_data_float64 = lib.get_shared_memory_flatten_data_float64

c_library_get_shared_memory_flatten_data_signed_8 = lib.get_shared_memory_flatten_data_signed_8
c_library_get_shared_memory_flatten_data_signed_16 = lib.get_shared_memory_flatten_data_signed_16
c_library_get_shared_memory_flatten_data_signed_32 = lib.get_shared_memory_flatten_data_signed_32
c_library_get_shared_memory_flatten_data_signed_64 = lib.get_shared_memory_flatten_data_signed_64
c_library_get_shared_memory_flatten_data_unsigned_8 = lib.get_shared_memory_flatten_data_unsigned_8
c_library_get_shared_memory_flatten_data_unsigned_16 = lib.get_shared_memory_flatten_data_unsigned_16
c_library_get_shared_memory_flatten_data_unsigned_32 = lib.get_shared_memory_flatten_data_unsigned_32
c_library_get_shared_memory_flatten_data_unsigned_64 = lib.get_shared_memory_flatten_data_unsigned_64

c_library_get_shared_memory_data_type = lib.get_shared_memory_data_type
c_library_delete_shared_memory = lib.delete_shared_memory
c_library_get_shared_memory_flatten_length = lib.get_shared_memory_flatten_length
c_library_set_shared_memory_path = lib.set_shared_memory_path
c_library_get_shared_memory_dimensions = lib.get_shared_memory_dimensions
c_library_get_shared_memory_rank = lib.get_shared_memory_rank

c_library_get_shared_memory_rank.argtypes = []
c_library_get_shared_memory_rank.restype = np.intc
c_library_get_shared_memory_data_type.argtypes = []
c_library_get_shared_memory_data_type.restype = np.ubyte
c_library_get_shared_memory_flatten_length.argtypes = []
c_library_get_shared_memory_flatten_length.restype = np.longlong

c_library_get_shared_memory_dimensions.argtypes = [np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_dimensions.restype = np.intc

c_library_delete_shared_memory.argtypes = []
c_library_delete_shared_memory.restype = np.intc
c_library_set_shared_memory_path.argtypes = [ctypes.c_char_p]
c_library_set_shared_memory_path.restype = np.intc


c_library_set_shared_memory_data_unsigned_8.argtypes = [np.ctypeslib.ndpointer(np.uint8,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_unsigned_8.restype = np.intc

c_library_set_shared_memory_data_unsigned_16.argtypes = [np.ctypeslib.ndpointer(np.uint16,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_unsigned_16.restype = np.intc

c_library_set_shared_memory_data_unsigned_32.argtypes = [np.ctypeslib.ndpointer(np.uint32,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_unsigned_32.restype = np.intc

c_library_set_shared_memory_data_unsigned_64.argtypes = [np.ctypeslib.ndpointer(np.uint64,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_unsigned_64.restype = np.intc

c_library_set_shared_memory_data_signed_8.argtypes = [np.ctypeslib.ndpointer(np.int8,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_signed_8.restype = np.intc

c_library_set_shared_memory_data_signed_16.argtypes = [np.ctypeslib.ndpointer(np.int16,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_signed_16.restype = np.intc

c_library_set_shared_memory_data_signed_32.argtypes = [np.ctypeslib.ndpointer(np.int32,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_signed_32.restype = np.intc

c_library_set_shared_memory_data_signed_64.argtypes = [np.ctypeslib.ndpointer(np.int64,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_signed_64.restype = np.intc

c_library_set_shared_memory_data_float32.argtypes = [np.ctypeslib.ndpointer(np.float32,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_float32.restype = np.intc

c_library_set_shared_memory_data_float64.argtypes = [np.ctypeslib.ndpointer(np.float64,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_float64.restype = np.intc


c_library_set_shared_memory_data_complex_float32.argtypes = [np.ctypeslib.ndpointer(np.float32,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_complex_float32.restype = np.intc

c_library_set_shared_memory_data_complex_float64.argtypes = [np.ctypeslib.ndpointer(np.float64,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data_complex_float64.restype = np.intc

#  -------------------------------------------

c_library_get_shared_memory_flatten_data_unsigned_8.argtypes = [np.ctypeslib.ndpointer(np.uint8,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_unsigned_8.restype = np.intc

c_library_get_shared_memory_flatten_data_unsigned_16.argtypes = [np.ctypeslib.ndpointer(np.uint16,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_unsigned_16.restype = np.intc

c_library_get_shared_memory_flatten_data_unsigned_32.argtypes = [np.ctypeslib.ndpointer(np.uint32,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_unsigned_32.restype = np.intc

c_library_get_shared_memory_flatten_data_unsigned_64.argtypes = [np.ctypeslib.ndpointer(np.uint64,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_unsigned_64.restype = np.intc

c_library_get_shared_memory_flatten_data_signed_8.argtypes = [np.ctypeslib.ndpointer(np.int8,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_signed_8.restype = np.intc

c_library_get_shared_memory_flatten_data_signed_16.argtypes = [np.ctypeslib.ndpointer(np.int16,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_signed_16.restype = np.intc

c_library_get_shared_memory_flatten_data_signed_32.argtypes = [np.ctypeslib.ndpointer(np.int32,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_signed_32.restype = np.intc

c_library_get_shared_memory_flatten_data_signed_64.argtypes = [np.ctypeslib.ndpointer(np.int64,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_signed_64.restype = np.intc

c_library_get_shared_memory_flatten_data_float32.argtypes = [np.ctypeslib.ndpointer(np.float32,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_float32.restype = np.intc

c_library_get_shared_memory_flatten_data_float64.argtypes = [np.ctypeslib.ndpointer(np.float64,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_flatten_data_float64.restype = np.intc


class SharedMemoryLibraryError(Exception):
    def __init__(self,error_code:int):
        self.error_code = error_code
        message:str = ""
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
    # pass

def check_library_error(value:int):
    if value >= 0:
        return value
    else:
        raise SharedMemoryLibraryError(value)

def column_major_to_row_major(data:np.ndarray)->np.ndarray:
    # return np.ascontiguousarray(data)
    # return np.asanyarray(data,order='F')
    new_dimensions1 = np.flip(data.shape)
    new_dimensions2 = np.arange(len(new_dimensions1))
    if len(new_dimensions1) > 1:
        new_dimensions2[-2:]=new_dimensions2[[-1,-2]]
    return np.transpose(np.reshape(data,new_dimensions1,order='C'),new_dimensions2)

def row_major_to_column_major(data:np.ndarray)->np.ndarray:
    # # return np.asfortranarray(data)
    # converted_data = np.asarray(data,order='C')
    # return converted_data
    dimensions=data.shape
    new_dimensions1=np.arange(len(dimensions))
    new_dimensions2=np.flip(dimensions)
    
    if len(dimensions) > 1:
        new_dimensions1[[-2,-1]]=new_dimensions1[[-1,-2]]
        new_dimensions2[:2]=new_dimensions2[[1,0]]

    # return np.reshape(np.transpose(data,new_dimensions1),new_dimensions2,order='F')
    return np.reshape(np.transpose(data,new_dimensions1),new_dimensions2)

def set_shared_memory_path(path:str)->int:
    if type(path) == str:
        return c_library_set_shared_memory_path(path.encode('utf-8'))
    else:
        raise TypeError

def get_shared_memory_dimensions()->np.ndarray:
    output = np.repeat(0,c_library_get_shared_memory_rank())
    output = output.astype(np.uint64, copy=False)
    check_library_error(c_library_get_shared_memory_dimensions(output))
    return output

def get_shared_memory_data_type() -> type:
    return [np.uint8,np.uint16,np.uint32,np.uint64,np.int8,np.int16,np.int32,np.int64,np.float32,np.float64,np.complex64,np.complex128][check_library_error(c_library_get_shared_memory_data_type())]

def get_shared_memory_rank()->int:
    return check_library_error(c_library_get_shared_memory_rank())

def delete_shared_memory()->int:
    return check_library_error(c_library_delete_shared_memory())

def get_shared_memory_flatten_length()->int:
    return check_library_error(c_library_get_shared_memory_flatten_length())

def get_shared_memory_flatten_data()->np.ndarray:
    # output = np.repeat(0,c_library_get_shared_memory_flatten_length())
    shared_memory_type = get_shared_memory_data_type()
    # output = 

    # output = output.astype(np.double, copy=False)

    output = np.repeat(np.array(0,dtype=shared_memory_type,order='C'),get_shared_memory_flatten_length())

    if shared_memory_type == np.uint8:
        check_library_error(c_library_get_shared_memory_flatten_data_unsigned_8(output))
    elif shared_memory_type == np.uint16:
        check_library_error(c_library_get_shared_memory_flatten_data_unsigned_16(output))
    elif shared_memory_type == np.uint32:
        check_library_error(c_library_get_shared_memory_flatten_data_unsigned_32(output))
    elif shared_memory_type == np.uint64:
        check_library_error(c_library_get_shared_memory_flatten_data_unsigned_64(output))
    elif shared_memory_type == np.int8:
        check_library_error(c_library_get_shared_memory_flatten_data_signed_8(output))
    elif shared_memory_type == np.int16:
        check_library_error(c_library_get_shared_memory_flatten_data_signed_16(output))
    elif shared_memory_type == np.int32:
        check_library_error(c_library_get_shared_memory_flatten_data_signed_32(output))
    elif shared_memory_type == np.int64:
        check_library_error(c_library_get_shared_memory_flatten_data_signed_64(output))
    elif shared_memory_type == np.float32:
        check_library_error(c_library_get_shared_memory_flatten_data_float32(output))
    elif shared_memory_type == np.float64:
        check_library_error(c_library_get_shared_memory_flatten_data_float64(output))
    elif shared_memory_type == np.complex64:
        check_library_error(c_library_get_shared_memory_flatten_data_float32(output.view(np.float32)))        
    elif shared_memory_type == np.complex128:
        check_library_error(c_library_get_shared_memory_flatten_data_float64(output.view(np.float64)))
    else:
        raise ValueError(f'Type {shared_memory_type} has no interface in get_shared_memory_flatten_data function.')
    
    return output


def get_shared_memory_data()->np.ndarray:
    output = get_shared_memory_flatten_data()

    return column_major_to_row_major(np.reshape(output,get_shared_memory_dimensions(),order='C'))
    

def set_shared_memory_data(data:np.ndarray):

    if type(data) == list:
        data = np.array(data,order='C')
        data = np.asarray(data)

    if not data.flags['C_CONTIGUOUS']:
        data = np.ascontiguousarray(data)

    if not data.flags['ALIGNED']:
        data.setflags(align=True)

    if type(data) != np.ndarray:
        raise TypeError("Data should be a numpy array")
    # print('before: ',data)
    data=row_major_to_column_major(data)
    # print('after: ',data)
    data_type = data.dtype
    temp_rank = data.ndim
    temp_dims = np.array(data.shape,dtype=np.uint64,order='C')
    
    if data_type == np.uint8:
        check_library_error(c_library_set_shared_memory_data_unsigned_8(data,temp_dims,temp_rank))
    elif data_type == np.uint16:
        check_library_error(c_library_set_shared_memory_data_unsigned_16(data,temp_dims,temp_rank))
    elif data_type == np.uint32:
        check_library_error(c_library_set_shared_memory_data_unsigned_32(data,temp_dims,temp_rank))
    elif data_type == np.uint64:
        check_library_error(c_library_set_shared_memory_data_unsigned_64(data,temp_dims,temp_rank))
    elif data_type == np.int8:
        check_library_error(c_library_set_shared_memory_data_signed_8(data,temp_dims,temp_rank))
    elif data_type == np.int16:
        check_library_error(c_library_set_shared_memory_data_signed_16(data,temp_dims,temp_rank))
    elif data_type == np.int32:
        check_library_error(c_library_set_shared_memory_data_signed_32(data,temp_dims,temp_rank))
    elif data_type == np.int64:
        check_library_error(c_library_set_shared_memory_data_signed_64(data,temp_dims,temp_rank))
    elif data_type == np.float32:
        check_library_error(c_library_set_shared_memory_data_float32(data,temp_dims,temp_rank))
    elif data_type == np.float64:
        check_library_error(c_library_set_shared_memory_data_float64(data,temp_dims,temp_rank))
    elif data_type == np.complex64:
        check_library_error(c_library_set_shared_memory_data_complex_float32(data.view(np.float32),temp_dims,temp_rank))
    elif data_type == np.complex128:
        check_library_error(c_library_set_shared_memory_data_complex_float64(data.view(np.float64),temp_dims,temp_rank))

    # convert
    elif data_type == np.float16:
        print("float16 is not supported. Automatically converted to float32.")
        converted_data= data.astype(np.float32,copy=True)
        set_shared_memory_data(converted_data)

    # error
    else:
        raise TypeError(f'Type "{data_type}" is not suppored.')
    
