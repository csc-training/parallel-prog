program datatype

  use mpi

  implicit none

  integer, dimension(8,8) :: array
  integer :: rank, ierr
  integer :: lower
  ! type(mpi_datatype) :: lower
  integer, dimension(8) :: blocks, displs
  integer :: i, j

  call mpi_init(ierr)
  call mpi_comm_rank(MPI_COMM_WORLD, rank ,ierr)

  ! initialize arrays
  if (rank == 0) then
    do i=1,8
      do j=1,8
        array(i,j) = i*10 + j
      end do
    end do
  else
    array(:,:) = 0
  end if

  ! Print out original array
  if (rank == 0) then
    do i=1,8
      write(*,'(8I3)') array(i, :)
    end do
  end if

  call mpi_barrier(MPI_COMM_WORLD, ierr)

  ! create datatype
  do i=1,8
    blocks(i) = 8 - (i - 1)
    displs(i) = 8*(i -1) + (i - 1)
  end do

  call mpi_type_indexed(8, blocks, displs, MPI_INTEGER, lower, ierr)
  call mpi_type_commit(lower, ierr)

  ! send lower diagonal of a matrix
  if (rank == 0) then
    call mpi_send(array, 1, lower, 1, 0, MPI_COMM_WORLD, ierr)
  else
    call mpi_recv(array, 1, lower, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
  end if

  ! Print out the result
  if (rank == 1) then
    do i=1,8
      write(*,'(8I3)') array(i, :)
    end do
  end if

  call mpi_type_free(lower, ierr)

  call mpi_finalize(ierr)

end program datatype
