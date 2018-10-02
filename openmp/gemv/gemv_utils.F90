subroutine print_vec(x)
  implicit none
  real(kind=dp) :: x(:)
  integer(kind=ik) :: i
  do i = 1,size(x,1)
    print *, x(i)
  end do
end subroutine

subroutine print_mat(A)
  implicit none
  real(kind=dp) :: A(:,:)
  integer(kind=ik) :: i
  do i = 1,size(A,1)
    print *, A(i,:)
  end do
end subroutine
