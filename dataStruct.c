/*Created by Alessandro Bigiotti*/

/*DataStructure to Host Memory*////////////////////////////////////////////////

// Number of Literals
int n = 0;

// Number of clauses
int m = 0;

// Number of Matrix element !=0
int nk = 0;

// Array of literal
int *lett = 0;

// Array of clause
int *clause = 0;

// Type of clause
int *tipo = 0;

//array positlit
int *nextpos = 0;

//positive literl of each clause
int *poslet = 0;

// Number of negative literal of each clause
int *num_args = 0;

// Incidence Matrix
int *matrix = 0;

// Matrix Elem != 0
int *matrixelem = 0;

//row and column index (col = nk)
int *row = 0;
int *col = 0;

// Array to check the visited node
int *mark = 0;

// pointers to file
FILE *fp;
FILE *fd;
FILE *ptr;

// counter
int count = 0;

// Condition of not satisfiability
int NValid = -1;

// Search the current directory path
char currentDirectory[1024];
// Path to file CNF
char fileCNF[1024];

// The file created during the construction
char path_matrix_elem[1082];
char path_col_index[1082];
char path_row_index[1082];
char path_poslet[1082];
char path_tipo[1082];
char path_num_neg_let[1082];
char path_to_assignment[1082];


/*DataStructure to Device Memory*//////////////////////////////////////////////
int *dev_lett = 0;
int *dev_clause = 0;
int *dev_numargs = 0;
int *dev_poslet = 0;
int *dev_tipo = 0;
int *dev_matrixelem = 0;
int *dev_row = 0;
int *dev_col = 0;
int *dev_nextpos = 0;
bool check = false;
