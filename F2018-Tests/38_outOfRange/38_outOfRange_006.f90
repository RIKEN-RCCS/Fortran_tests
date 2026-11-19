! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S1, S4]


program outOfRange_006
  implicit none
  real :: h2, z
  real :: x(4)
  real, allocatable :: e(:)

  z = real(command_argument_count())
  h2 = 2 * real(huge(0)) + z
  x = [1.0, -1.0, h2, -h2]
  allocate(e(command_argument_count()))
  write(*,'(A,L1,3(1X,L1))') 'rank1=', out_of_range(x, 0)
  write(*,'(A,I0)') 'rank1_shape=', size(out_of_range(x, 0))
  write(*,'(A,I0)') 'zero_size=', size(out_of_range(e, 0))
end program outOfRange_006
! CHECK: rank1=F F T T
! CHECK-NEXT: rank1_shape=4
! CHECK-NEXT: zero_size=0
