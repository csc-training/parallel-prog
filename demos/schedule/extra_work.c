void frobnicate(int);

int extra_work(int n) {
  int m = 0;
  for (int k = 0; k < n; k++) {m = m + 1; if(m % 2) frobnicate(m);}
  return m;
}
