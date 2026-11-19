! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.30 [S1, S3, S4, S6]

program hexadecimalEditing_001
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  character(40) :: buf
  real(dp) :: x
  real :: s
  integer :: n

  n = command_argument_count()
  x = 2.5_dp + n
  write(buf,'(ss,ex0.1)') x
  write(*,'(A)') 'ex0.1_2.5=[' // trim(buf) // ']'
  x = -3.0_dp - n
  write(buf,'(ss,ex0.1)') x
  write(*,'(A)') 'ex0.1_-3.0=[' // trim(buf) // ']'
  x = 0.75_dp + n
  write(buf,'(ss,ex0.1)') x
  write(*,'(A)') 'ex0.1_0.75=[' // trim(buf) // ']'
  x = 10.0_dp + n
  write(buf,'(ss,ex0.1)') x
  write(*,'(A)') 'ex0.1_10.0=[' // trim(buf) // ']'
  s = 2.5 + n
  write(buf,'(ss,ex0.1)') s
  write(*,'(A)') 'ex0.1_2.5_default_real=[' // trim(buf) // ']'
end program hexadecimalEditing_001

! CHECK: ex0.1_2.5=[{{0X1\.4P\+1|0X2\.8P\+0|0X5\.0P-1|0XA\.0P-2}}]
! CHECK-NEXT: ex0.1_-3.0=[-{{0X1\.8P\+1|0X3\.0P\+0|0X6\.0P-1|0XC\.0P-2}}]
! CHECK-NEXT: ex0.1_0.75=[{{0X1\.8P-1|0X3\.0P-2|0X6\.0P-3|0XC\.0P-4}}]
! CHECK-NEXT: ex0.1_10.0=[{{0X1\.4P\+3|0X2\.8P\+2|0X5\.0P\+1|0XA\.0P\+0}}]
! CHECK-NEXT: ex0.1_2.5_default_real=[{{0X1\.4P\+1|0X2\.8P\+0|0X5\.0P-1|0XA\.0P-2}}]
