# HornSatSolver_CUDA_c

## Abstract
This CUDA(c) program is the final work of my thesis for the bachelor's degree.
The program implements a parallel version of the algorithm proposed by Dowling and Gallier [(link to papaer)]
(http://www.sciencedirect.com/science/article/pii/0743106684900141) to solve Horn Sat Problem.

## Introduction
The program takes in  input a file.CNF containing the formula (the file.CNF must be specified by a path), after that 
it creates the graph associated, some auxiliary data structures and calls the kernel function to solve the problem.
It doesn't work on the CNF file directly, but it works on the Graph constructed with the roles specified by [(link to papaer)]
(http://www.sciencedirect.com/science/article/pii/0743106684900141).

## Requests
The program is written in CUDA(c) language, then it works only with NVIDIA Devices.
To compile and run the program we need to install all of necessary software:
* The gcc compiler; generally it is installed by default, if you haven't it, open the terminal and type the command(Debian/Ubuntu):
  * $ sudo apt-get install gcc
* See this guide to install CUDA: [link to instruction](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/#axzz4KKVroazE)
* Here there is CUDA-TOOLKIT: [link to download](https://developer.nvidia.com/cuda-downloads)
* Note: If you have a propertie drivers, i reccomend to use _bumblebee_ [ [Debian](https://wiki.debian.org/it/Bumblebee) / [Ubuntu](https://wiki.ubuntu.com/Bumblebee)] instead of nouveau Nvidia driver. 
* To run the compiled program, i use _optirun_, it will install automatically with the bumblebee installation.

## The Program
A program to check the satisfiability of a HornSAT Formula.
This program is composed by some files:
* HornSoler.cu: contains the Main function, is the file to compile;
* constructGraph.c: contains a function to read the CNF file of the formula and construct the incidence matrix of the formula;
* cuda_setting.cu: contains a function to allocate the GPU Memory, calculate the Grid/Block dimensions and call the kernel functions
* dataStruct.c: contains the data structures used by the program
* kernel_function.cu: contains the kernel functions
* info.cu: a simple program to show some GPU Devices Information
* data: a folder that contains some file created during the execution
* otherlib: a folder that contains a library named "book.h"

## Compile and Run info.cu
Open the Terminal, move to the folder where is the program and type:
* $ nvcc -arch sm_20 info.cu -o print_info
* $ optirun ./print_info

## Compile and Run The HornSolver.cu
Open the Terminal, move to the folder where is the program and type:
* $ nvcc -arch sm_20 HornSolver.cu -o Main
* $ optirun ./Main
