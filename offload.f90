include "mkl_omp_offload.f90"
program main
  use gpuinitialize
  use onemkl_blas_omp_offload_lp64
  use omp_lib
  use iso_fortran_env
  implicit none

  integer, parameter :: MAXDIM = 1012
  integer            :: NDIM 
!$omp requires unified_shared_memory
  double precision,  allocatable:: aa(:,:)
  double precision,  allocatable:: bb(:,:)
  double precision,  allocatable:: cc(:,:)

  integer :: status, i, j, error, istat
  double precision  :: alpha, beta
  double precision::wcStart,wcEnd
  integer(4)::get_walltime
  external get_walltime
  logical :: is_cpu = .true.

  error = 0
  alpha = 1d0
  beta = 0d0

 !call getproperties()

!hh!$omp allocate allocator(omp_target_shared_mem_alloc)
    allocate(aa(MAXDIM,MAXDIM),bb(MAXDIM,MAXDIM),cc(MAXDIM,MAXDIM))
  


print *
print *,"Executing on host"

open(10,file="timing.cpu")

!  print '(1x,A10,I8)',"NDIM*NDIM= ",NDIM*NDIM
  write(10,fmt='(1x,A40)') "NDIM | CPU time (sec) | GPU time  (sec)"
do NDIM=8,MAXDIM,8 
  write(10,fmt='(1x,I8)',advance="no") NDIM

        aa=0.0D0
        cc=0.0D0
        do i=1,NDIM
        do j=1,NDIM
        aa(i,j)=1.0D0
        bb(i,j) = ((i-1)*2+j)*2.0d0
        enddo
        enddo

        istat=get_walltime(wcStart)
        do i=1,12
                alpha=0.1*real(i)
                call Dgemm('N', 'N',  &
                NDIM, NDIM,NDIM, alpha, aa, &
                NDIM, bb, NDIM, beta,cc, NDIM);
        enddo
        istat=get_walltime(wcEnd)

        write (10,fmt='(1x,A22,ES10.3,A8)',advance="no") "Elapsed time on CPU:",wcEnd-wcStart,"seconds"
        write(10,fmt='(1x,ES10.3)') cc(8,8)
enddo

close(10)


!! check if device is present

call DPCPPinit()


open(11,file="timing.gpu")

print * 
print *,"Executing on device"

cc=0.0D0

write(11,fmt='(1x,A40)') "NDIM | CPU time (sec) | GPU time  (sec)"
do NDIM=8,MAXDIM,8
  write(11,fmt='(1x,I8)',advance="no") NDIM

!$omp target map(tofrom: is_cpu) has_device_addr(aa,bb,cc)
        istat=get_walltime(wcStart)
        do i=1,12
                alpha=0.1*real(i)
!$omp dispatch
                call Dgemm('N', 'N',  &
                NDIM, NDIM,NDIM, alpha, aa, &
                NDIM, bb, NDIM, beta,cc, NDIM);
        enddo
        istat=get_walltime(wcEnd)
!$omp end target
        write (11,fmt='(1x,A22,ES10.3,A8)',advance="no") "Elapsed time on CPU:",wcEnd-wcStart,"seconds"
        write(11,fmt='(1x,ES10.3)') cc(8,8)
enddo


end program main

