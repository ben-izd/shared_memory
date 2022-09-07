#!/usr/bin/env wolframscript
(* ::Package:: *)


SharedMemory`libraryPath="D:\\projects\\Mathematica\\community\\31. shared_memory\\shared_memory.dll";
Get["D:\\projects\\Mathematica\\community\\31. shared_memory\\mathematica\\shared_memory.wl"];
filePath="D:\\projects\\Mathematica\\community\\31. shared_memory\\test-framework\\mathematica_interface_test_data";
mathematicaTypes={"UnsignedInteger8","UnsignedInteger16","UnsignedInteger32","UnsignedInteger64","SignedInteger8","SignedInteger16","SignedInteger32","SignedInteger64","Real32","Real64","ComplexReal32","ComplexReal64"};
Print["[INFO] 6 Failure in Random-Size and Fixed-Size is normal. Library return \"List\" instead of NumericArray for \"Integer64\" and \"Real64\"."];

Block[{test=TestReport@{
VerificationTest[GetSharedMemoryDataType[],$Failed,{SharedMemory::emptyLibraryPathError}],
VerificationTest[GetSharedMemoryRank[],$Failed,{SharedMemory::emptyLibraryPathError}],
VerificationTest[GetSharedMemoryFlattenLength[],$Failed,{SharedMemory::emptyLibraryPathError}],
VerificationTest[GetSharedMemoryDimensions[],$Failed,{SharedMemory::emptyLibraryPathError}],
VerificationTest[GetSharedMemoryFlattenData[],$Failed,{SharedMemory::emptyLibraryPathError}],
VerificationTest[GetSharedMemoryData[],$Failed,{SharedMemory::emptyLibraryPathError}]}},

Print["Utilities-1: \t"<>ToString@test["TestsSucceededCount"]<>" succeeded, \t"<>ToString@test["TestsFailedWrongResultsCount"]<>" failed."];
]


SetSharedMemoryPath[filePath]


ClearAll[generateCaseFixed];
generateCaseFixed[type_String,size_List]:=Block[{data=NumericArray[RandomInteger[{1,10},size],type]},
SetSharedMemoryData[data];
{VerificationTest[GetSharedMemoryDataType[],type],
VerificationTest[GetSharedMemoryRank[],Length@size],
(*VerificationTest[GetSharedMemoryDimensions[],size],*)
VerificationTest[GetSharedMemoryFlattenLength[],Times@@size],
VerificationTest[GetSharedMemoryData[],data]}
];

Block[{test=TestReport@Flatten@Outer[generateCaseFixed,mathematicaTypes,{{5},{6,4},{3,5,7}},1]},
	Print["Fixed-Size: \t"<>ToString@test["TestsSucceededCount"]<>" succeeded, \t"<>ToString@test["TestsFailedWrongResultsCount"]<>" failed."];
]


ClearAll[generateCaseRandom];
generateCaseRandom[type_String,rank_Integer]:=Block[{data,size=RandomInteger[{2,5},rank]},

data=NumericArray[RandomInteger[{1,10},size],type];
SetSharedMemoryData[data];
{VerificationTest[GetSharedMemoryDataType[],type],
VerificationTest[GetSharedMemoryRank[],rank],
(*VerificationTest[GetSharedMemoryDimensions[],size],*)
VerificationTest[GetSharedMemoryFlattenLength[],Times@@size],
VerificationTest[GetSharedMemoryData[],data]}
];

Block[{test=TestReport@Flatten@Outer[generateCaseRandom,mathematicaTypes,{2,5,7}]},
	Print["Random-Size: \t"<>ToString@test["TestsSucceededCount"]<>" succeeded, \t"<>ToString@test["TestsFailedWrongResultsCount"]<>" failed."];

]


DeleteSharedMemory[];
Block[{test},
test=TestReport@{
VerificationTest[!FileExistsQ[filePath]],
SetSharedMemoryData[{1}];VerificationTest[FileExistsQ[filePath]],
DeleteFile[filePath];VerificationTest[GetSharedMemoryDataType[],$Failed,{SharedMemory::acessError}],
VerificationTest[GetSharedMemoryRank[],$Failed,{SharedMemory::acessError}],
VerificationTest[GetSharedMemoryFlattenLength[],$Failed,{SharedMemory::acessError}],
VerificationTest[GetSharedMemoryDimensions[],$Failed,{SharedMemory::acessError}],
VerificationTest[GetSharedMemoryFlattenData[],$Failed,{SharedMemory::acessError}],
VerificationTest[GetSharedMemoryData[],$Failed,{SharedMemory::acessError}]};

Print["Utilities-2: \t"<>ToString@test["TestsSucceededCount"]<>" succeeded, \t"<>ToString@test["TestsFailedWrongResultsCount"]<>" failed."];
]
