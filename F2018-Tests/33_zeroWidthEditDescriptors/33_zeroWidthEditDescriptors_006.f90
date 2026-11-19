! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.5 [S1, S4, S5]

program zeroWidthEditDescriptors_006
  implicit none
  integer, parameter :: dp = selected_real_kind(15)
  real(dp) :: p
  character(len=40) :: line
  integer :: n

  n = command_argument_count()
  p = 1250.0_dp + n
  write(line,'(ss,e0.4e0)') p
  write(*,'(A,A,A)') 'e0.4e0=[', trim(line), ']'
end program zeroWidthEditDescriptors_006

! CHECK: e0.4e0=[{{0?}}.1250E+4]
