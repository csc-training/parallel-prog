# General dense matrix-vector product

The skeleton codes in `gemv.F90` or `gemv.c` contain routines that compute
matrix vector products.

* Parallelize the program using MPI by splitting the rows of the matrix to
  across processes.
* Bonus (no solution provided): Parallelize by splitting the matrix in column-wise manner.
* Bonus (no solution provided): Parallelize by splitting the matrix smaller
  sub-matrices, i.e. combining the column-wise and row-wise splitting.
