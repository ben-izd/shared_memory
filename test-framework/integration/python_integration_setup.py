"""
This script is written to reset the integration test

Author: Benyamin Izadpanah
Copyright: Benyamin Izadpanah
Github Repository: https://github.com/ben-izd/shared_memory
Start Date: 2022-8
Last date modified: 2022-11
Version used for testing: Python 3.11

Requirement:
    - Make sure this file is executed alone (depend on __file__) in ".\\test-framework\\integration" directory

Options:
    - First command-line argument can be used to specify number of particpant in the integration test (default is 5)
"""

import sys
import os.path

sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)),"..","..","python"))
from shared_memory import *

counter_path = os.path.join(os.path.dirname(os.path.realpath(__file__)),"integration_test_counter")

number_of_software = 5
try:
    if len(sys.argv) > 1:
        number_of_software = int(sys.argv[1])
        print(f'number_of_software={number_of_software};')
except:
    pass

set_shared_memory_path(counter_path)
set_shared_memory_data([number_of_software])


