# Abstract
This CUDA(c) program is the final work of my thesis for the bachelor's degree.
The program implements a parallel version of the algorithm proposed by Dowling and Gallier [(link to papaer)]
(http://www.sciencedirect.com/science/article/pii/0743106684900141) to solve Sat Horn Formula.

# Introduction
The program take in  input a file.CNF containing the formula (the file.CNF must be specified by a path), after that 
it create the graph associated, some auxiliary data structures and call the kernel function to solve the problem.
It doesn't work on the CNF file directly, but it works on the Graph constructed with the role specified by [(link to papaer)]
(http://www.sciencedirect.com/science/article/pii/0743106684900141).

# Requiriments
The program is written in CUDA(c) language, then it works only with NVIDIA Devices.
To compile and run the program we need to install all of necessary software:
* See this guide to install CUDA: [link to instruction](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/#axzz4KKVroazE)
* Here you can found CUDA-TOOLKIT-Downloads: [link to download](https://developer.nvidia.com/cuda-downloads)
* Note: If you have a properties driver, i reccomend to use [bumbleebe](http://bumblebee-project.org/) instead of nouveau Nvidia driver.

# HornSatSolver_CUDA_c
A program to check the satisfiability of a HornSAT Formula.
This program is composed by some file:
* HornSoler.cu: contains the Main function, is the file to compile;
* constructGraph.c: contains a function to read the CNF file of the formula and construct the incidience matrix of the formula;
* cuda_setting.cu: contains a function to allocate the GPU Memory, calculate the Grid/Block dimension and call the kernel functions
* dataStruct.c: contains the data structures used by the program
* kernel_function.cu: contains the kernel functions
* info.cu: a simple program to show some GPU Devices Information

# Compile and Run info.cu
Open in Terminal the folder where is the program.
* $ nvcc -arch sm_20 info.cu -o print_info
* $ optirun ./print_info

# Compile and Run The HornSolver.cu
Open in Terminal the folder where is the program.
* $ nvcc -arch sm_20 HornSolver.cu -o Main
and run it.
* $ optirun ./Main
