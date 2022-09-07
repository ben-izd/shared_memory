import sys
import time
import numpy as np
import unittest
import os.path
# import logging

# import a single python file from your downloaded path
import sys
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)),"..","..","python"))
from shared_memory import *

data_path = os.path.join(os.path.dirname(os.path.realpath(__file__)),"integeration_test_data")
counter_path = os.path.join(os.path.dirname(os.path.realpath(__file__)),"integeration_test_counter")
number_of_software = 4
try:
    if len(sys.argv) > 1:
        number_of_software = int(sys.argv[1])
        print(f'number_of_software={number_of_software};')
except:
    pass


# def log_my_message(text:str):
#     with open(r"D:\projects\Mathematica\community\31. shared_memory\test-framework\integeration\log.txt",'a') as f:
#         f.write(text+"\n")

# read counter_path shared memory
def get_counter() -> int:
    set_shared_memory_path(counter_path)
    return get_shared_memory_data()[0]

# add one to the counter_path shared memory
def increment_counter():
    temp=get_counter()
    set_shared_memory_data([temp+1])
    print(f"->{temp+1}")
    # log_my_message(f"[PYTHON] {temp}++\n")

def share_data(data:np.ndarray):
    set_shared_memory_path(data_path)
    set_shared_memory_data(data)
    # log_my_message("[PYTHON][SHARE] Dimensions: "+str(data.shape)+" - Type: "+str(data.dtype)+" - Data: "+array_to_string(data))

def array_to_string(data:np.ndarray) -> str:
    return np.array2string(data).replace('\n',';')

# recieve index - compared shared memory to the index
# get the shared memory data and resend to the memory

class Utilities1(unittest.TestCase):
    def setUp(self) -> None:
        PYTHON_TYPES = [np.uint8, np.uint16, np.uint32, np.uint64, np.int8, np.int16, np.int32, np.int64, np.float32, np.float64, np.complex64, np.complex128]

        datasets = []
        dataset_1= np.array([32, 46, 76, 12, 42])
        dataset_2 = np.array([[5, 9, 12],[43, 21, 36]])
        dataset_3 = np.array([[[60, 68, 44, 31],[109, 26, 25, 124]],[[88, 18, 48, 39],[52, 25, 87, 37]],[[14, 67, 98, 125],[80, 16, 22, 20]]])

        # convert our sample dataset to all the possible formats
        for dataset in (dataset_1,dataset_2,dataset_3):
            for type in PYTHON_TYPES:
                datasets.append(dataset.astype(type))
        self.datasets = datasets
        return super().setUp()


    def reshare(self,index:int):
        set_shared_memory_path(data_path)
        actual_dataset=get_shared_memory_data()
        expected_dataset=self.datasets[index]
        self.assertTrue(np.array_equal(expected_dataset,actual_dataset))
        # log_my_message(f"[PYTHON][CHECK] - {np.array_equal(expected_dataset,actual_dataset)} - Expected: {array_to_string(expected_dataset)} - Actual: {array_to_string(actual_dataset)}")
        set_shared_memory_data(actual_dataset)
        # log_my_message("[PYTHON][RE-SHARE] Dimensions: "+str(actual_dataset.shape)+" - Type: "+str(actual_dataset.dtype)+" - Data: "+array_to_string(actual_dataset))


    def test_sharing_or_resharing(self):
        # all supported types
        

        counter=get_counter()
        offset = counter%number_of_software
        # offset = counter-number_of_software
        
        print(f"offset : {offset}")

        # 4 = number connected of programs
        # as long as you can upload data - keep running
        while counter <= (36 * number_of_software) +1:
            if (counter - offset) % number_of_software == 0:
                index=int((counter - offset)/number_of_software)-1
                with self.subTest(i=index):
                    if offset != 0:
                        self.reshare(index)
                    else:
                        if index > 0 and index <= len(self.datasets):
                            set_shared_memory_path(data_path)
                            actual_dataset = get_shared_memory_data()
                            expected_dataset=self.datasets[index-1]
                            # log_my_message(f"[PYTHON][CHECK] - {np.array_equal(expected_dataset,actual_dataset)} - Expected: {array_to_string(expected_dataset)} - Actual: {array_to_string(actual_dataset)}")
                            self.assertTrue(np.array_equal(expected_dataset,actual_dataset))                        
                        if index < len(self.datasets):
                            share_data(self.datasets[index])
                    
                increment_counter()
            print('.',end='',flush=True)
            time.sleep(0.05)
            counter = get_counter()
            
if __name__ == '__main__':
    unittest.main(argv=['first-arg-is-ignored'], exit=False)
