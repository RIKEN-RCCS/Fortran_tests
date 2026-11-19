! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.31 [S1, S2, S3, S4]


program statVariablePrecision_001
  implicit none
  integer, parameter :: k4 = selected_int_kind(4)
  integer, parameter :: k18 = selected_int_kind(18)
  integer, allocatable :: x(:)
  integer(k4) :: s4
  integer :: sd
  integer(k18) :: s18
  integer :: n
  n = 3 + command_argument_count()

  allocate(x(n), stat=s4)
  write(*,'(A,I0)') 'k4_alloc=', s4
  allocate(x(n), stat=s4)
  write(*,'(A,L1)') 'k4_alloc_again_positive=', s4 > 0
  deallocate(x, stat=s4)
  write(*,'(A,I0)') 'k4_dealloc=', s4
  deallocate(x, stat=s4)
  write(*,'(A,L1)') 'k4_dealloc_again_positive=', s4 > 0

  allocate(x(n), stat=sd)
  write(*,'(A,I0)') 'kd_alloc=', sd
  allocate(x(n), stat=sd)
  write(*,'(A,L1)') 'kd_alloc_again_positive=', sd > 0
  deallocate(x, stat=sd)
  write(*,'(A,I0)') 'kd_dealloc=', sd
  deallocate(x, stat=sd)
  write(*,'(A,L1)') 'kd_dealloc_again_positive=', sd > 0

  allocate(x(n), stat=s18)
  write(*,'(A,I0)') 'k18_alloc=', s18
  allocate(x(n), stat=s18)
  write(*,'(A,L1)') 'k18_alloc_again_positive=', s18 > 0
  deallocate(x, stat=s18)
  write(*,'(A,I0)') 'k18_dealloc=', s18
  deallocate(x, stat=s18)
  write(*,'(A,L1)') 'k18_dealloc_again_positive=', s18 > 0

  write(*,'(A,L1)') 'continued=', .true.
end program statVariablePrecision_001
! CHECK: k4_alloc=0
! CHECK-NEXT: k4_alloc_again_positive=T
! CHECK-NEXT: k4_dealloc=0
! CHECK-NEXT: k4_dealloc_again_positive=T
! CHECK-NEXT: kd_alloc=0
! CHECK-NEXT: kd_alloc_again_positive=T
! CHECK-NEXT: kd_dealloc=0
! CHECK-NEXT: kd_dealloc_again_positive=T
! CHECK-NEXT: k18_alloc=0
! CHECK-NEXT: k18_alloc_again_positive=T
! CHECK-NEXT: k18_dealloc=0
! CHECK-NEXT: k18_dealloc_again_positive=T
! CHECK-NEXT: continued=T
