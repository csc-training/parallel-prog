# OpenMP schedule demo

Run with
```bash
$ OMP_SCHEDULE=<schedule> OMP_NUM_THREADS=<nthreads> ./schedul <n_work>
```

where `<schedule>` is `static, dynamic, ...` and `<n_work>` is an integer size of the
problem.

Try to make choose `n_work` big enough to see the difference in cpu utilization.
