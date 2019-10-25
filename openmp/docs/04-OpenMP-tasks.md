---
title:  OpenMP tasks
author: CSC Training
date:   2019-07
lang:   en
---



# Task parallelisation {.section}


# Limitations of work sharing so far

- Number of iterations in a loop must be constant
    - No while loops or early exits in for/do loops
- All the threads have to participate in workshare
- OpenMP provides also dynamic tasking in addition to static sections
- Irregular and dynamical parallel patterns via tasking
    - While loops
    - Recursion


# What is a task in OpenMP?

- A task has
    - Code to execute
    - Data environment
    - Internal control variables
- Tasks are added to a task queue, and executed then by single thread
    - Can be same or different thread that created the task
    - OpenMP runtime takes care of distributing tasks to threads


# OpenMP task construct

- Create a new task and add it to task queue
    - Memorise data and code to be executed
    - Task constructs can arbitrarily nested
- Syntax (C/C++)
    ```c
    #pragma omp task [clause[[,] clause],...]
    {
        ...
    }
    ```
- Syntax (Fortran)
    ```fortran
    !$omp task[clause[[,] clause],...]
    ...
    !$omp end task
    ```


# OpenMP task construct

- All threads that encounter the construct create a task
- Typical usage pattern is thus that single thread creates the tasks

```c
#pragma omp parallel
#pragma omp single
{
    int i=0;
    while (i < 12) {
        #pragma omp task
        {
            printf("Task %d by thread %d\n", i, omp_get_thread_num());
        }
        i++;
    }
}
```


# OpenMP task construct

How many tasks does the following code create when executed with 4 threads?
`a) 6  b) 4  c) 24`

```c
#pragma omp parallel
{
    int i=0;
    while (i < 6) {
        #pragma omp task
        {
            do_some_heavy_work();
        }
        i++;
    }
}

```


# Task execution model

- Tasks are executed by an arbitrary thread
    - Can be same or different thread that created the task
    - By default, tasks are executed in arbitrary order
    - Each task is executed only once
- Synchronisation points
    - Implicit or explicit barriers
    - `#pragma omp taskwait / !$omp taskwait`
        - Encountering task suspends until child tasks complete


# Data environment of a task

- Tasks are created at one time, and executed at another
    - What data does the task see when executing?
- Variables that are `shared` in the enclosing construct contain the data at
  the time of execution
- Variables that are `private` in the enclosing construct are made
  `firstprivate` and contain the data at the time of creation
- Data scoping clauses (`shared`, `private`, `firstprivate`, `default`) can
  change the default behaviour


# Data environment of a task

What is the value of i that is printed out? `a) 0  b) 6  c) 100`

```c
#pragma omp parallel
{
    int i=0;
    #pragma omp master
    {
        while (i < 6) {
            #pragma omp task
            if (omp_get_thread_num() != 0)
                i=100;
            i++;
        }
    }
    #pragma omp barrier
    if (omp_get_thread_num() == 0)
        printf("i is %d\n", i);
}
```


# Data environment of a task

What is the value of i that is printed out? ` a) 0  b) 6  c) >= 100`

```c
#pragma omp parallel
{
    int i=0;
    #pragma omp master
    {
        while (i < 6) {
            #pragma omp task shared(i)
            if (omp_get_thread_num() != 0)
                i=100;
            i++;
        }
    }
    #pragma omp barrier
    if (omp_get_thread_num() == 0)
        printf("i is %d\n", i);
}
```


# Recursive algorithms with tasks

- A task can itself generate new tasks
    - Useful when parallelising recursive algorithms
- Recursive algorithm for Fibonacci numbers:
  $F_0=0, \quad F_1=1, \quad F_n = F_{n-1} + F_{n-2}$

<div class=column>
```c
#pragma omp parallel
{
    # pragma omp single
    fibonacci(10);
}
```
</div>

<div class=column>
```c
int fibonacci(int n) {
    int fn, fnm;
    if (n < 2)
        return n;
    #pragma omp task shared(fn)
    fn = fibonacci(n-1);
    #pragma omp task shared(fnm)
    fnm = fibonacci(n-2);
    #pragma omp taskwait
    return fn+fnm;
}
```
</div>


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
    - Work-sharing and scheduling directives
    - Task based parallelisation


# OpenMP summary

![](img/omp-summary.png)


# Things that we did not cover

- Other work-sharing clauses:
    - `workshare`, `sections`, `simd`
    - `teams`, `distribute`
- More advanced ways to reduce synchronisation overhead with `nowait` and
  `flush`
- `threadprivate`, `copyin`, `cancel`
- A user can define dependencies between tasks with the `depend` clause
- Support for attached devices with `target`


# Web resources

- OpenMP homepage: <http://openmp.org/>
- Good online tutorial: <https://computing.llnl.gov/tutorials/openMP/>
- More online tutorials: <http://openmp.org/wp/resources/#Tutorials>
