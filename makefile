CXX = icpx
CC=icx
FC=ifx
CXXFLAGS = -fsycl
FFLAGS= -g -fiopenmp -fiopenmp -fopenmp-targets=spir64_gen -Xopenmp-target-backend=spir64_gen "-device pvc" -qmkl=parallel -fpp -free
LDFLAGS= -g -fiopenmp -fopenmp-targets=spir64_gen -Xopenmp-target-backend=spir64_gen "-device pvc" -qmkl=parallel -fsycl -L${MKLROOT}/lib/intel64 -liomp5 -lsycl -lOpenCL -lstdc++ -lpthread -lm -ldl -lmkl_sycl
MOD = gpuinitialize.o
offload.x: offload.o timing.o gpuinit.o $(MOD)
	$(FC) $(LDFLAGS) offload.o timing.o gpuinit.o -o $@
timing.o: timing.c timing.h
	$(CC) -c timing.c
%.o: %.f90 $(MOD) 
	$(FC) $(FFLAGS) -c  $<
%.o: %.c $(MOD) 
	$(CC) $(FFLAGS) -c  $<
%.o: %.cpp 
	$(CXX) $(CXXFLAGS) -c  $<
clean:
	rm -rf *.o *.x *.mod *.modmic
