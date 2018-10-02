
program gemv_test
use iso_fortran_env, only: int64, real64
implicit none
integer, parameter :: ik = int64
integer, parameter :: dp = real64

integer(kind=ik), parameter  :: rows = 4,cols = 4
real(kind=dp), allocatable :: A(:,:), b(:), x(:)
integer(kind=ik) :: i

allocate(A(rows,cols), b(rows), x(rows))
call make_hilbert_mat(A)
x = [(1_dp*i, i=1,rows)]
b = 0.0_dp
call gemv(A, x, b)

#if 0
  call print_vec(x);
  call print_mat(A);
  call print_vec(b);
#endif

print *, 'sum(x) = ', sum(x), 'sum(Ax) = ', sum(b)
contains

subroutine make_hilbert_mat(A)
  real(kind=dp), intent(out) :: A(:,:)
  integer(kind=ik) :: i, j
  do j = 1, size(A,2)
    do i = 1, size(A,1)
      A(i,j) = 1_dp/(1.0_dp*(i+j-1))
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
