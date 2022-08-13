(* ::Package:: *)

BeginPackage["SharedMemory`"];

ClearAll[GetSharedMemoryData,GetSharedMemoryFlattenData,SetSharedMemoryData,DeleteSharedMemory,GetSharedMemoryFlattenLength
,GetSharedMemoryRank,GetSharedMemoryDimensions,SetSharedMemoryDimensions,SetSharedMemoryPath];

libraryPath;

Begin["`Private`"];
If[FileExistsQ[libraryPath],
SharedMemory`Internal`GetSharedMemoryFlattenData=LibraryFunctionLoad[libraryPath,"get_shared_memory_flatten_data_mathematica",{},{Real,1}];

SharedMemory`Internal`SetSharedMemoryData=LibraryFunctionLoad[libraryPath,"set_shared_memory_data_mathematica",{{Real,_,"Constant"}},"Void"];

SharedMemory`Internal`DeleteSharedMemory=LibraryFunctionLoad[libraryPath,"delete_shared_memory_mathematica",{},"Void"];

SharedMemory`Internal`GetSharedMemoryFlattenLength=LibraryFunctionLoad[libraryPath,"get_shared_memory_flatten_length_mathematica",{},Integer];

SharedMemory`Internal`GetSharedMemoryRank=LibraryFunctionLoad[libraryPath,"get_shared_memory_rank_mathematica",{},Integer];

SharedMemory`Internal`GetSharedMemoryDimensions=LibraryFunctionLoad[libraryPath,"get_shared_memory_dimensions_mathematica",{},{Integer,1}];
SharedMemory`Internal`SetSharedMemoryDimensions=LibraryFunctionLoad[libraryPath,"set_shared_memory_dimensions_mathematica",{{Integer,1,"Constant"}},"Void"];

SharedMemory`Internal`SetSharedMemoryPath=LibraryFunctionLoad[libraryPath,"set_shared_memory_path_mathematica",{"UTF8String"},"Void"];

ClearAll[SharedMemory`Internal`RowMajorToColumnMajor,SharedMemory`Internal`ColumnMajorToRowMajor];

SharedMemory`Internal`RowMajorToColumnMajor[data_]:=Block[{dimensions=Dimensions[data],reversedDimensions1,reversedDimensions2},
reversedDimensions1=Range[Length[dimensions]];
reversedDimensions1[[-2;;]]=Reverse@reversedDimensions1[[-2;;]];

reversedDimensions2=Reverse@dimensions;
reversedDimensions2[[;;2]]=Reverse@reversedDimensions2[[;;2]];
ArrayReshape[Transpose[data,reversedDimensions1],reversedDimensions2]
];

SharedMemory`Internal`ColumnMajorToRowMajor[data_]:=Block[{dimensions=Dimensions[data],reversedDimensions1,reversedDimensions2},
reversedDimensions1=Range[Length[dimensions]];
reversedDimensions1[[-2;;]]=Reverse@reversedDimensions1[[-2;;]];

reversedDimensions2=Reverse@dimensions;
Transpose[ArrayReshape[data,reversedDimensions2],reversedDimensions1]
];

SetSharedMemoryData[data_?ArrayQ]:=SharedMemory`Internal`SetSharedMemoryData[If[Length[Dimensions[data]]>1,
SharedMemory`Internal`RowMajorToColumnMajor[data]
,data]];

GetSharedMemoryData[]:=SharedMemory`Internal`ColumnMajorToRowMajor@ArrayReshape[SharedMemory`Internal`GetSharedMemoryFlattenData[],SharedMemory`Internal`GetSharedMemoryDimensions[]];

GetSharedMemoryFlattenData[]:=SharedMemory`Internal`GetSharedMemoryFlattenData[];
DeleteSharedMemory[]:=SharedMemory`Internal`DeleteSharedMemory[];
GetSharedMemoryFlattenLength[]:=SharedMemory`Internal`GetSharedMemoryFlattenLength[];
GetSharedMemoryRank[]:=SharedMemory`Internal`GetSharedMemoryRank[];
GetSharedMemoryDimensions[]:=SharedMemory`Internal`GetSharedMemoryDimensions[];
SetSharedMemoryDimensions[newDimensions_?VectorQ]:=SharedMemory`Internal`SetSharedMemoryDimensions[newDimensions];
SetSharedMemoryPath[path_String]:=SharedMemory`Internal`SetSharedMemoryPath[path];

,Print["SharedMemory`libraryPath should be set first before initializing the library."];$Failed]

UnloadSharedMemoryLibrary[]:=LibraryUnload[libraryPath];
LoadSharedMemoryLibrary[]:=LibraryLoad[libraryPath];
End[];
EndPackage[];
