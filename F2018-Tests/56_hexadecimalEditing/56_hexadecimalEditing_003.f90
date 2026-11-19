! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.30 [S1, S2, S3]

program hexadecimalEditing_003
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  character(40) :: buf
  real(dp) :: x
  integer :: n

  n = command_argument_count()
  x = 2.5_dp + n
  write(buf,'(ss,ex0.0)') x
  write(*,'(A)') 'ex0.0_2.5=[' // trim(buf) // ']'
  x = 10.0_dp + n
  write(buf,'(ss,ex0.0)') x
  write(*,'(A)') 'ex0.0_10.0=[' // trim(buf) // ']'
end program hexadecimalEditing_003

! CHECK: ex0.0_2.5=[{{0X1\.4P\+1|0X2\.8P\+0|0X5\.P-1|0XA\.P-2}}]
! CHECK-NEXT: ex0.0_10.0=[{{0X1\.4P\+3|0X2\.8P\+2|0X5\.P\+1|0XA\.P\+0}}]
