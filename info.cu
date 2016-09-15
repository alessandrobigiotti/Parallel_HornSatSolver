/*Created by Alessandro Bigiotti*/

#include <stdio.h>
#include <stdlib.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"
// A function to show some GPU Information
int main(){

  // check the number of devices
	int nDevices;
	cudaGetDeviceCount(&nDevices);

  // for each device print some informations
	for (int i = 0; i < nDevices; i++) {
		cudaDeviceProp properties;
		cudaGetDeviceProperties(&properties, i);
		printf("Device Number: %d\n", i);
		printf(" Info: \n");
		printf("  Device name: %s\n", properties.name);
		printf("  Memory Clock Rate (KHz): %d\n", properties.memoryClockRate);
		printf("  Memory Bus Width (bits): %d\n", properties.memoryBusWidth);
		printf("  Peak Memory Bandwidth (GB/s): %f\n\n", 2.0*properties.memoryClockRate*(properties.memoryBusWidth/8)/1.0e6);
		printf(" Computing Capabilities: \n");
		printf("  Max Threads per Block: %d\n", properties.maxThreadsPerBlock);
		printf("  Max Threads Dim: %d\n", properties.maxThreadsDim[3]);
		printf("  Max GridSize: %d\n", properties.maxGridSize[3]);
		printf("  WarpSize: %d\n", properties.warpSize);
		printf("  Total Global Mem(GB): %f\n", ((properties.totalGlobalMem/1024.0)/1024.0)/1024.0);
		printf("  Shered Mem per Block(MB): %f\n\n", (properties.sharedMemPerBlock/1024.0)/1024);
	}
	return 0;
}
