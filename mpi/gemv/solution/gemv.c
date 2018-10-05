#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

#include "gemv_utils.h"

void gemv(double** A, double* x, size_t rows, size_t cols, double** b);
void make_hilbert_mat(size_t rows, size_t cols, double*** A, size_t start_row, size_t start_col);

int main(int argc, char *argv[])
{
  const size_t rows = 10000;
  const size_t cols = 10000;
  int ntasks, myid; 

  size_t start_row, start_col, local_rows, local_cols;
  double t_start, t_end;
  double **A, *b, *x;
  double local_sum[2];
  double r_sum[2];

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &ntasks);
  MPI_Comm_rank(MPI_COMM_WORLD, &myid);

  if(rows % ntasks != 0) {
    if (myid == 0) printf("# rows not divisible by ntasks, exiting.\n");
    MPI_Finalize();
    return -1;
  }

  local_rows = rows / ntasks;
  local_cols = cols; /* Parallelize across rows only */

  start_col = 0;
  start_row = local_rows*myid;
  
  b = (double*) malloc(sizeof(double)*local_rows);
  x = (double*) malloc(sizeof(double)*local_cols);
  t_start = MPI_Wtime();
  allocate_dense(local_rows, local_cols, &A);

  make_hilbert_mat(local_rows, local_cols, &A, start_row, start_col);

  for (size_t i = 0; i < local_cols; i++) {
    x[i] = (double) start_col + i + 1 ;
  }
  for (size_t i = 0; i < local_rows; i++){
    b[i] = 0.0;
  }

  gemv(A, x, local_rows, local_cols, &b);

  /* The following is for debugging purposes */
#if 0
  int flag;
  MPI_Status status;
  if(myid == 0) {
    flag = 0;
    printf("task 0:\n");
    print_vec(x, local_rows);
    print_mat(A, local_rows, local_cols);
    print_vec(b, local_rows);
    MPI_Send(&flag, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
  }
  if(myid == 1) {
    MPI_Recv(&flag, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
    printf("task 1:\n");
    print_vec(x, local_rows);
    print_mat(A, local_rows, local_cols);
    print_vec(b, local_rows);
  }
#endif

  local_sum[0] = sum_vec(x,local_cols);
  local_sum[1] = sum_vec(b,local_rows);
  r_sum[0] = 0.0; r_sum[1] = 0.0;

  MPI_Reduce(&(local_sum[0]), &(r_sum[0]), 2, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

  t_end = MPI_Wtime();
  if(myid == 0) printf("sum(x) = %f, sum(Ax) = %f, time: %fs\n", local_sum[0] , r_sum[1], t_end-t_start);

  MPI_Finalize();
  return 0;
}

void gemv(double** A, double* x, size_t rows, size_t cols, double** b) {
  for (size_t i = 0; i < rows; i ++ )
  for (size_t j = 0; j < cols; j ++ ) {
    (*b)[i] = (*b)[i] + A[i][j]*x[j];
  }
}

void make_hilbert_mat(size_t rows, size_t cols, double*** A, 
                      size_t start_row, size_t start_col) {
  for (size_t i = 0; i < rows; i++) {
    for (size_t j = 0; j < cols; j++) {
      (*A)[i][j] = 1.0/( (double) (i + start_row +  j + start_col) + 1.0);
    }
  }
}

double sum_vec(double* vec, size_t rows) {
  double sum = 0.0;
  for (int i = 0; i < rows; i++) sum = sum + vec[i];
  return sum;
}
