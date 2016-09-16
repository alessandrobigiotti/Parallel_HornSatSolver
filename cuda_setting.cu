/*Created by Alessandro Bigiotti*/

#define MYCEIL( a, b ) ( (((a) / (b)) + ( (((a) % (b)) == 0) ? 0 : 1 )) )

// This function do:
//    1. set the cuda memory
//    2. calculate and set the cuda Grid/Block dimension
//    3. call the kernel functions
//    4. show the satisfiability
//    5. write in a file Result_Assignments.txt the literal assignments
void HornCuda(int *nextpos, int *lett, int *clause, int *tipo, int *poslet, int *num_args, int *matrixelem, int *row, int *col, int n, int m, int nk)
{

	printf("\nSetting up GPU...\n");
	// Select the GPU Device
	HANDLE_ERROR(cudaSetDevice(0));

	// Allocate GPU Memory
	HANDLE_ERROR(cudaMalloc((void**)&dev_matrixelem, nk * sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_col, nk * sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_row, (n + 1) * sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_numargs, m * sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_nextpos, (m + 2) * sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_lett, n * sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_clause, m * sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_tipo, m * sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_poslet, m * sizeof(int)));

	// Copy the data in the Host Memory to Device memory
	HANDLE_ERROR(cudaMemcpy(dev_matrixelem, matrixelem, nk * sizeof(int), cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(dev_col, col, nk * sizeof(int), cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(dev_row, row, (n + 1) * sizeof(int), cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(dev_numargs, num_args, m * sizeof(int), cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(dev_nextpos, nextpos, (m + 2) * sizeof(int), cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(dev_lett, lett, n * sizeof(int), cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(dev_clause, clause, m * sizeof(int), cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(dev_tipo, tipo, m * sizeof(int), cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(dev_poslet, poslet, m * sizeof(int), cudaMemcpyHostToDevice));

	// Calculate the Block number
	int numblock = MYCEIL(m, 480);

  // Set the Grid and Block Dimension
	dim3 dimGrid(numblock, 1);
	dim3 dimBlock(480, 1, 1);

  // Create an Event to see the execution time
	cudaEvent_t start = 0, stop = 0;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);

	int b = numblock;
  int t = 480;

	printf("Calling UnitClause Kernel\n");
	// Call the UnitClause Kernel
	UnitClause << <dimGrid, dimBlock >> >(NValid, b, t, dev_nextpos, dev_numargs, dev_lett, dev_clause, dev_matrixelem, dev_col, dev_row, dev_poslet, dev_tipo, n, m, nk);
  // Read the results after the call
	HANDLE_ERROR(cudaMemcpy(nextpos, dev_nextpos, (m + 2) * sizeof(int), cudaMemcpyDeviceToHost));
	HANDLE_ERROR(cudaMemcpy(lett, dev_lett, n*sizeof(int), cudaMemcpyDeviceToHost));

  	// Check Satisfiability to continue
	if (nextpos[m] == 1){
		check = true;
	}


  // Iterate until the formula is satisfiable or not
	while (check){
		check = false;
		nextpos[m] = 0;
    // Copy the updated values into GPU Memory
		HANDLE_ERROR(cudaMemcpy(dev_lett, lett, n * sizeof(int), cudaMemcpyHostToDevice));
		HANDLE_ERROR(cudaMemcpy(dev_nextpos, nextpos, (m + 2) * sizeof(int), cudaMemcpyHostToDevice));
		printf("Calling Propagate Kernel\n");
    // Call Propagate Kernel
		Propagate<< <dimGrid, dimBlock >> >(NValid, b, t, dev_nextpos, dev_numargs, dev_lett, dev_clause, dev_matrixelem, dev_col, dev_row, dev_poslet, dev_tipo, n, m, nk);
    // Read the results
		HANDLE_ERROR(cudaMemcpy(nextpos, dev_nextpos, (m + 2) * sizeof(int), cudaMemcpyDeviceToHost));
		HANDLE_ERROR(cudaMemcpy(lett, dev_lett, n*sizeof(int), cudaMemcpyDeviceToHost));
    // Check Satisfiability to continue
		if (nextpos[m] == 1 && nextpos[m + 1] != NValid){
			check = true;
		}
	}

  // Print the relust (Yes or Not)
	if (nextpos[m + 1] == NValid){
		printf("\nNO, the formula is UNSATISFIABLE\n");
	}
	else{
		printf("\nYES, the formula is SATISFIABLE\n");
		// Retrieve the current directory path
	  getcwd(currentDirectory, sizeof(currentDirectory));
	  printf("Directory Corrente: %s\n", currentDirectory);

		// Create a file to write the assignment values
		strcat(strcpy(path_to_assignment, currentDirectory), "/data/Result_Assignments.txt");
		ptr = fopen(path_to_assignment,"w");
		for (int i = 0; i < n; i++){
			fprintf(ptr, "lett: %d, val: %d\n", i, lett[i]);
		}
		fclose(ptr);
	}

	// Stop the event and read the Execution Time
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);
	printf("\n GPU execution time: %f /sec\n", elapsedTime);

	// Free the GPU Memory
	cudaFree(dev_matrixelem);
	cudaFree(dev_col);
	cudaFree(dev_row);
	cudaFree(dev_lett);
	cudaFree(dev_clause);
	cudaFree(dev_poslet);
	cudaFree(dev_tipo);
	cudaFree(dev_nextpos);
	cudaFree(dev_numargs);

	 // Free the GPU Device
	 HANDLE_ERROR(cudaDeviceReset());
}
