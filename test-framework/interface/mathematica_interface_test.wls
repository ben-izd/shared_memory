#!/usr/bin/env wolframscript
(* ::Package:: *)
(* 
	Summary: This script is written to test the interface of SharedMemory library written for Wolfram-Language

	Author: Benyamin Izadpanah
	Copyright: Benyamin Izadpanah
    Github Repository: https://github.com/ben-izd/shared_memory
    Start Date: 2022-8
    Last date modified: 2022-11
    Version used for testing: 13.1

	Requirements:
		- Run this script with wolfram script from root (depends on $InitialDirectory)
 *)

SharedMemory`libraryPath = FileNameJoin[{$InitialDirectory, "shared_memory.dll"}];

Get[FileNameJoin[{$InitialDirectory, "mathematica", "shared_memory.wl"}]];

filePath = FileNameJoin[{$InitialDirectory, "test-framework", "interface", "mathematica_interface_test_data"}];

mathematicaTypes = {"UnsignedInteger8", "UnsignedInteger16", "UnsignedInteger32", "UnsignedInteger64", "SignedInteger8", "SignedInteger16", "SignedInteger32", "SignedInteger64", "Real32", "Real64", "ComplexReal32", "ComplexReal64"};

(* Print["[INFO] 6 Failure in Random-Size and Fixed-Size is normal. Library return \"List\" instead of NumericArray for \"SignedInteger64\" and \"Real64\"."]; *)

Block[{test = TestReport @ {
	VerificationTest[GetSharedMemoryDataType[], $Failed, {SharedMemory::emptyLibraryPathError}],

	VerificationTest[GetSharedMemoryRank[], $Failed, {SharedMemory::emptyLibraryPathError}],

	VerificationTest[GetSharedMemoryFlattenLength[], $Failed, {SharedMemory::emptyLibraryPathError}],

	VerificationTest[GetSharedMemoryDimensions[], $Failed, {SharedMemory::emptyLibraryPathError}],

	VerificationTest[GetSharedMemoryFlattenData[], $Failed, {SharedMemory::emptyLibraryPathError}],

	VerificationTest[GetSharedMemoryData[], $Failed, {SharedMemory::emptyLibraryPathError}]
	}
},

	Print["Utilities-1: \t" <> ToString @ test["TestsSucceededCount"] <> " succeeded, \t" <> ToString @ test["TestsFailedWrongResultsCount"] <> " failed."];
]


SetSharedMemoryPath[filePath]


ClearAll[generateCaseFixed];

generateCaseFixed[type_String, size_List] := Block[{data = NumericArray[RandomInteger[{1, 10}, size], type]},

	SetSharedMemoryData[data];

	{VerificationTest[GetSharedMemoryDataType[], type],
	VerificationTest[GetSharedMemoryRank[], Length @ size],

	(* because of row -> column major conversion, their dimensions are not equal *)
	(*VerificationTest[GetSharedMemoryDimensions[],size],*)

	VerificationTest[GetSharedMemoryFlattenLength[], Times @@ size],
	VerificationTest[If[type === "SignedInteger64" || type === "Real64", NumericArray[#, type]&, Identity] @ GetSharedMemoryData[], data]} 

];

ClearAll[TestStringCase];

(* Testing String *)
TestStringCase[] := Block[{sampleText = "Mathematica \|01f60d Wolfram \|01f609 Language \|01f601"},
    
    SetSharedMemoryData[sampleText];
	
	{VerificationTest[GetSharedMemoryDataType[], "String"],
	VerificationTest[GetSharedMemoryRank[], 1],
	VerificationTest[GetSharedMemoryDimensions[], {43}],
	VerificationTest[GetSharedMemoryFlattenLength[], 43],
	VerificationTest[GetSharedMemoryData[], sampleText]} 
]

Block[{test = TestReport @ Flatten @ {Outer[generateCaseFixed,mathematicaTypes,{{5},{6,4},{3,5,7}},1], TestStringCase[]}},

	If[ test["TestsFailedWrongResultsCount"] > 0,
		Print["\nFailed Cases: ------------------"];
		Print["Actual Output  |  Expected Output"];
		Print[StringRiffle[ToString /@ Values@#[{"ActualOutput", "ExpectedOutput"}] & /@ Cases[test["TestsFailed"], _TestResultObject, Infinity],"\n"]];
		Print["--------------------------------\n"];
	];
	
	Print["Fixed-Size: \t" <> ToString @ test["TestsSucceededCount"] <> " succeeded, \t" <> ToString @ test["TestsFailedWrongResultsCount"] <> " failed."];
]


ClearAll[generateCaseRandom];
generateCaseRandom[type_String, rank_Integer] := Block[{data, size = RandomInteger[{2,5}, rank]},

	data = NumericArray[RandomInteger[{1, 10}, size], type];

	SetSharedMemoryData[data];

	{VerificationTest[GetSharedMemoryDataType[], type],
	VerificationTest[GetSharedMemoryRank[], rank],

	(* because of row -> column major conversion, their dimensions are not equal *)
	(*VerificationTest[GetSharedMemoryDimensions[], size],*)

	VerificationTest[GetSharedMemoryFlattenLength[], Times @@ size],
	VerificationTest[If[type === "SignedInteger64" || type === "Real64", NumericArray[#, type]&, Identity] @ GetSharedMemoryData[], data]}
	
	
];

Block[{test = TestReport @ Flatten @ Outer[generateCaseRandom, mathematicaTypes, {2, 5, 7}]},

	If[ test["TestsFailedWrongResultsCount"] > 0,
		Print["\nFailed Cases: ------------------"];
		Print["Actual Output  |  Expected Output"];
		Print[StringRiffle[ToString /@ Values@#[{"ActualOutput", "ExpectedOutput"}] & /@ Cases[test["TestsFailed"], _TestResultObject, Infinity],"\n"]];
		Print["--------------------------------\n"];
	];

	Print["Random-Size: \t" <> ToString @ test["TestsSucceededCount"] <> " succeeded, \t" <> ToString @ test["TestsFailedWrongResultsCount"] <> " failed."];
]


DeleteSharedMemory[];

Block[{test},
	test = TestReport @ {

		VerificationTest[!FileExistsQ[filePath]],

		SetSharedMemoryData[{1}];VerificationTest[FileExistsQ[filePath]],

		DeleteFile[filePath];
		
		VerificationTest[GetSharedMemoryDataType[], $Failed, {SharedMemory::acessError}],

		VerificationTest[GetSharedMemoryRank[], $Failed, {SharedMemory::acessError}],

		VerificationTest[GetSharedMemoryFlattenLength[], $Failed, {SharedMemory::acessError}],

		VerificationTest[GetSharedMemoryDimensions[], $Failed, {SharedMemory::acessError}],

		VerificationTest[GetSharedMemoryFlattenData[], $Failed, {SharedMemory::acessError}],

		VerificationTest[GetSharedMemoryData[], $Failed, {SharedMemory::acessError}]
	};

	Print["Utilities-2: \t" <> ToString @ test["TestsSucceededCount"] <> " succeeded, \t" <> ToString @ test["TestsFailedWrongResultsCount"] <> " failed."];
]
