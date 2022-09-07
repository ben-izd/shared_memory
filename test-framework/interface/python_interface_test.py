import numpy as np
import unittest
from os.path import exists
import os.path

import sys


sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)),"..","..","python"))
from shared_memory import *

file_path = os.path.join(os.path.dirname(os.path.realpath(__file__)),"python_interface_test_data")

PYTHON_TYPES = [np.uint8, np.uint16, np.uint32, np.uint64, np.int8, np.int16,
                np.int32, np.int64, np.float32, np.float64, np.complex64, np.complex128]

class Utilities1(unittest.TestCase):
    def test_utility_1(self):
        with self.assertRaises(SharedMemoryLibraryError):
            get_shared_memory_data_type()
            get_shared_memory_rank()
            get_shared_memory_flatten_length()
            get_shared_memory_dimensions()
            get_shared_memory_flatten_data()
            get_shared_memory_data()
        set_shared_memory_path(file_path)




# Test Sharing Data
class fixed_size(unittest.TestCase):

    def generate_case(self, data_type: type, size: tuple):
        data = np.random.randint(0, high=10, size=size)
        data = data.astype(data_type)
        set_shared_memory_data(data)

        self.assertEqual(get_shared_memory_data_type(), data_type)
        self.assertEqual(get_shared_memory_rank(), len(size))
        self.assertEqual(get_shared_memory_flatten_length(), np.prod(size))

        # because of row -> column major conversion, their dimensions are not equal
        # temp1 = np.array(size)
        # temp2 = get_shared_memory_dimensions()
        # np.testing.assert_array_equal(temp1, temp2)       

        temp = get_shared_memory_data()
        np.testing.assert_array_equal(temp, data)
        self.assertEqual(temp.dtype, data.dtype)

    def test_sharing_data(self):

        for type in PYTHON_TYPES:
            self.generate_case(type, (5,))
            self.generate_case(type, (6, 4))
            self.generate_case(type, (3, 5, 7))


class random_size(unittest.TestCase):

    def generate_case(self, data_type: type, rank):
        
        size = np.random.randint(3, high=7, size=rank)
        
        data = np.random.randint(0, high=10, size=size)
        data = data.astype(data_type,order='C',copy=False)
        # data.setflags(align=True)
        # print(type(data))
        # print(data.flags)
        set_shared_memory_data(data)

        self.assertEqual(get_shared_memory_data_type(), data_type)
        self.assertEqual(get_shared_memory_rank(), rank)
        self.assertEqual(get_shared_memory_flatten_length(), np.prod(size))

        # because of row -> column major conversion, their dimensions are not equal
        # temp1 = get_shared_memory_dimensions()
        # np.testing.assert_array_equal(temp1, size)

        # self.assertTrue(np.array_equal(temp1, size))
        # self.assertEqual(temp1.dtype, size.dtype)

        temp2 = get_shared_memory_data()
        np.testing.assert_array_equal(temp2, data)
        self.assertEqual(temp2.dtype, data.dtype)

    def test_sharing_data(self):
        for type in PYTHON_TYPES:
            self.generate_case(type, 2)
            self.generate_case(type, 5)
            self.generate_case(type, 7)



class Utilities2(unittest.TestCase):

    def test_utility_2(self):
        # Rest the state
        delete_shared_memory()

        self.assertFalse(exists(file_path))

        set_shared_memory_data([1])

        self.assertTrue(file_path)

        self.assertTrue(file_path)
        os.remove(file_path)
        
        with self.assertRaises(SharedMemoryLibraryError):
            get_shared_memory_data_type()
            get_shared_memory_rank()
            get_shared_memory_flatten_length()
            get_shared_memory_dimensions()
            get_shared_memory_flatten_data()
            get_shared_memory_data()

def suite():
    suite = unittest.TestSuite()
    suite.addTest(Utilities1('test_utility_1'))
    suite.addTest(fixed_size('test_sharing_data'))
    suite.addTest(random_size('test_sharing_data'))
    suite.addTest(Utilities2('test_utility_2'))
    return suite

if __name__ == '__main__':
    runner = unittest.TextTestRunner(failfast=True)
    runner.run(suite())
