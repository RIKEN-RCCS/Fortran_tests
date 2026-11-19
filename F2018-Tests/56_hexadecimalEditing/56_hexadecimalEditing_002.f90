! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.30 [S1, S7]

program hexadecimalEditing_002
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  character(40) :: buf
  real(dp) :: x
  integer :: n

  n = command_argument_count()
  x = 0.0_dp + n
  write(buf,'(ss,ex0.1)') x
  write(*,'(A)') 'ex0.1_zero=[' // trim(buf) // ']'
end program hexadecimalEditing_002

! CHECK: ex0.1_zero=[0X0.0P+0]
