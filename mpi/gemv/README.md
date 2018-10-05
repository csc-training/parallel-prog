# General dense matrix-vector product

The skeleton code (`gemv.F90` or `gemv.c`) contains routines that creates 
synthetic matrices and computes their matrix vector products against a vector.

* Parallelize the program using MPI by splitting the rows of the matrix to
  across processes.
* Bonus (no solution provided): Parallelize by splitting the matrix in column-wise manner.
* Bonus (no solution provided): Parallelize by splitting the matrix smaller
  sub-matrices, i.e. combining the column-wise and row-wise splitting.
