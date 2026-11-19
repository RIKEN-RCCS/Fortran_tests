! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.10 [S4, S11]


program outOfRange_008
  implicit none
  logical, parameter :: p = out_of_range(2 * real(huge(0)), 0)

  write(*,'(A,L1)') 'parameter_value=', p
end program outOfRange_008
! CHECK: parameter_value=T
