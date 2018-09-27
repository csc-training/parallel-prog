CC?=gcc-8

schedule: schedule.o extra_work.o
	$(CC) $(FFLAGS) -fopenmp $^ -o $@

%.o: %.c
	$(CC) $(FFLAGS) -fopenmp $< -c -o $@

clean: 
	rm *.o schedule
