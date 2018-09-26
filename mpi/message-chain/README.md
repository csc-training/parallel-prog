## Message chain

Write a program where every MPI task sends data to the next one.
Let `ntasks` be the number of the tasks, and `myid` the rank of the
current task. Your program should work as follows:

- Every task with a rank less than `ntasks-1` sends a message to task
  `myid+1`. For example, task 0 sends a message to task 1.
- The message content is an integer array where each element is initialised to
  `myid`.
- The message tag is the receiver's rank.
- The sender prints out the number of elements it sends and the tag it used.
- All tasks with rank > 0 receive messages.
- Each receiver prints out their `myid` and the first element in the
  received array.

1. Implement the program described above using `MPI_Send` and `MPI_Recv`. You
   may start from scratch or use the skeleton code
   ([c/skeleton.c](c/skeleton.c) or
   [fortran/skeleton.F90](fortran/skeleton.F90)) as a starting point.

2. Rewrite the program using `MPI_Sendrecv` instead of `MPI_Send` and
   `MPI_Recv`.

3. (Bonus) Can the code be simplified even further by using the
   `MPI_PROC_NULL` wildcard?

4. (Bonus) Use the status parameter to find out how much data was received,
   and print out this piece of information for all receivers.
