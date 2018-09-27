#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <unistd.h>
#include <time.h>

struct timespec start, end;

void time_start();
double time_end();
int extra_work(int n);

int main(int argc, char *argv[])
{
  const int NX = 1000000;
  int nx, low, high, bias;

  if (argc > 1) { nx = atoi(argv[1]); } else nx = NX;

  int nthreads = omp_get_num_threads();

  bias = 82320;
  low = nx/10 + bias;
  high = nx/5 + bias;
  printf("%i < i and i < %i are slow indices out of %i:\n",low, high, nx);

  time_start();
#pragma omp parallel
    {
    int tid = omp_get_thread_num();
    int b = 0;
    long long m = 0;
#pragma omp for schedule(runtime)
    for (int i = 0; i < nx; i++) {
      b++;
      if (low < i & i < high) { m = m + extra_work(nx/100); }
    }
    printf("%i outer additions in thread %i, did %li extra work\n", b, tid, m);
    }
  time_end();

  printf("\n%i is slow thread:\n", 0);
  time_start();
#pragma omp parallel
    {
    int tid = omp_get_thread_num();
    int b = 0;
    long long m = 0;
#pragma omp for schedule(runtime)
    for (int i = 0; i < nx; i++) {
      b++;
      if(tid == 0) { m = m + extra_work(nx/100); }
    }
    printf("%i outer additions in thread %i, did %li extra work\n", b, tid, m);
    }
  time_end();
  return 0;
}

void time_start() {
  int ierr = clock_gettime(CLOCK_REALTIME, &start);
}

double time_end() {
  double time_used;
  int ierr = clock_gettime(CLOCK_REALTIME, &end);
  time_used = ((double) (end.tv_nsec-start.tv_nsec)) / 1e9 + (double) (end.tv_sec - start.tv_sec);
  printf("time: %f s\n", time_used);
}

void frobnicate(int m) { }
