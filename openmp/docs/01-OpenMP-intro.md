---
title:  Introduction to OpenMP
author: CSC Training
date:   2020
lang:   en
---


# Processes and threads

![](img/processes-threads.svg){.center width=90%}

<div class="column">
## Process

  - Independent execution units
  - Have their own state information and *own memory* address space
</div>

<div class="column">
## Thread

  - A single process may contain multiple threads
  - Have their own state information, but *share* the *same memory*
    address space
</div>


# Processes and threads

![](img/processes-threads-highlight-threads.svg){.center width=90%}

<div class="column">
## Process

  - Long-lived: spawned when parallel program started, killed when
    program is finished
  - Explicit communication between processes
</div>

<div class="column">
## Thread

  - Short-lived: created when entering a parallel region, destroyed
    (joined) when region ends
  - Communication through shared memory
</div>


# OpenMP {.section}


# What is OpenMP?

- A collection of _compiler directives_ and _library routines_ ,
  together with a _runtime system_, for
  **multi-threaded**, **shared-memory parallelization**
- Fortran 77/9X/03 and C/C++ are supported
- Latest version of the standard is 5.0 (November 2018)
    - Full support for accelerators (GPUs)
    - Support latest versions of C, C++ and Fortran
    - Support for a fully descriptive loop construct
    - and more
- Compiler support for 5.0 is still incomplete
- This course does not discuss any 5.0 specific features


# Why would you want to learn OpenMP?

- OpenMP parallelized program can be run on your many-core workstation or on a
  node of a cluster
- Enables one to parallelize one part of the program at a time
    - Get some speedup with a limited investment in time
    - Efficient and well scaling code still requires effort
- Serial and OpenMP versions can easily coexist
- Hybrid MPI+OpenMP programming


# Three components of OpenMP

- Compiler directives, i.e. language extensions, for shared memory
  parallelization
- Runtime library routines (Intel: libiomp5, GNU: libgomp)
    - Conditional compilation to build serial version
- Environment variables
    - Specify the number of threads, thread affinity etc.


# OpenMP directives

- OpenMP directives consist of "sentinel", followed by the directive
  name and optional clauses
- C/C++: 
```C
#pragma omp directive [clauses]
```
- Fortran: 
```Fortran
!$omp directive [clauses]
```
- Directives are ignored when code is compiled without OpenMP support


# Compiling an OpenMP program

- Compilers that support OpenMP usually require an option that enables the
  feature
    - GNU: `-fopenmp`
    - Intel: `-qopenmp`
    - Cray: `-h omp`
        * OpenMP enabled by default, -h noomp disables
    - PGI: `-mp[=nonuma,align,allcores,bind]`
    - Without these options a serial version is compiled!


# Parallel construct

<div class=column>
- Defines a parallel region
    - C/C++:
    ```C
	#pragma omp parallel [clauses]
	   structured block
	```
    - Fortran:
    ```fortran
	!$omp parallel [clauses]
	   structured block
	!$omp end parallel
	```
- Prior to region only one thread, master
- Creates a team of threads: master+slaves
- Barrier at the end of the block
</div>
<div class=column>
SPMD: Single Program Multiple Data
![](img/omp-parallel.png)

</div>


# Example: "Hello world" with OpenMP

<div class=column>
```fortran
program omp_hello

   write(*,*) "Obey your master!"
!$omp parallel
   write(*,*) "Slave to the grind"
!$omp end parallel
   write(*,*) "Back with master"

end program omp_hello
```
```bash
> gfortran -fopenmp omp_hello.F90 -o omp
> OMP_NUM_THREADS=3 ./omp
 Obey your master!
 Slave to the grind
 Slave to the grind
 Slave to the grind
 Back with master
```
</div>

<div class=column>
```c
#include <stdio.h>

int main(int argc, char* argv[]) 
{
   printf("Obey your master!\n");
#pragma omp parallel
 {
   printf("Slave to the grind\n");
 }
   printf("Back with master\n");
}
```
```bash
> gcc -fopenmp omp_hello.c -o omp
> OMP_NUM_THREADS=3 ./omp
Obey your master!
Slave to the grind
Slave to the grind
Slave to the grind
Back with master
```
</div>


# How to distribute work?

- Each thread executes the same code within the parallel region
- OpenMP provides several constructs for controlling work distribution
    - Loop construct
    - Single/Master construct
    - Sections construct
    - Task construct
    - Workshare construct (Fortran only)
- Thread id can be queried and used for distributing work manually
  (similar to MPI rank)

# Loop construct

- Directive instructing compiler to share the work of a loop
    - Each thread executes only part of the loop

```C
#pragma omp for [clauses]
...
```
```fortran
!$omp do [clauses]
...
!$omp end do
```
- in C/C++ limited only to "canonical" for-loops. Iterator base loops are also possible in C++
- Construct must reside inside a parallel region
    - Combined construct with omp parallel: \
          `#pragma omp parallel for` / `!$omp parallel do`


# Loop construct

```fortran
!$omp parallel
!$omp do
  do i = 1, n
     z(i) = x(i) + y(i)
  end do
!$omp end do
!$omp end parallel
```

```c
#pragma omp parallel
{
    #pragma omp for
    for (i=0; i < n; i++)
        z[i] = x[i] + y[i];
}
```


# Summary

- OpenMP can be used with compiler directives
    - Neglected when code is build without OpenMP
- Threads are launched within **parallel** regions
- `for`/`do` loops can be parallelized easily with loop construct
