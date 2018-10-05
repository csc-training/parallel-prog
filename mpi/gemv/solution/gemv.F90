program gemv_test
use iso_fortran_env, only: int64, real64
use mpi
implicit none
integer, parameter :: ik = int64
integer, parameter :: dp = real64

integer(kind=ik), parameter  :: rows = 10000,cols = 10000
real(kind=dp), allocatable :: A(:,:), b(:), x(:)
real(kind=dp) :: local_sum(1), global_sum(1), t_end, t_start
integer(kind=ik) :: i, local_rows, local_cols, start_col, start_row
integer :: ierr, ntasks, rank

call mpi_init(ierr)
call mpi_comm_size(MPI_COMM_WORLD, ntasks, ierr)
call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)

if (mod(rows, ntasks) /= 0) then
  print *, 'Number of rows is not divisible by ntasks, exiting'
  call mpi_finalize(ierr)
  stop
end if

local_rows = rows / ntasks
local_cols = cols
start_col = 1
start_row = local_rows * rank + 1

allocate(A(local_rows,local_cols), b(local_rows), x(local_cols))

t_start = mpi_wtime()

call make_hilbert_mat(A, start_row, start_col)
x = [(1_dp*i, i=1,local_cols)]
b = 0.0_dp
call gemv(A, x, b)

local_sum(1) = sum(b)

call mpi_reduce(local_sum, global_sum, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

t_end = mpi_wtime()

if (rank == 0) then
  print *, 'sum(x) = ', sum(x), 'sum(Ax) = ', global_sum, 'wtime =', t_end-t_start
end if

call mpi_finalize(ierr)

contains

subroutine make_hilbert_mat(A, start_row, start_col)
  real(kind=dp), intent(out) :: A(:,:)
  integer(kind=ik) :: i, j, start_row, start_col
  do j = 1, size(A,2)
    do i = 1, size(A,1)
      A(i,j) = 1_dp/(1.0_dp*(i+j + start_row -1 + start_col - 1 -1))
    end do
  end do
end subroutine

subroutine gemv(A, x, b)
  real(kind=dp), intent(in) :: A(:,:), x(:)
  real(kind=dp), intent(out) :: b(:)
  integer(kind=ik) :: i, j
  do j = 1, size(A, 2)
    do i = 1, size(A, 1)
      b(i) = b(i) + A(i,j)*x(j)
    end do
  end do
end subroutine

#include "gemv_utils.F90"

end program
