function matlab_integration_test(varargin)
% This script is written to test the integration of interface of SharedMemory library written for Matlab with other interfaces
% 
% matlab_integration_test() will run the test with 5 participants
% matlab_integration_test(n) will run the test with n participants
% Author: Benyamin Izadpanah
% Copyright: Benyamin Izadpanah
% Github Repository: https://github.com/ben-izd/shared_memory
% Start Date: 2022-8
% Last date modified: 2022-11
% Version used for testing: Matlab 2022a
% 
% Requirement:
%   - Make sure ".\test-framework\integration" is the working directory or its in the path

    global data_path counter_path testCase number_of_software datasets;

    number_of_software = 5;

    if nargin > 0
        number_of_software = varargin{1};
        
        disp("number_of_software = " + mat2str(number_of_software) + ";");
    end
    
    data_path = fullfile(fileparts(which('matlab_integration_setup')),'integration_test_data');

    counter_path = fullfile(fileparts(which('matlab_integration_setup')),'integration_test_counter');

    matlab_types={'uint8','uint16','uint32','uint64','int8','int16','int32','int64','single','double'};

    testCase = matlab.unittest.TestCase.forInteractiveUse;
    
    datasets = cell(36,1);

    dataset_1= [32 46 76 12 42];

    dataset_2 = [[5 9 12];[43 21 36]];

    dataset_3 = zeros([2,4,3]);
    dataset_3(:,:,1) = [[60 68 44 31];[109 26 25 124]];
    dataset_3(:,:,2) = [[88 18 48 39];[52 25 87 37]];
    dataset_3(:,:,3) = [[14 67 98 125];[80 16 22 20]];
    
    sample_datasets = {dataset_1,dataset_2,dataset_3};
    
    temp_offset = 0;
    
    for i = 1:3
        for j = 1:10
            dataset = sample_datasets{i};
            datasets{(i-1) * 10 + j + temp_offset} = cast(dataset, matlab_types{j});
        end
        datasets{i * 10 + 1 + temp_offset} = complex(single(dataset));
        datasets{i * 10 + 2 + temp_offset} = complex(double(dataset));
        temp_offset = temp_offset +2;
    end
    
    
    main()
end

function main()
   global data_path testCase number_of_software datasets;
   
    counter = get_counter();
    offset = counter-number_of_software;
    disp("offset " + int2str(offset))
    while counter <= 36 * number_of_software + 1
        if mod((counter - offset), number_of_software) == 0
            index = ((counter - offset) / number_of_software);
            if offset ~= 0
                reshare(index)
            else
                if (index > 1 && index <= (length(datasets) + 1))
                    set_shared_memory_path(data_path);
                    actual_dataset = get_shared_memory_data();
                    expected_dataset = datasets{index-1};
                    % log_my_message("[MATLAB][CHECK] "+ mat2str(isequal(expected_dataset ,actual_dataset))+" - Expeceted: "+array_to_string(expected_dataset)+" - Actual: "+array_to_string(actual_dataset))
                    verifyEqual(testCase, actual_dataset, expected_dataset)
                end
                if index <= length(datasets)
                    share_data(index)
                end
            end
            increment_counter()
        end
        fprintf('.');
        pause(0.05);
        counter = get_counter();
    end
end

function out = array_to_string(data)
    out = mat2str(data(:)');
end

function reshare(index)
    global data_path testCase datasets;
    
    set_shared_memory_path(data_path);
    actual_dataset = get_shared_memory_data();
    
    verifyEqual(testCase, actual_dataset, datasets{index})
    % log_my_message("[MATLAB][CHECK] "+ mat2str(isequal(actual_dataset,expected_dataset))+" - Expeceted: "+array_to_string(expected_dataset)+" - Actual: "+array_to_string(actual_dataset))

    set_shared_memory_data(actual_dataset);
    % log_my_message("[MATLAB][RE-SHARE] Dimensions: "+mat2str(size(actual_dataset))+" - Type: "+class(actual_dataset)+" Data: "+array_to_string(actual_dataset));
end

function out = get_counter()
    global counter_path;
    set_shared_memory_path(counter_path);
    out = get_shared_memory_data();
    out = uint64(out(1));
end

function increment_counter()
    global counter_path;
    set_shared_memory_path(counter_path);
    temp = get_shared_memory_data();
    
    set_shared_memory_data(uint64(temp(1) + 1));
    % log_my_message("[MATLAB] "+mat2str(temp(1))+"++");
    fprintf("->" + mat2str(temp(1) + 1) + "\n");
end

function share_data(index)
    global data_path datasets;
    set_shared_memory_path(data_path);
    set_shared_memory_data(datasets{index});
    % log_my_message("[MATLAB][SHARE] Dimensions: "+mat2str(size(data))+" - Type: "+class(data)+" Data: "+array_to_string(data));
end


% function log_my_message(Data)
%     FID = fopen(fullfile(fileparts(which('matlab_integration_setup')),'log.txt'), 'a');
%     if FID < 0
%      error('Cannot open file');
%     end
%     fprintf(FID,  Data+"\n");
%     fclose(FID);
% end
