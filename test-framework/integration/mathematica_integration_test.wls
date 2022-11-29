#!/usr/bin/env wolframscript
(* ::Package:: *)

(* 
	Summary: This script is written to test the integration of interface of SharedMemory library written for Wolfram-Language with other interfaces

	Author: Benyamin Izadpanah
	Copyright: Benyamin Izadpanah
    Github Repository: https://github.com/ben-izd/shared_memory
    Start Date: 2022-8
    Last date modified: 2022-11
    Version used for testing: 13.1

	Requirements:
		- Run this script with wolfram script in the same directory file exist or override $InitialDirectory variable to the ".\test-framework\integration" folder 
	
    Options:
        - First command-line argument can be used to specify number of particpant in the integration test (default is 5)
 *)

SharedMemory`libraryPath = FileNameJoin[{$InitialDirectory, "shared_memory.dll"}];

Get[FileNameJoin[{$InitialDirectory, "mathematica", "shared_memory.wl"}]];

dataPath = FileNameJoin[{$InitialDirectory, "test-framework", "integration", "integration_test_data"}];

counterPath = FileNameJoin[{$InitialDirectory, "test-framework", "integration", "integration_test_counter"}];

(* logFile = FileNameJoin[{$InitialDirectory, "log.txt"}]; *)

numberOfSoftware = 5;
If[Length[$ScriptCommandLine]>1
,Block[{temp = Internal`StringToMInteger[$ScriptCommandLine[[2]]]},
        If[ ! FailureQ[temp],
            numberOfSoftware = temp;
            Print["numberOfSoftware = " <> ToString[temp] <> ";"];
        ];
    ];
];

mathematicaTypes = {"UnsignedInteger8", "UnsignedInteger16", "UnsignedInteger32",
     "UnsignedInteger64", "SignedInteger8", "SignedInteger16", "SignedInteger32",
     "SignedInteger64", "Real32", "Real64", "ComplexReal32", "ComplexReal64"
    };

Block[{dataset1 = {32, 46, 76, 12, 42}
     , dataset2 = {{5, 9, 12}, {43, 21, 36}}
     , dataset3 = {{{60, 68, 44, 31}, {109, 26, 25, 124}}, {{88, 18,48, 39}, {52, 25, 87, 37}}, {{14, 67, 98, 125}, {80, 16, 22, 20}}}},

	datasets = Flatten @ Outer[NumericArray[#1, #2]&, {dataset1, dataset2, dataset3}, mathematicaTypes, 1];
];

ClearAll[GetCounter, IncrementCounter, ShareData, GetType, Reshare, ArrayEqualQ];

(* ArrayEqualQ[array1_NumericArray, array2_List] := ArrayEqualQ[Normal @ array1, array2, GetType[array1], GetType[array2]];

ArrayEqualQ[array1_List, array2_NumericArray] := ArrayEqualQ[array1, Normal @ array2, GetType[array1], GetType[array2]];

ArrayEqualQ[array1_NumericArray, array2_NumericArray] := ArrayEqualQ[array1, array2, GetType[array1], GetType[array2]]; *)

ArrayEqualQ[array1:_List|_NumericArray, array2:_List|_NumericArray] := ArrayEqualQ[Normal @ array1, Normal @ array2, GetType[array1], GetType[array2]];

ArrayEqualQ[array1_, array2_, type1_String, type2_String] := Block[{},
    If[type1 === type2
        ,If[Dimensions[array1] === Dimensions[array2]
            ,If[array1 === array2
                ,Return[True];
                ,Print["Arrays don't match"]; Return[False];
                ]
            ,Print["Dimensions don't match: " <> ToString[Dimensions[array1]] <> " vs " <> ToString[Dimensions[array2]]]; 
             Return[False];
           ]
        ,Print["Types don't match: " <> type1 <> " vs " <> type2]; 
         Return[False];
    ]
];

GetType[x_NumericArray] := NumericArrayType[x] /. "Integer64" -> "SignedInteger64";

GetType[_?(ArrayQ[#, _, IntegerQ]&)] := "SignedInteger64";

GetType[_?(ArrayQ[#, _, Developer`RealQ]&)] := "Real64";

GetCounter[] := Block[{},
    SetSharedMemoryPath[counterPath];
    First @ Normal @ GetSharedMemoryData[]
];

IncrementCounter[] := Block[{temp},
    SetSharedMemoryPath[counterPath];
    temp = First @ Normal @ GetSharedMemoryData[];
    SetSharedMemoryData[NumericArray[{temp + 1},"UnsignedInteger64"]];
    Print["->" <> ToString[temp+1]];
    (* LogMyMessage["[MATHEMATICA] "<>ToString[First@temp]<>"++"]; *)
];

ShareData[data_] := Block[{},
    SetSharedMemoryPath[dataPath];
    SetSharedMemoryData[data];
    (* LogMyMessage["[MATHEMATICA][SHARE] Dimensions"<>ToString[Dimensions[data]]<>" - Type "<>GetType[data]<>" - Data: "<>ToString[Normal@data]]; *)
];

Reshare[index_Integer] := Block[{actualDataset, expectedDataset},
    SetSharedMemoryPath[dataPath];
    actualDataset = GetSharedMemoryData[];
    expectedDataset = datasets[[index]];
    Sow[ArrayEqualQ[expectedDataset, actualDataset]];
    (* LogMyMessage["[MATHEMATICA][CHECK] - "<>ToString[expectedDataset===actualDataset]<>" - Expected: "<>ToString[expectedDataset]<>" - Actual: "<>ToString[actualDataset],logFile]; *)
    SetSharedMemoryData[actualDataset];
    (* LogMyMessage["[MATHEMATICA][RE-SHARE] Dimensions "<>ToString[Dimensions[actualDataset]]<>" - Type "<>GetType[actualDataset]<>" Data: "<>ToString[Normal@actualDataset]]; *)
];


tests = Reap[Block[{counter, offset, index, actualDataset, expectedDataset},
            counter = GetCounter[];
            offset = Mod[counter, numberOfSoftware];
            Print["offset ", offset];
            While[ counter <= (36 * numberOfSoftware) + 1,
                If[Mod[counter - offset, numberOfSoftware] === 0,
                    index = IntegerPart[((counter - offset) / numberOfSoftware)];
                    If[offset =!= 0
                        ,Reshare[index];
                        ,If[1 < index <= (Length[datasets] + 1),
                            SetSharedMemoryPath[dataPath]; 
                            expectedDataset = datasets[[index - 1]];
                            actualDataset = GetSharedMemoryData[];

                            Sow[ArrayEqualQ[expectedDataset, actualDataset]];
                            (* LogMyMessage["[MATHEMATICA][CHECK] - "<>ToString[expectedDataset===actualDataset]<>" - Expected: "<>ToString[expectedDataset]<>" - Actual: "<>ToString[actualDataset],logFile] *)];
                            If[index <= Length[datasets],
                                ShareData[datasets[[index]]]
                            ];
                    ];
                    IncrementCounter[];
                ];
                WriteString[$Output, "."];
                Pause[0.05];
                counter = GetCounter[];
            ];
        ];
    ];

If[tests[[2]] != {}
    , Print["\n" <> ToString @ Counts @ tests[[2, 1]]];
    , Print @ "Counter should be reset."
]
