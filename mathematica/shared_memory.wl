(* ::Package:: *)

BeginPackage["SharedMemory`"];

ClearAll[GetSharedMemoryData,GetSharedMemoryFlattenData,SetSharedMemoryData,DeleteSharedMemory,GetSharedMemoryFlattenLength
,GetSharedMemoryRank,GetSharedMemoryDimensions,SetSharedMemoryDimensions,SetSharedMemoryPath,UnloadSharedMemoryLibrary,GetSharedMemoryDataType];

SharedMemory::emptyLibraryPathError="Library path is not set";
SharedMemory::accessError="Error in accessing shared file (probably file does not exist)";
SharedMemory::parsingPathError="Can't read library_path from memory";
SharedMemory::canNotCreateSharedMemoryError="Can't create shared memory";
SharedMemory::newRankDoesNotMatchPreviousRankError="New Rank doesn't match the previous rank";
SharedMemory::invalidErrorCode="Error code (`1`) is not valid";
Begin["`Private`"];
ClearAll[SharedMemory`Internal`CheckLibraryError];

SharedMemory`Internal`CheckLibraryError[LibraryFunctionError["LIBRARY_USER_ERROR",x_]]:=SharedMemory`Internal`CheckLibraryError[x];
SharedMemory`Internal`CheckLibraryError[value_Integer]:=Switch[value
,-1,Message[SharedMemory`SharedMemory::emptyLibraryPathError];Throw[$Failed]
,-2,Message[SharedMemory`SharedMemory::accessError];Throw[$Failed]
,-3,Message[SharedMemory`SharedMemory::parsingPathError];Throw[$Failed]
,-4,Message[SharedMemory`SharedMemory::canNotCreateSharedMemoryError];Throw[$Failed]
,-5,Message[SharedMemory`SharedMemory::newRankDoesNotMatchPreviousRankError];Throw[$Failed]
,_?Negative,Message[SharedMemory::invalidErrorCode];Throw[$Failed]
,_,value];
SharedMemory`Internal`CheckLibraryError[x_]:=x;

If[FileExistsQ[SharedMemory`libraryPath],
SharedMemory`Compiled`FreeString=LibraryFunctionLoad[libraryPath,"internal_free_string_mathematica",{},"Void"];
SharedMemory`Compiled`GetSharedMemoryFlattenDataReal=LibraryFunctionLoad[libraryPath,"get_shared_memory_flatten_data_float64_mathematica",{},{Real,1}];
SharedMemory`Compiled`GetSharedMemoryFlattenDataSignedInteger64=LibraryFunctionLoad[libraryPath,"get_shared_memory_flatten_data_signed_64_mathematica",{},{Integer,1}];
SharedMemory`Compiled`GetSharedMemoryFlattenDataNumericArray=LibraryFunctionLoad[libraryPath,"get_shared_memory_flatten_data_numeric_array_mathematica",{},LibraryDataType[NumericArray]];

SharedMemory`Compiled`SetSharedMemoryDataReal=LibraryFunctionLoad[libraryPath,"set_shared_memory_data_float64_mathematica",{{Real,_,"Constant"}},"Void"];
SharedMemory`Compiled`SetSharedMemoryDataSignedInteger64=LibraryFunctionLoad[libraryPath,"set_shared_memory_data_signed_64_mathematica",{{Integer,_,"Constant"}},"Void"];
SharedMemory`Compiled`SetSharedMemoryDataNumericArray=LibraryFunctionLoad[libraryPath,"set_shared_memory_data_numeric_array_mathematica",{{LibraryDataType[NumericArray],"Constant"}},"Void"];

SharedMemory`Compiled`DeleteSharedMemory=LibraryFunctionLoad[libraryPath,"delete_shared_memory_mathematica",{},"Void"];

SharedMemory`Compiled`GetSharedMemoryFlattenLength=LibraryFunctionLoad[libraryPath,"get_shared_memory_flatten_length_mathematica",{},Integer];

SharedMemory`Compiled`GetSharedMemoryDataType=LibraryFunctionLoad[libraryPath,"get_shared_memory_data_type_mathematica",{},Integer];

SharedMemory`Compiled`GetSharedMemoryRank=LibraryFunctionLoad[libraryPath,"get_shared_memory_rank_mathematica",{},Integer];

SharedMemory`Compiled`GetSharedMemoryDimensions=LibraryFunctionLoad[libraryPath,"get_shared_memory_dimensions_mathematica",{},{Integer,1}];
SharedMemory`Compiled`SetSharedMemoryDimensions=LibraryFunctionLoad[libraryPath,"set_shared_memory_dimensions_mathematica",{{Integer,1,"Constant"}},"Void"];

SharedMemory`Compiled`SetSharedMemoryPath=LibraryFunctionLoad[libraryPath,"set_shared_memory_path_mathematica",{"UTF8String"},"Void"];
SharedMemory`Compiled`GetSharedMemoryString=LibraryFunctionLoad[libraryPath,"get_shared_memory_string_mathematica",{},"UTF8String"];
SharedMemory`Compiled`SetSharedMemoryString=LibraryFunctionLoad[libraryPath,"set_shared_memory_string_mathematica",{"UTF8String"},"Void"];

ClearAll[SharedMemory`Internal`RowMajorToColumnMajor,SharedMemory`Internal`ColumnMajorToRowMajor,CustomQuiet];

SharedMemory`$Debug=False;
CustomQuiet[x_]:=If[SharedMemory`$Debug,SharedMemory`Internal`CheckLibraryError[x],SharedMemory`Internal`CheckLibraryError@Quiet[x]];
SetAttributes[CustomQuiet,HoldAllComplete];

SharedMemory`Internal`RowMajorToColumnMajor[data_]:=If[Length[Dimensions[data]]>1,Block[{dimensions=Dimensions[data],reversedDimensions1,reversedDimensions2},
reversedDimensions1=Range[Length[dimensions]];
reversedDimensions1[[-2;;]]=Reverse@reversedDimensions1[[-2;;]];

reversedDimensions2=Reverse@dimensions;
reversedDimensions2[[;;2]]=Reverse@reversedDimensions2[[;;2]];
ArrayReshape[Transpose[data,reversedDimensions1],reversedDimensions2]
],data];

SharedMemory`Internal`ColumnMajorToRowMajor[data_]:=Block[{dimensions=Dimensions[data],reversedDimensions1,reversedDimensions2},
If[Length@dimensions==1,data,
reversedDimensions1=Range[Length[dimensions]];
reversedDimensions1[[-2;;]]=Reverse@reversedDimensions1[[-2;;]];

reversedDimensions2=Reverse@dimensions;
Transpose[ArrayReshape[data,reversedDimensions2],reversedDimensions1]
]];

(* interface *)

SetSharedMemoryData[data:_NumericArray|_ByteArray]:=Catch@CustomQuiet@SharedMemory`Compiled`SetSharedMemoryDataNumericArray[SharedMemory`Internal`RowMajorToColumnMajor[data]];
SetSharedMemoryData[data_/;ArrayQ[data,_,Developer`RealQ]]:=Catch@CustomQuiet@SharedMemory`Compiled`SetSharedMemoryDataReal[SharedMemory`Internal`RowMajorToColumnMajor[data]];
SetSharedMemoryData[data_/;ArrayQ[data,_,IntegerQ]]:=Catch@CustomQuiet@SharedMemory`Compiled`SetSharedMemoryDataSignedInteger64[SharedMemory`Internal`RowMajorToColumnMajor[data]];
SetSharedMemoryData[data_String]:=Catch@CustomQuiet@SharedMemory`Compiled`SetSharedMemoryString[data];

GetSharedMemoryData[]:=Block[{data=GetSharedMemoryFlattenData[]},
If[StringQ[data],data,
Catch@SharedMemory`Internal`ColumnMajorToRowMajor@ArrayReshape[data,CustomQuiet@SharedMemory`Compiled`GetSharedMemoryDimensions[]]
]];

supportedTypes={"UnsignedInteger8","UnsignedInteger16","UnsignedInteger32","UnsignedInteger64","SignedInteger8","SignedInteger16","SignedInteger32","SignedInteger64","Real32","Real64","ComplexReal32","ComplexReal64","String"};
GetSharedMemoryDataType[]:=Catch[supportedTypes[[CustomQuiet[SharedMemory`Compiled`GetSharedMemoryDataType[]]+1]]];

GetSharedMemoryFlattenData[]:=Catch@Block[{temp=SharedMemory`Internal`GetSharedMemoryFlattenDataWithType[]},
If[FailureQ[temp],$Failed,First@temp]
];

SharedMemory`Internal`GetSharedMemoryFlattenDataWithType[]:=Block[{dataType=GetSharedMemoryDataType[]},
If[FailureQ@dataType,Return[$Failed]];
{Switch[dataType
,"SignedInteger64",CustomQuiet@SharedMemory`Compiled`GetSharedMemoryFlattenDataSignedInteger64[]
,"Real64",CustomQuiet@SharedMemory`Compiled`GetSharedMemoryFlattenDataReal[]
,"String",WithCleanup[CustomQuiet@SharedMemory`Compiled`GetSharedMemoryString[],SharedMemory`Compiled`FreeString[]]
,_,CustomQuiet@SharedMemory`Compiled`GetSharedMemoryFlattenDataNumericArray[]]
,dataType}];

DeleteSharedMemory[]:=Catch@CustomQuiet@SharedMemory`Compiled`DeleteSharedMemory[];
GetSharedMemoryFlattenLength[]:=Catch@CustomQuiet@SharedMemory`Compiled`GetSharedMemoryFlattenLength[];
GetSharedMemoryRank[]:=Catch@CustomQuiet@SharedMemory`Compiled`GetSharedMemoryRank[];
GetSharedMemoryDimensions[]:=Catch@CustomQuiet@SharedMemory`Compiled`GetSharedMemoryDimensions[];
SetSharedMemoryDimensions[newDimensions_?VectorQ]:=Catch@CustomQuiet@SharedMemory`Compiled`SetSharedMemoryDimensions[newDimensions];
SetSharedMemoryPath[path_String]:=Catch[CustomQuiet@SharedMemory`Compiled`SetSharedMemoryPath[path];path];

,Print["SharedMemory`libraryPath should be set first before initializing the library."];$Failed]

SharedMemory`UnloadSharedMemoryLibrary[]:=LibraryUnload[libraryPath];

End[];
EndPackage[];
