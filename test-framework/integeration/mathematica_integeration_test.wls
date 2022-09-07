#!/usr/bin/env wolframscript
(* ::Package:: *)

SharedMemory`libraryPath = "D:\\projects\\Rust\\10. shared memory\\rust\\target\\release\\shared_memory.dll";

Get["D:\\projects\\Mathematica\\community\\31. shared_memory\\mathematica\\shared_memory.wl"];

dataPath="D:\\projects\\Mathematica\\community\\31. shared_memory\\test-framework\\integeration\\integeration_test_data";

counterPath="D:\\projects\\Mathematica\\community\\31. shared_memory\\test-framework\\integeration\\integeration_test_counter";

(* logFile="D:\\projects\\Mathematica\\community\\31. shared_memory\\test-framework\\integeration\\log.txt"; *)

numberOfSoftware = 4;
If[Length[$ScriptCommandLine]>1,Block[{temp=Internal`StringToMInteger[$ScriptCommandLine[[2]]]},
If[! FailureQ[temp],numberOfSoftware=temp;Print["numberOfSoftware="<>ToString[temp]<>";"]]]];

mathematicaTypes = {"UnsignedInteger8", "UnsignedInteger16", "UnsignedInteger32",
     "UnsignedInteger64", "SignedInteger8", "SignedInteger16", "SignedInteger32",
     "SignedInteger64", "Real32", "Real64", "ComplexReal32", "ComplexReal64"
    };

Block[{dataset1 = {32, 46, 76, 12, 42}, dataset2 = {{5, 9, 12}, {43, 21, 36}}, dataset3 = {{{60, 68, 44, 31}, {109, 26, 25, 124}}, {{88, 18,48, 39}, {52, 25, 87, 37}}, {{14, 67, 98, 125}, {80, 16, 22, 20}}}},
	datasets = Flatten @ Outer[NumericArray[#1, #2]&, {dataset1, dataset2,dataset3}, mathematicaTypes, 1];
];

ClearAll[GetCounter, IncrementCounter, ShareData, GetType, Reshare, ArrayEqualQ];

ArrayEqualQ[array1_NumericArray, array2_List]:=ArrayEqualQ[Normal@array1, array2];

ArrayEqualQ[array1_List, array2_NumericArray]:=ArrayEqualQ[array1, Normal@array2];

ArrayEqualQ[array1_, array2_] :=Block[{},
    If[array1 === array2
        ,True
        ,If[Dimensions[array1] =!= Dimensions[array2],
            Print["Dimensions doesn't match: " <> ToString[Dimensions[array1]] <> " vs " <> ToString[Dimensions[array2]]]
            ];
        (*Print["Array 1: ",array1];
        Print["Array 2: ",array2];*)
        False
    ]
];

GetType[x_NumericArray]:=NumericArrayType[x];

GetType[_?(ArrayQ[#, _?IntegerQ]&)]:="SignedInteger64";

GetType[_?(ArrayQ[#, _?Developer`RealQ]&)] :="SignedInteger64";

GetCounter[]:=Block[{},
    SetSharedMemoryPath[counterPath];
    First@GetSharedMemoryData[]
];

IncrementCounter[] :=Block[{temp},
    SetSharedMemoryPath[counterPath];
    temp = GetSharedMemoryData[];
    SetSharedMemoryData[temp + 1];
    Print["->"<>ToString[temp+1]];
    (*LogMyMessage["[MATHEMATICA] "<>ToString[First@temp]<>"++"];*)
];

ShareData[data_]:=Block[{},
    SetSharedMemoryPath[dataPath];
    SetSharedMemoryData[data];
    (*LogMyMessage["[MATHEMATICA][SHARE] Dimensions"<>ToString[Dimensions[data]]<>" - Type "<>GetType[data]<>" - Data: "<>ToString[Normal@data]];*)
];

Reshare[index_Integer] :=Block[{actualDataset, expectedDataset},
    SetSharedMemoryPath[dataPath];
    actualDataset = GetSharedMemoryData[];
    expectedDataset = datasets[[index]];
    Sow[ArrayEqualQ[expectedDataset, actualDataset]];
    (*LogMyMessage["[MATHEMATICA][CHECK] - "<>ToString[expectedDataset===actualDataset]<>" - Expected: "<>ToString[expectedDataset]<>" - Actual: "<>ToString[actualDataset],logFile];*)
    SetSharedMemoryData[actualDataset];
    (*LogMyMessage["[MATHEMATICA][RE-SHARE] Dimensions "<>ToString[Dimensions[actualDataset]]<>" - Type "<>GetType[actualDataset]<>" Data: "<>ToString[Normal@actualDataset]];*)
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
                            expectedDataset= datasets[[index - 1]];
                            actualDataset = GetSharedMemoryData[];

                            Sow[ArrayEqualQ[expectedDataset, actualDataset]];
                            (*LogMyMessage["[MATHEMATICA][CHECK] - "<>ToString[expectedDataset===actualDataset]<>" - Expected: "<>ToString[expectedDataset]<>" - Actual: "<>ToString[actualDataset],logFile]*)];
                            If[index <= Length[datasets],
                                ShareData[datasets[[index]]]
                            ];
                    ];
                    IncrementCounter[];
                ];
                WriteString[$Output,"."];
                Pause[0.05];
                counter = GetCounter[];
            ];
        ];
    ];
If[tests[[2]] != {}, Print["\n"<>ToString@Counts@tests[[2, 1]]];,Print@"Counter should be reset."]


(* "D:\Program Files\Wolfram Research\Mathematica\13.1\wolframscript.exe" *)
