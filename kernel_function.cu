/*Created by Alessandro Bigiotti*/

// Kernel Function to calculate the Unit Clause of the formula
__global__ void UnitClause(int NValid, int b, int t, int *nextpos, int *num_args, int *lett, int *clause, int *matrixelem, int *col, int *row, int *poslet, int *tipo, int n, int m, int nk)
{

	int idx = threadIdx.x;
	int idblock = blockIdx.x;
	int indexpos = 0;
	int indexclause = 0;

	if (idblock*t + idx < m){
		if (tipo[idblock*t + idx] == 1){
			indexpos = poslet[idblock*t + idx];
			indexclause = idblock*t + idx;
			nextpos[indexclause] = 1;
			nextpos[m] = 1;
			lett[indexpos] = 1;
		}
	}
}

// kernel_function to calculate the Propagation of the assignments
__global__ void Propagate(int NValid, int b, int t, int *nextpos, int *num_args, int *lett, int *clause, int *matrixelem, int *col, int *row, int *poslet, int *tipo, int n, int m, int nk)
{
	int idx = threadIdx.x;
	int idblock = blockIdx.x;
	int indexpos = 0;
	int indexnextpos = 0;

	if (idblock*t + idx < m){
		if (nextpos[idblock*t + idx] == 1){
			indexpos = poslet[idblock*t + idx];
			nextpos[idblock*t + idx] = 0;
			for (int i = row[indexpos]; i < row[indexpos + 1]; i++){
				if (matrixelem[i] == 2){
					int old = atomicSub(num_args + col[i], 1);
					printf("%d\n",old);
					if (old == 1){
						indexnextpos = poslet[col[i]];
						if (indexnextpos != NValid){
							if (lett[indexnextpos] == 0){
								lett[indexnextpos] = 1;
								nextpos[col[i]] = 1;
								nextpos[m] = 1;
							}

						}
						else{
							if (tipo[col[i]] % 2 == 0){
								nextpos[m + 1] = NValid;
								break;
							}
						}

					}
				}
			}
		}
	}
}
