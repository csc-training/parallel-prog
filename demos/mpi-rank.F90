program rank
  use mpi
  implicit none
  integer :: rc, myid, ntasks

  call MPI_INIT(rc)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, ntasks, rc)
  call MPI_COMM_RANK(MPI_COMM_WORLD, myid, rc)

  write(*,*) 'MPI tasks:', ntasks, '  My rank:', myid

  call MPI_FINALIZE(rc)

end program rank
