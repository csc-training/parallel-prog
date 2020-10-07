program omp_hello

   write(*,*) "Obey your master!"
!$omp parallel
   write(*,*) "Slave to the grind"
!$omp end parallel
   write(*,*) "Back with master"

end program omp_hello
