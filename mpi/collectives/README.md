## Collective operations

In this exercise we test different routines for collective communication.

Write a program for four MPI tasks. Each task should have a data vector with
the values initialised to:

|        |    |    |    |    |    |    |    |    |
|--------|----|----|----|----|----|----|----|----|
|Task 0: |  0 |  1 |  2 |  3 |  4 |  5 |  6 |  7 |
|Task 1: |  8 |  9 | 10 | 11 | 12 | 13 | 14 | 15 |
|Task 2: | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 |
|Task 3: | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 |

In addition, each task has a receive buffer for eight elements and the
values in the buffer are initialised to -1.

Implement communication that sends and receives values from the data
vectors to the receive buffers using a single collective routine in
each case, so that the receive buffers will have the following values.
You can start from scratch or use the skeleton code found in
[c/skeleton.c](c/skeleton.c) or [fortran/skeleton.F90](fortran/skeleton.F90).

### Case 1

|        |    |    |    |    |    |    |    |    |
|--------|----|----|----|----|----|----|----|----|
|Task 0: |  0 |  1 |  2 |  3 |  4 |  5 |  6 |  7 |
|Task 1: |  0 |  1 |  2 |  3 |  4 |  5 |  6 |  7 |
|Task 2: |  0 |  1 |  2 |  3 |  4 |  5 |  6 |  7 |
|Task 3: |  0 |  1 |  2 |  3 |  4 |  5 |  6 |  7 |

### Case 2

|        |    |    |    |    |    |    |    |    |
|--------|----|----|----|----|----|----|----|----|
|Task 0: |  0 |  1 | -1 | -1 | -1 | -1 | -1 | -1 |
|Task 1: |  2 |  3 | -1 | -1 | -1 | -1 | -1 | -1 |
|Task 2: |  4 |  5 | -1 | -1 | -1 | -1 | -1 | -1 |
|Task 3: |  6 |  7 | -1 | -1 | -1 | -1 | -1 | -1 |

### Case 3

|        |    |    |    |    |    |    |    |    |
|--------|----|----|----|----|----|----|----|----|
|Task 0: | -1 | -1 | -1 | -1 | -1 | -1 | -1 | -1 |
|Task 1: |  0 |  8 | 16 | 17 | 24 | 25 | 26 | 27 |
|Task 2: | -1 | -1 | -1 | -1 | -1 | -1 | -1 | -1 |
|Task 3: | -1 | -1 | -1 | -1 | -1 | -1 | -1 | -1 |

### Case 4

|        |    |    |    |    |    |    |    |    |
|--------|----|----|----|----|----|----|----|----|
|Task 0: |  0 |  1 |  8 |  9 | 16 | 17 | 24 | 25 |
|Task 1: |  2 |  3 | 10 | 11 | 18 | 19 | 26 | 27 |
|Task 2: |  4 |  5 | 12 | 13 | 20 | 21 | 28 | 29 |
|Task 3: |  6 |  7 | 14 | 15 | 22 | 23 | 30 | 31 |

### Case 5

|        |    |    |    |    |    |    |    |    |
|--------|----|----|----|----|----|----|----|----|
|Task 0: |  8 | 10 | 12 | 14 | 16 | 18 | 20 | 22 |
|Task 1: | -1 | -1 | -1 | -1 | -1 | -1 | -1 | -1 |
|Task 2: | 40 | 42 | 44 | 46 | 48 | 50 | 52 | 54 |
|Task 3: | -1 | -1 | -1 | -1 | -1 | -1 | -1 | -1 |

