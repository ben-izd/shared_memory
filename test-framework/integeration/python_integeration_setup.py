import sys
import os.path

sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)),"..","..","python"))
from shared_memory import *

counter_path = os.path.join(os.path.dirname(os.path.realpath(__file__)),"integeration_test_counter")

number_of_software = 4
try:
    if len(sys.argv) > 1:
        number_of_software = int(sys.argv[1])
        print(f'number_of_software={number_of_software};')
except:
    pass

set_shared_memory_path(counter_path)
set_shared_memory_data([number_of_software])


