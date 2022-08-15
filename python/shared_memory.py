import numpy as np
import ctypes
import os

# CAN BE CHANGED BY USER
LIBRARY_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)),"..","shared_memory.dll")
# END


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

lib = np.ctypeslib.load_library("shared_memory.dll",LIBRARY_PATH)

c_library_set_shared_memory_data = lib.set_shared_memory_data
c_library_delete_shared_memory = lib.delete_shared_memory
c_library_get_shared_memory_data = lib.get_shared_memory_flatten_data
c_library_get_shared_memory_flatten_length = lib.get_shared_memory_flatten_length
c_library_set_shared_memory_path = lib.set_shared_memory_path
c_library_get_shared_memory_dimensions = lib.get_shared_memory_dimensions
c_library_get_shared_memory_rank = lib.get_shared_memory_rank

c_library_get_shared_memory_rank.argtypes = []
c_library_get_shared_memory_rank.restype = np.intc
c_library_get_shared_memory_flatten_length.argtypes = []
c_library_get_shared_memory_flatten_length.restype = np.longlong
c_library_get_shared_memory_dimensions.argtypes = [np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_dimensions.restype = np.intc
c_library_get_shared_memory_data.argtypes = [np.ctypeslib.ndpointer(np.double,flags='aligned,C_CONTIGUOUS,WRITEABLE')]
c_library_get_shared_memory_data.restype = np.intc
c_library_delete_shared_memory.argtypes = []
c_library_delete_shared_memory.restype = np.intc
c_library_set_shared_memory_path.argtypes = [ctypes.c_char_p]
c_library_set_shared_memory_path.restype = np.intc
c_library_set_shared_memory_data.argtypes = [np.ctypeslib.ndpointer(np.double,flags='aligned,C_CONTIGUOUS'),np.ctypeslib.ndpointer(np.ulonglong,flags='aligned,C_CONTIGUOUS'),ctypes.c_uint64]
c_library_set_shared_memory_data.restype = np.intc

def column_major_to_row_major(data:np.ndarray)->np.ndarray:
    new_dimensions1 = np.flip(data.shape)
    new_dimensions2 = np.arange(len(new_dimensions1))
    if len(new_dimensions1) > 1:
        new_dimensions2[-2:]=new_dimensions2[[-1,-2]]
    return np.transpose(np.reshape(data,new_dimensions1,order='C'),new_dimensions2)

def row_major_to_column_major(data:np.ndarray)->np.ndarray:
    dimensions=data.shape
    new_dimensions1=np.arange(len(dimensions))
    new_dimensions2=np.flip(dimensions)
    
    if len(dimensions) > 1:
        new_dimensions1[[-2,-1]]=new_dimensions1[[-1,-2]]
        new_dimensions2[:2]=new_dimensions2[[1,0]]

    return np.reshape(np.transpose(data,new_dimensions1),new_dimensions2,order='F')

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

def get_shared_memory_rank()->int:
    return check_library_error(c_library_get_shared_memory_rank())

def delete_shared_memory()->int:
    return check_library_error(c_library_delete_shared_memory())

def get_shared_memory_flatten_length()->int:
    return check_library_error(c_library_get_shared_memory_flatten_length())

def get_shared_memory_flatten_data()->np.ndarray:
    output = np.repeat(0,c_library_get_shared_memory_flatten_length())

    output = output.astype(np.double, copy=False)
    check_library_error(c_library_get_shared_memory_data(output))
    return output


def get_shared_memory_data()->np.ndarray:
    output = np.repeat(0,c_library_get_shared_memory_flatten_length())

    output = output.astype(np.double, copy=False)
    check_library_error(c_library_get_shared_memory_data(output))

    return column_major_to_row_major(np.reshape(output,get_shared_memory_dimensions(),order='C'))
    

def set_shared_memory_data(data:np.ndarray):
    if type(data) != np.ndarray:
        raise TypeError("Data should be a numpy array")
    data=row_major_to_column_major(data)
    
    if data.dtype != np.double:
        print("[Warnning] Array type should be double. Converted automatically.")
        data=data.astype(np.double,copy=False)
    temp_rank = data.ndim
    temp_dims = np.array(data.shape,dtype=np.uint64)
    
    check_library_error(c_library_set_shared_memory_data(data,temp_dims,temp_rank))
    
