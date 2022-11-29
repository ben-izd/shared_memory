#!/usr/bin/env wolframscript
(* ::Package:: *)
(* 
	Summary: This script is written to reset the integration test

	Author: Benyamin Izadpanah
	Copyright: Benyamin Izadpanah
    Github Repository: https://github.com/ben-izd/shared_memory
    Start Date: 2022-8
    Last date modified: 2022-11
    Version used for testing: 13.1

	Requirements:
		- Run this script with wolfram script in the same directory file exist or override $InitialDirectory to the ".\test-framework\interface" folder 
	
    Options:
        - First command-line argument can be used to specify number of particpant in the integration test (default is 5)
 *)

SharedMemory`libraryPath = FileNameJoin[{$InitialDirectory, "shared_memory.dll"}];

Get[FileNameJoin[{$InitialDirectory, "mathematica", "shared_memory.wl"}]];

SetSharedMemoryPath[FileNameJoin[{$InitialDirectory, "test-framework", "integration", "integration_test_counter"}]];

Block[{ numberOfSoftware = 5 },

    If[Length[$ScriptCommandLine]>1
    ,Block[{temp=Internal`StringToMInteger[$ScriptCommandLine[[2]]]},
        If[ ! FailureQ[temp],
            numberOfSoftware = temp;
            Print["numberOfSoftware = " <> ToString[temp] <> ";"]
            ]
        ]
    ];

    SetSharedMemoryData[{numberOfSoftware}];
];
