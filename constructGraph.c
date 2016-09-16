/*Created by Alessandro Bigiotti*/

// This function do:
//    1. read the CNF file
//    2. construct the incidence matrixelem
//    3. construct the compact incidence matrixelem
//    4. construct some auxiliary data structure
// note:  During the execution of this functions
//        will be created some file in the folder ./data

void Construct(){

  // Ask the path to CNF file
  printf("\n Insert the path of the CNF file\n");
  // Read the file
  scanf("%s", fileCNF);

  // Open the file
  fp = fopen(fileCNF, "r");
  //costruisco la matrice dal file cnf
  int elem = 1;
  if (fp == NULL) perror("Error opening file");
  else
  {
    printf("\nReading the file...\n");
    fscanf(fp, "%d", &n); fscanf(fp, "%d", &m);
    matrix = (int *)malloc(n*m*sizeof(int));
    for (int i = 0; i < n*m; i++){
      matrix[i] = 0;
    }

    for (int i = 0; i < m; i++){
      do{
        fscanf(fp, "%d", &elem);
        if (elem != 0){
          if (elem > 0){
            matrix[i + (elem - 1)*m] = 1;
          }
          else{
            elem *= -1;
            matrix[i + (elem - 1)*m] = 2;
          }
        }

      } while (elem != 0);
    }
  }
  fclose(fp);

  // Initialize lett
  lett = (int *)malloc(n*sizeof(int));
  for (int i = 0; i < n; i++){
    lett[i] = 0;
  }

  // Initialize clause
  clause = (int *)malloc(m*sizeof(int));
  for (int i = 0; i < m; i++){
    clause[i] = 0;
  }

  // Initialize mark
  mark = (int *)malloc(n*sizeof(int));
  for (int i = 0; i < n; i++){
    mark[i] = 0;
  }

  // Initialize nextpos
  nextpos = (int *)malloc((m + 2)*sizeof(int));
  for (int i = 0; i < m + 2; i++){
    nextpos[i] = 0;
  }

  // Retrieve the path of the current directory
  getcwd(currentDirectory, sizeof(currentDirectory));

  // Create the path to some data file
  strcat(strcpy(path_col_index, currentDirectory), "/data/col_index.txt");
  strcat(strcpy(path_matrix_elem, currentDirectory), "/data/matrix_elem.txt");
  strcat(strcpy(path_row_index,currentDirectory), "/data/row_index.txt");
  strcat(strcpy(path_poslet, currentDirectory), "/data/poslet.txt");
  strcat(strcpy(path_tipo, currentDirectory), "/data/tipo.txt");
  strcat(strcpy(path_num_neg_let, currentDirectory), "/data/num_neg_let.txt");

  // write the element of the matrix != 0 to create the compact matrix
  // write the index_column of the compact matrix
  count = 0;
  fd = fopen(path_col_index, "w");
  fp = fopen(path_matrix_elem, "w");
  if (fd == NULL || fp == NULL){ printf("Error opening file\n"); }
  else{
    for (int i = 0; i < n; i++){
      for (int j = 0; j < m; j++){
        if (matrix[i*m + j] != 0){
          fprintf(fp, "%d\n", matrix[i*m + j]);
          fprintf(fd, "%d\n", j);
          count++;
        }
      }
    }
  }
  fclose(fp);
  fclose(fd);
  nk = count;
  matrixelem = (int *)malloc(nk*sizeof(int));
  col = (int *)malloc(nk*sizeof(int));

  printf("Creating the Data Structures...\n");
  // save the element matrix !=0 and comlumn index
  fd = fopen(path_col_index, "r");
  fp = fopen(path_matrix_elem, "r");
  if (fd == NULL || fp == NULL){ printf("Error opening file\n"); }
  else{
    for (int i = 0; i < nk; i++){
      fscanf(fd, "%d", &col[i]);
      fscanf(fp, "%d", &matrixelem[i]);
    }
  }

  fclose(fp);
  fclose(fd);


  // calculate and save the row_index
  fp = fopen(path_row_index, "w");
  count = 0;
  fprintf(fp, "%d\n", count);
  for (int i = 0; i < n; i++){
    for (int j = 0; j < m; j++){
      if (matrix[i*m + j] != 0){
        count += 1;
      }
    }
    fprintf(fp, "%d\n", count);
  }
  fclose(fp);

  // Initialize row index
  row = (int *)malloc((n + 1) * sizeof(int));
  fp = fopen(path_row_index, "r");
  for (int i = 0; i < n + 1; i++){
    fscanf(fp, "%d", &row[i]);
  }
  fclose(fp);

  // save the "type" of each clause, and its positive literal
  int sum = 0; count = 0;
  fd = fopen(path_poslet, "w");
  fp = fopen(path_tipo, "w");
  if (fd == NULL || fp == NULL){ printf("Error opening file\n"); }
  else{
    for (int i = 0; i < m; i++){
      for (int j = 0; j < n; j++){
        sum += matrix[i + j*m];
        if (matrix[i + j*m] == 1){
          fprintf(fd, "%d\n", j);
        }
      }
      if (sum % 2 == 0){
        fprintf(fd, "%d\n", NValid);
      }
      
      fprintf(fp, "%d\n", sum);
      sum = 0;
    }
  }
  fclose(fp);
  fclose(fd);

  // Initialize array of type
  fp = fopen(path_tipo, "r");
  if (fp == NULL) { printf("Error opening file\n"); }
  tipo = (int *)malloc(m*sizeof(int));
  for (int i = 0; i < m; i++){
    fscanf(fp, "%d", &tipo[i]);
  }
  fclose(fp);

  // Initialize array of positive literal
  fp = fopen(path_poslet, "r");
  if (fp == NULL){ printf("Error opening file"); }
  else{
    poslet = (int *)malloc(m*sizeof(int));
    for (int i = 0; i < m; i++){
      fscanf(fp, "%d", &poslet[i]);
    }
  }
  fclose(fp);

  // save the number of negative literal of each clause
  fp = fopen(path_num_neg_let, "w");
  if (fp == NULL){ printf("Error opening file"); }
  else{
    count = 0;
    for (int i = 0; i < m; i++){
      for (int j = 0; j < n; j++){
        if (matrix[i + j*m] == 2){
          count += 1;
        }
      }
      fprintf(fp, "%d\n", count);
      count = 0;
    }
  }
  fclose(fp);

  // Initialize num_args (the number of negative literal)
  fp = fopen(path_num_neg_let, "r");
  if (fp == NULL){ printf("Error opening file"); }
  else{
    num_args = (int *)malloc(m*sizeof(int));
    for (int i = 0; i < m; i++){
      fscanf(fp, "%d", &num_args[i]);
    }
  }
  fclose(fp);

}
