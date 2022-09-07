#!/usr/bin/env wolframscript
(* ::Package:: *)

SharedMemory`libraryPath = "D:\\projects\\Mathematica\\community\\31. shared_memory\\shared_memory.dll";
Get["D:\\projects\\Mathematica\\community\\31. shared_memory\\mathematica\\shared_memory.wl"];
SetSharedMemoryPath["D:\\projects\\Mathematica\\community\\31. shared_memory\\test-framework\\integeration\\integeration_test_counter"];
Block[{numberOfSoftware=4},

If[Length[$ScriptCommandLine]>1,Block[{temp=Internal`StringToMInteger[$ScriptCommandLine[[2]]]},
If[! FailureQ[temp],numberOfSoftware=temp;Print["numberOfSoftware="<>ToString[temp]<>";"]]];

SetSharedMemoryData[{numberOfSoftware}]
]
