function matlab_integration_setup(varargin)
% This script is written to reset the integration test
% 
% matlab_integration_test() will run reset the test with 5 participants
% matlab_integration_test(n) will run resset the test with n participants
% Author: Benyamin Izadpanah
% Copyright: Benyamin Izadpanah
% Github Repository: https://github.com/ben-izd/shared_memory
% Start Date: 2022-8
% Last date modified: 2022-11
% Version used for testing: Matlab 2022a
% 
% Requirement:
%   - Make sure ".\test-framework\integration" is the working directory or its in the path

    counter_path = fullfile(fileparts(which('matlab_integration_setup')),'integration_test_counter');
    
    number_of_software = 5;
    
    if nargin > 0
        number_of_software = varargin{1};
        disp("number_of_software = " +mat2str(number_of_software) + ";");
    end
    
    set_shared_memory_path(counter_path);
    set_shared_memory_data(uint64(number_of_software));

end