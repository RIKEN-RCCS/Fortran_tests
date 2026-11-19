! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck --strict-whitespace %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck --strict-whitespace %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck --strict-whitespace %s %}

! SPEC: N2161 5.5 [S4, S5]

program zeroWidthEditDescriptors_005
  implicit none
  integer, parameter :: dp = selected_real_kind(15)
  real(dp) :: p, h
  character(len=12) :: line
  integer :: n

  n = command_argument_count()
  p = 1250.0_dp + n
  h = 0.5_dp + n
  write(line,'(ss,e12.4e0)') p
  write(*,'(A,A,A)') 'e12.4e0=[', line, ']'
  write(line,'(ss,e12.4e0)') h
  write(*,'(A,A,A)') 'e12.4e0_zero_exp=[', line, ']'
end program zeroWidthEditDescriptors_005

! CHECK: e12.4e0=[{{(   0| {4})}}.1250E+4]
! CHECK-NEXT: e12.4e0_zero_exp=[{{(   0| {4})}}.5000E+0]
