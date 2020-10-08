---
title:  OpenMP reductions and execution control
author: CSC Training
date:   2020
lang:   en
---

# OpenMP reductions {.section}


# Race condition in reduction

- Race conditions take place when multiple threads read and write a variable
  simultaneously, for example:

```fortran
asum = 0.0d0
!$omp parallel do shared(x,y,n,asum) private(i)
  do i = 1, n
     asum = asum + x(i)*y(i)
  end do
!$omp end parallel do
```

- Random results depending on the order the threads access **asum**
- We need some mechanism to control the access


# Reductions

- Summing elements of array is an example of reduction operation

$$
S = \sum_{j=1}^{N} A_j = \sum_{j=1}^{\frac{N}{2}} A_j +
\sum_{j=\frac{N}{2} + 1}^{N} A_j = B_1 + B_2 = \sum_{j=1}^{2} B_j
$$

- OpenMP provides support for common reductions within parallel regions and
  loops with the reduction clause


# Reduction clause

`reduction(operator:list)`
  : Performs reduction on the (scalar) variables in list
  : `-`{.ghost}



- Private reduction variable is created for each thread's partial result
- Private reduction variable is initialized to operator's initial value
- After parallel region the reduction operation is applied to private
  variables and result is aggregated to the shared variable




# Reduction operators in C/C++ 
<div class="column">

| Operator | Initial value |
|----------|---------------|
| `+`     | `0`           |
| `-`      | `0`           |
| `*`      | `1`           |
| `&&`     | `1`           |
| `||`     | `0`           |

</div>

<div class="column">
| Bitwise Operator | Initial value |
|----------|---------------|
| `&`      | `~0`          |
| `|`      | `0`           |
| `^`      | `0`           |
</div>

# Reduction operators in Fortran

<small>
<div class="column">
| Operator         | Initial value |
|------------------|---------------|
| `+`              | `0`           |
| `-`              | `0`           |
| `*`              | `1`           |
| `max`            | least         |
| `min`            | largest       |
| `.and.`          | `.true.`      |
| `.or.`           | `.false.`     |
| `.eqv.`          | `.true.`      |
| `.neqv.`         | `.false.`     |
</div>

<div class="column">
| Bitwise Operator | Initial value |
|------------------|---------------|
| `.iand.`           | all bits on   |
| `.ior.`            | `0`           |
| `.ieor.`           | `0`           |
</div>

</small>

# Race condition avoided with reduction clause

```fortran
!$omp parallel do shared(x,y,n) private(i) reduction(+:asum)
  do i = 1, n
     asum = asum + x(i)*y(i)
  end do
!$omp end parallel do
```
```c
#pragma omp parallel for shared(x,y,n) private(i) reduction(+:asum)
for(i=0; i < n; i++) {
    asum = asum + x[i] * y[i];
}
```

# OpenMP execution controls {.section}

# Execution controls

- Sometimes a part of parallel region should be executed only by the
  master thread or by a single thread at time 
    - IO, initializations, updating global values, etc.
    - Remember the synchronization!
- OpenMP provides clauses for controlling the execution of code blocks

# Failing example

```c
#pragma omp parallel shared(global_counter) private(tnum, delay, rem)
{
  tnum = omp_get_thread_num();
  delay.tv_sec = 0;
  delay.tv_nsec = 10000 * tnum;
  do {
    printf("This is iteration %i\n", global_counter);
    global_counter++; /* Race condition! */
    nanosleep(&delay, &rem);
  } while(global_counter < 10);
}
```

# Execution control constructs

`barrier`
  : `-`{.ghost}

- When a thread reaches a barrier it only continues after all the threads in the same thread team have reached it
    - Each barrier must be encountered by all threads in a team, or none at all
    -The sequence of work-sharing regions and barrier regions encountered must be same for all threads in team
- Implicit barrier at the end of: `do`, `parallel`, `single`, `workshare`

# Execution control constructs

`master`
  : `-`{.ghost}
   
- Specifies a region that should be executed only by the master thread
- Note that there is no implicit barrier at end


`single`
  : `-`{.ghost}
    
- Specifies that a regions should be executed only by a single (arbitrary) thread
- Other threads wait (implicit barrier)

# Execution control constructs

`critical[(name)]`
  : `name` Optional name specifies global identifier for critical section
  : `-`{.ghost}
  
- A section that is executed by only one thread at a time
- Unnamed critical sections are treated as the same section


# Execution control constructs

`atomic`
  : `-`{.ghost}

- Strictly limited construct to update a single value, can not be applied to code blocks
- Only guarantees atomic update, does not protect function calls
- Can be faster on hardware platforms that support atomic updates

# Example: reduction using critical section

```fortran
!$OMP PARALLEL SHARED(x,y,n,asum) PRIVATE(i, psum)
  psum = 0.0d
  !$OMP DO
  do i = 1, n
    psum = psum + x(i)*y(i)
  end do
  !$OMP END DO
  !$OMP CRITICAL(dosum)
  asum = asum + psum
  !$OMP END CRITICAL(dosum)
!$OMP END PARALLEL
```

# Example: initialization and output

```c
int total = 0;
#pragma omp parallel shared(total) private(sum,new)
{
#pragma omp single
  initialise();

  int new, sum = 0;
  do {
    new = compute_something();
    sum += new;
  } while (new);
#pragma omp barrier
#pragma omp critical(addup)
  total += sum;
#pragma omp master
  printf("Grand total is: %5.2f\n", total);
}
```

# Summary

- Several parallel reduction operators available via `reduction` clause 
- OpenMP has many synchronization pragmas
    - Critical sections
    - Atomic
    - Single and Master
    - And some that we did not present
	
# OpenMP programming best practices

- Maximise parallel regions
    - Reduce fork-join overhead, e.g. combine multiple parallel loops into one
      large parallel region
    - Potential for better cache re-usage
- Parallelise outermost loops if possible
    - Move PARALLEL DO construct outside of inner loops
- Reduce access to shared data
    - Possibly make small arrays private
- Use more tasks than threads
    - Too large number of tasks leads to performance loss


# OpenMP summary

- OpenMP is an API for thread-based parallelisation
    - Compiler directives, runtime API, environment variables
    - Relatively easy to get started but specially efficient and/or real-world
      parallelisation non-trivial
- Features touched in this intro
    - Parallel regions, data-sharing attributes
    - Work-sharing, reductions, execution control


# OpenMP summary

![](img/omp-summary.png)


# Things that we did not cover

- Adjusting scheduling of `for` / `do` work-sharing constructs
- Other work-sharing constructs:
    - `workshare`, `sections`, `simd`
    - `teams`, `distribute`
- Task based parallelisation with `task` consturct
- More advanced ways to reduce synchronisation overhead with `nowait` and
  `flush`
- Support for attached devices with `target`

# Web resources

- OpenMP homepage: <http://openmp.org/>
- Good online tutorial: <https://computing.llnl.gov/tutorials/openMP/>
- More online tutorials: <http://openmp.org/wp/resources/#Tutorials>
