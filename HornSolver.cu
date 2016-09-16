/*Created by Alessandro Bigiotti*/

// Include C Library
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <error.h>
#include <unistd.h>
#include <string.h>

// Include CUDA Library
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "./otherlib/book.h"

// include dataStructure file
#include "./dataStruct.c"

// include the Kernel function
#include "./kernel_function.cu"

// include an Auxiliary function to set the GPU Memory, GPU Grid/Block, and call the kernel functions
#include "./cuda_setting.cu"

// include an Auxiliary function to read the CNF file,
// Construct the incidence Matrix of the Graph associated to the formula
// Construct the Compact Indicence Matrix of the Graph
// ...
#include "./constructGraph.c"

#define MYCEIL( a, b ) ( (((a) / (b)) + ( (((a) % (b)) == 0) ? 0 : 1 )) )

// The Prototype of the function in cuda_setting.cu
void HornCuda(int *nextpos, int *lett, int *clause, int *tipo, int *poslet, int *num_args, int *matrixelem, int *row, int *col, int n, int m, int nk);

// The Prototype of the function in construct.c
void Construct();

int main()
{

  // Allocate all of the data structures
  Construct();

  // call the function to set the GPU Parameters and call the kernel functions
  HornCuda(nextpos, lett, clause, tipo, poslet, num_args, matrixelem, row, col, n, m, nk);
	
  // free the memory used
  free(matrix);
  free(matrixelem);
  free(col);
  free(row);
  free(lett);
  free(clause);
  free(poslet);
  free(tipo);
  free(nextpos);
	
  return 0;
}
