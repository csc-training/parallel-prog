## Reduction and critical

Fix the model "solution" of the [../race-condition/](previous exercise) that
still contains a race condition ([../race-condition/solution/sum.c](sum.c) or
[../race-condition/solution/sum.F90](sum.F90)).

1. Use `reduction` clause to compute the sum correctly.

2. Implement an alternative version where each thread computes its
   own part to a private variable and the use a `critical` section after
   the loop to compute the global sum.

Try to compile and run your code also without OpenMP.
