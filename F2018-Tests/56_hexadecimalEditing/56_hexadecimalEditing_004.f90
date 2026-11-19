! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.30 [S1, S2, S3, S4]

program hexadecimalEditing_004
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  character(12) :: b12
  character(14) :: b14
  character(40) :: buf
  real(dp) :: x
  integer :: n

  n = command_argument_count()
  x = 3.0_dp + n
  write(b12,'(ss,ex12.4)') x
  write(*,'(A)') 'ex12.4_3.0=[' // b12 // ']'
  write(b14,'(ss,ex14.4e3)') x
  write(*,'(A)') 'ex14.4e3_3.0=[' // b14 // ']'
  x = 0.75_dp + n
  write(buf,'(ss,ex0.2e0)') x
  write(*,'(A)') 'ex0.2e0_0.75=[' // trim(buf) // ']'
end program hexadecimalEditing_004

! CHECK: ex12.4_3.0=[ {{0X1\.8000P\+1|0X3\.0000P\+0|0X6\.0000P-1|0XC\.0000P-2}}]
! CHECK-NEXT: ex14.4e3_3.0=[ {{0X1\.8000P\+001|0X3\.0000P\+000|0X6\.0000P-001|0XC\.0000P-002}}]
! CHECK-NEXT: ex0.2e0_0.75=[{{0X1\.80P-1|0X3\.00P-2|0X6\.00P-3|0XC\.00P-4}}]
