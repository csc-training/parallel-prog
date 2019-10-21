## General exercise instructions

For most of the exercises, skeleton codes are provided both for Fortran and C
in the corresponding subdirectory. Some exercise skeletons have sections
marked with “TODO” for completing the exercises. In addition, all of the
exercises have exemplary full codes (that can be compiled and run) in the
`solutions` folder. Note that these are seldom the only or even the best way to
solve the problem.

The exercise material can be downloaded with the command

```
git clone https://github.com/csc-training/parallel-prog.git
```

If you have a GitHub account you can also **Fork** this repository and clone then your fork.

### Computing servers

Exercises can be carried out using the workstations in CSC training class. 

For editing program source files you can use e.g. *gedit* editor: 

```
gedit prog.f90 &
```

Also other popular editors (emacs, vim, nano) are available.

In case you have working parallel program development environment in your
laptop (Fortran or C compiler, MPI development library, etc.) you may also use
that.

## Compilation and execution

### MPI

In the CSC training class the MPI environment needs to be initialized as follows:
```
module load mpi/openmpi-x86_64
```

Compilation of the MPI programs can then be performed with the `mpif90` and `mpicc` wrapper
commands:
```
mpif90 –o my_mpi_exe test.f90
```
or
```
mpicc –o my_mpi_exe test.c
```

The wrapper commands include automatically all the flags needed for building
MPI programs.

The programs can be executed as
```
mpirun –np 4 ./my_mpi_exe
```

### OpenMP

OpenMP programs can be compiled with `gfortran` and `gcc` commands together with the `-fopenmp`
flag:
```
mpif90 –o my_omp_exe -fopenmp test.f90
```
or
```
mpicc –o my_omp_exe -fopenmp test.c
```

The number of threads for OpenMP programs can be specified with `OMP_NUM_THREADS`: 

```
OMP_NUM_THREADS=4 ./my_omp_exe
```

Similarly, a hybrid MPI+OpenMP would be invoked for example as
```
OMP_NUM_THREADS=4 mpirun -np 4 ./my_hybrid_exe
```

## Puhti supercomputer

In case you have a CSC user account, the exercises can be done in Puhti supercomputer. See Puhti documentation for [compiling](https://docs.csc.fi/#computing/compiling/) and [running](https://docs.csc.fi/#computing/running/getting-started/) programs.
