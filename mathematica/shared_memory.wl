(* ::Package:: *)
(* 
    Title: SharedMemory
    Summary: With this package you can share data with other interfaces exist in the github repository in memory.

    Author: Benyamin Izadpanah
    Copyright: Benyamin Izadpanah
    Github Repository: https://github.com/ben-izd/shared_memory
    Start Date: 2022-8
    Last date modified: 2022-11
    Version used for testing: 13.1
    
    Context used: SharedMemory`

    Version Requirements:
        12.2:
            - WithCleanup: in `GetSharedMemoryFlattenDataWithType` function, was used to free the string after retrieving
                This function can be replaced with AbortProtect if you don't have any computation constraint (like TimeConstrained).
        12:
            - NumericArray: is used to retrieve shared memory data in diffrent data types other than Integer64 and Real64
    
    Requirements:
        - SharedMemory`libraryPath should be set as shared library path, before evaluating this package.
            The library code and its compiled version is available at github repository.

    Options:
        - SharedMemory`$Debug can be set to True to prevent supressing Messages generated during the computation.

    Global Functions:
        - SharedMemory`GetSharedMemoryData
        - SharedMemory`GetSharedMemoryFlattenData
        - SharedMemory`SetSharedMemoryData
        - SharedMemory`DeleteSharedMemory
        - SharedMemory`GetSharedMemoryFlattenLength
        - SharedMemory`GetSharedMemoryRank
        - SharedMemory`GetSharedMemoryDimensions
        - SharedMemory`SetSharedMemoryDimensions
        - SharedMemory`SetSharedMemoryPath
        - SharedMemory`UnloadSharedMemoryLibrary
        - SharedMemory`GetSharedMemoryDataType

    Internal Functions:
        - SharedMemory`Private`CustomQuiet
        - SharedMemory`Internal`CheckLibraryError
        - SharedMemory`Internal`RowMajorToColumnMajor
        - SharedMemory`Internal`ColumnMajorToRowMajor
        - SharedMemory`Internal`GetSharedMemoryFlattenDataWithType
        - SharedMemory`Compiled`FreeString
        - SharedMemory`Compiled`DeleteSharedMemory
        - SharedMemory`Compiled`GetSharedMemoryFlattenDataReal
        - SharedMemory`Compiled`GetSharedMemoryFlattenDataSignedInteger64
        - SharedMemory`Compiled`GetSharedMemoryFlattenDataNumericArray
        - SharedMemory`Compiled`SetSharedMemoryDataReal
        - SharedMemory`Compiled`SetSharedMemoryDataSignedInteger64
        - SharedMemory`Compiled`SetSharedMemoryDataNumericArray
        - SharedMemory`Compiled`GetSharedMemoryFlattenLength
        - SharedMemory`Compiled`GetSharedMemoryDataType
        - SharedMemory`Compiled`GetSharedMemoryRank
        - SharedMemory`Compiled`GetSharedMemoryDimensions
        - SharedMemory`Compiled`SetSharedMemoryDimensions
        - SharedMemory`Compiled`SetSharedMemoryPath
        - SharedMemory`Compiled`GetSharedMemoryString
        - SharedMemory`Compiled`SetSharedMemoryString

 *)

BeginPackage["SharedMemory`"];

ClearAll[GetSharedMemoryData
        ,GetSharedMemoryFlattenData
        ,SetSharedMemoryData
        ,DeleteSharedMemory
        ,GetSharedMemoryFlattenLength
        ,GetSharedMemoryRank
        ,GetSharedMemoryDimensions
        ,SetSharedMemoryDimensions
        ,SetSharedMemoryPath
        ,UnloadSharedMemoryLibrary
        ,GetSharedMemoryDataType];

(* These error messages, reflect the errors written in Rust. *)
SharedMemory::emptyLibraryPathError = "Library path is not set";
SharedMemory::accessError = "Error in accessing shared file (probably file does not exist)";
SharedMemory::parsingPathError = "Can't read library_path from memory";
SharedMemory::canNotCreateSharedMemoryError = "Can't create shared memory";
SharedMemory::newRankDoesNotMatchPreviousRankError = "New Rank doesn't match the previous rank";
SharedMemory::invalidErrorCode = "Error code (`1`) is not valid";

Begin["`Private`"];
ClearAll[SharedMemory`Internal`CheckLibraryError];

(* -------------------- *)

SyntaxInformation[SharedMemory`Internal`CheckLibraryError] = {"ArgumentsPattern" -> {_}};
SharedMemory`Internal`CheckLibraryError::usage = "CheckLibraryError[value] Check the value, if negative return the proper Error, otherwise return the value.";

SharedMemory`Internal`CheckLibraryError[LibraryFunctionError["LIBRARY_USER_ERROR", x_]] := SharedMemory`Internal`CheckLibraryError[x];

SharedMemory`Internal`CheckLibraryError[value_Integer] := Switch[value
    ,-1, Message[SharedMemory`SharedMemory::emptyLibraryPathError]; Throw[$Failed]
    ,-2, Message[SharedMemory`SharedMemory::accessError]; Throw[$Failed]
    ,-3, Message[SharedMemory`SharedMemory::parsingPathError]; Throw[$Failed]
    ,-4, Message[SharedMemory`SharedMemory::canNotCreateSharedMemoryError]; Throw[$Failed]
    ,-5, Message[SharedMemory`SharedMemory::newRankDoesNotMatchPreviousRankError]; Throw[$Failed]
    , _?Negative, Message[SharedMemory::invalidErrorCode]; Throw[$Failed]
    , _, value];

SharedMemory`Internal`CheckLibraryError[x_] := x;

(* -------------------- *)

(* Exit if the library files does not exist. *)
If[Not @ FileExistsQ[SharedMemory`libraryPath]
    , Print["SharedMemory`libraryPath should be set first before initializing the library."]; Abort[]];


(* Declare functions *)
SharedMemory`Compiled`FreeString = LibraryFunctionLoad[libraryPath, "internal_free_string_mathematica", {}, "Void"];
SharedMemory`Compiled`DeleteSharedMemory = LibraryFunctionLoad[libraryPath, "delete_shared_memory_mathematica", {}, "Void"];

SharedMemory`Compiled`GetSharedMemoryFlattenDataReal = LibraryFunctionLoad[libraryPath, "get_shared_memory_flatten_data_float64_mathematica", {}, {Real, 1}];
SharedMemory`Compiled`GetSharedMemoryFlattenDataSignedInteger64 = LibraryFunctionLoad[libraryPath, "get_shared_memory_flatten_data_signed_64_mathematica", {}, {Integer, 1}];
SharedMemory`Compiled`GetSharedMemoryFlattenDataNumericArray = LibraryFunctionLoad[libraryPath, "get_shared_memory_flatten_data_numeric_array_mathematica", {}, LibraryDataType[NumericArray]];

SharedMemory`Compiled`SetSharedMemoryDataReal = LibraryFunctionLoad[libraryPath, "set_shared_memory_data_float64_mathematica", {{Real, _, "Constant"}}, "Void"];
SharedMemory`Compiled`SetSharedMemoryDataSignedInteger64 = LibraryFunctionLoad[libraryPath, "set_shared_memory_data_signed_64_mathematica", {{Integer, _, "Constant"}}, "Void"];
SharedMemory`Compiled`SetSharedMemoryDataNumericArray = LibraryFunctionLoad[libraryPath, "set_shared_memory_data_numeric_array_mathematica", {{LibraryDataType[NumericArray], "Constant"}}, "Void"];

SharedMemory`Compiled`GetSharedMemoryFlattenLength = LibraryFunctionLoad[libraryPath, "get_shared_memory_flatten_length_mathematica", {}, Integer];
SharedMemory`Compiled`GetSharedMemoryDataType = LibraryFunctionLoad[libraryPath, "get_shared_memory_data_type_mathematica", {} , Integer];
SharedMemory`Compiled`GetSharedMemoryRank = LibraryFunctionLoad[libraryPath, "get_shared_memory_rank_mathematica", {}, Integer];

SharedMemory`Compiled`GetSharedMemoryDimensions = LibraryFunctionLoad[libraryPath, "get_shared_memory_dimensions_mathematica", {}, {Integer, 1}];
SharedMemory`Compiled`SetSharedMemoryDimensions = LibraryFunctionLoad[libraryPath, "set_shared_memory_dimensions_mathematica", {{Integer, 1, "Constant"}}, "Void"];

SharedMemory`Compiled`SetSharedMemoryPath = LibraryFunctionLoad[libraryPath, "set_shared_memory_path_mathematica", {"UTF8String"}, "Void"];
SharedMemory`Compiled`GetSharedMemoryString = LibraryFunctionLoad[libraryPath, "get_shared_memory_string_mathematica", {}, "UTF8String"];
SharedMemory`Compiled`SetSharedMemoryString = LibraryFunctionLoad[libraryPath, "set_shared_memory_string_mathematica", {"UTF8String"}, "Void"];

(* -------------------- *)

ClearAll[SharedMemory`Internal`RowMajorToColumnMajor, SharedMemory`Internal`ColumnMajorToRowMajor, CustomQuiet];

(* If this flag is set true, error raised during the operation will not be suppressed. *)
SharedMemory`$Debug = False;


SyntaxInformation[CustomQuiet] = {"ArgumentsPattern" -> {_}};
CustomQuiet::usage = "CustomQuiet[x] Suppress the Message during the computation of x, if SharedMemory`$Debug is set to False.";
SetAttributes[CustomQuiet, HoldAllComplete];

CustomQuiet[x_] := If[SharedMemory`$Debug
                    ,SharedMemory`Internal`CheckLibraryError[x]
                    ,SharedMemory`Internal`CheckLibraryError @ Quiet[x]];

(* -------------------- *)

SyntaxInformation[SharedMemory`Internal`RowMajorToColumnMajor] = {"ArgumentsPattern" -> {_}};
SharedMemory`Internal`RowMajorToColumnMajor::usage = "RowMajorToColumnMajor[data] Convert the data to column-major format. Dimensions can be reorders. No type checking is conducted.";

SharedMemory`Internal`RowMajorToColumnMajor[data_] := If[Length[Dimensions @ data]>1
    ,
    Block[{dimensions=Dimensions[data], reversedDimensions1, reversedDimensions2},
        reversedDimensions1 = Range @ Length @ dimensions;
        reversedDimensions1[[-2 ;; ]] = Reverse @ reversedDimensions1[[-2 ;; ]];

        reversedDimensions2 = Reverse @ dimensions;
        reversedDimensions2[[ ;; 2]] = Reverse @ reversedDimensions2[[ ;; 2]];
        ArrayReshape[Transpose[data, reversedDimensions1], reversedDimensions2]
    ]
    ,data];

(* -------------------- *)

SyntaxInformation[SharedMemory`Internal`ColumnMajorToRowMajor] = {"ArgumentsPattern" -> {_}};
SharedMemory`Internal`ColumnMajorToRowMajor::usage = "ColumnMajorToRowMajor[data] Convert the data to row-major format. Dimensions can be reorders. No type checking is conducted.";

SharedMemory`Internal`ColumnMajorToRowMajor[data_] := Block[{dimensions = Dimensions[data], reversedDimensions1, reversedDimensions2},
    If[Length @ dimensions == 1
    ,data
    ,
        reversedDimensions1=Range[Length[dimensions]];
        reversedDimensions1[[ -2 ;; ]]=Reverse @ reversedDimensions1[[ -2 ;; ]];

        reversedDimensions2=Reverse @ dimensions;
        Transpose[ArrayReshape[data, reversedDimensions2], reversedDimensions1]
    ]
];

(* Defining the interface *)
(* -------------------- *)

SyntaxInformation[SetSharedMemoryData] = {"ArgumentsPattern" -> {_}};
SetSharedMemoryData::usage = "Convert the input data to row-major format. Dimensions can be reorders. No type checking is conducted.";

SetSharedMemoryData[data: _NumericArray|_ByteArray] := Catch @ CustomQuiet @ SharedMemory`Compiled`SetSharedMemoryDataNumericArray @ SharedMemory`Internal`RowMajorToColumnMajor[data];
SetSharedMemoryData[data_/; ArrayQ[data, _, Developer`RealQ]] := Catch @ CustomQuiet @ SharedMemory`Compiled`SetSharedMemoryDataReal @ SharedMemory`Internal`RowMajorToColumnMajor[data];
SetSharedMemoryData[data_/; ArrayQ[data, _, IntegerQ]] := Catch @ CustomQuiet @ SharedMemory`Compiled`SetSharedMemoryDataSignedInteger64 @ SharedMemory`Internal`RowMajorToColumnMajor[data];
SetSharedMemoryData[data_String] := Catch @ CustomQuiet @ SharedMemory`Compiled`SetSharedMemoryString[data];

(* -------------------- *)

SyntaxInformation[GetSharedMemoryData] = {"ArgumentsPattern" -> {}};
GetSharedMemoryData::usage = "GetSharedMemoryData[] Returns the shared memory data. It could be either a List, NumericArray or String.";

GetSharedMemoryData[]:=Block[{data = GetSharedMemoryFlattenData[]},
    If[StringQ[data]
        ,data
        ,Catch @ SharedMemory`Internal`ColumnMajorToRowMajor @ ArrayReshape[data, CustomQuiet @ SharedMemory`Compiled`GetSharedMemoryDimensions[]]
    ]
];

supportedTypes={"UnsignedInteger8","UnsignedInteger16","UnsignedInteger32","UnsignedInteger64","SignedInteger8","SignedInteger16","SignedInteger32","SignedInteger64","Real32","Real64","ComplexReal32","ComplexReal64","String"};

(* -------------------- *)

SyntaxInformation[GetSharedMemoryDataType] = {"ArgumentsPattern" -> {}};
GetSharedMemoryDataType::usage = "GetSharedMemoryDataType[] Returns the shared memory data type (in String format).";

GetSharedMemoryDataType[] := Catch @ supportedTypes[[CustomQuiet[SharedMemory`Compiled`GetSharedMemoryDataType[]]+1]];

(* -------------------- *)

SyntaxInformation[GetSharedMemoryFlattenData] = {"ArgumentsPattern" -> {}};
GetSharedMemoryFlattenData::usage = "GetSharedMemoryFlattenData[] Returns the flatten data. Return type could be either List, NumericArray or String.";

GetSharedMemoryFlattenData[] := Catch @ Block[{temp = SharedMemory`Internal`GetSharedMemoryFlattenDataWithType[]},
If[FailureQ[temp]
    ,$Failed
    ,First @ temp
  ]
];

(* -------------------- *)

SyntaxInformation[SharedMemory`Internal`GetSharedMemoryFlattenDataWithType] = {"ArgumentsPattern" -> {}};
SharedMemory`Internal`GetSharedMemoryFlattenDataWithType::usage = "GetSharedMemoryFlattenData[] Returns the flatten data with type.";

SharedMemory`Internal`GetSharedMemoryFlattenDataWithType[] := Block[{dataType = GetSharedMemoryDataType[]},
    If[FailureQ @ dataType, Return[$Failed]];

    {Switch[dataType
        ,"SignedInteger64", CustomQuiet @ SharedMemory`Compiled`GetSharedMemoryFlattenDataSignedInteger64[]
        ,"Real64", CustomQuiet @ SharedMemory`Compiled`GetSharedMemoryFlattenDataReal[]
        ,"String", WithCleanup[CustomQuiet @ SharedMemory`Compiled`GetSharedMemoryString[], SharedMemory`Compiled`FreeString[]]
        , _, CustomQuiet @ SharedMemory`Compiled`GetSharedMemoryFlattenDataNumericArray[]
        ]

    ,dataType}
];

(* -------------------- *)

SyntaxInformation[DeleteSharedMemory] = {"ArgumentsPattern" -> {}};
DeleteSharedMemory::usage = "DeleteSharedMemory[] Unload the data from memory if it can connect to it, otherwise will remove the specified file.";

DeleteSharedMemory[] := Catch @ CustomQuiet @ SharedMemory`Compiled`DeleteSharedMemory[];

(* -------------------- *)

SyntaxInformation[GetSharedMemoryFlattenLength] = {"ArgumentsPattern" -> {}};
GetSharedMemoryFlattenLength::usage = "GetSharedMemoryFlattenLength[] Returns flatten shared memory data length which is the product of dimensions.";

GetSharedMemoryFlattenLength[] := Catch @ CustomQuiet @ SharedMemory`Compiled`GetSharedMemoryFlattenLength[];

(* -------------------- *)

SyntaxInformation[GetSharedMemoryRank] = {"ArgumentsPattern" -> {}};
GetSharedMemoryRank::usage = "GetSharedMemoryRank[] Return the rank of shared memory data. For string is 1.";

GetSharedMemoryRank[] := Catch @ CustomQuiet @ SharedMemory`Compiled`GetSharedMemoryRank[];

(* -------------------- *)

SyntaxInformation[GetSharedMemoryDimensions] = {"ArgumentsPattern" -> {}};
GetSharedMemoryDimensions::usage = "GetSharedMemoryDimensions[] Return the dimension of shared memory data. For string is number of character without null-termination character.";

GetSharedMemoryDimensions[] := Catch @ CustomQuiet @ SharedMemory`Compiled`GetSharedMemoryDimensions[];

(* -------------------- *)

SyntaxInformation[SetSharedMemoryDimensions] = {"ArgumentsPattern" -> {_}};
SetSharedMemoryDimensions::usage = "SetSharedMemoryDimensions[] Sets a new dimension for the shared memory data. New rank should match the previous rank.";

SetSharedMemoryDimensions[newDimensions_?(VectorQ[#,IntegerQ]&)] := Catch @ CustomQuiet @ SharedMemory`Compiled`SetSharedMemoryDimensions[newDimensions];

(* -------------------- *)

SyntaxInformation[SetSharedMemoryPath] = {"ArgumentsPattern" -> {_}};
SetSharedMemoryPath::usage = "SetSharedMemoryPath[path] Sets path used to access the shared memory.";

SetSharedMemoryPath[path_String] := Catch[CustomQuiet @ SharedMemory`Compiled`SetSharedMemoryPath[path]; path];

(* -------------------- *)

SyntaxInformation[SharedMemory`UnloadSharedMemoryLibrary] = {"ArgumentsPattern" -> {}};
SharedMemory`UnloadSharedMemoryLibrary::usage = "SharedMemory`UnloadSharedMemoryLibrary[] Releases the shared library.";

SharedMemory`UnloadSharedMemoryLibrary[] := LibraryUnload[libraryPath];

End[];
EndPackage[];
