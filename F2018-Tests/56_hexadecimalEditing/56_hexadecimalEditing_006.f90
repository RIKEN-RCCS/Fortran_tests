! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.30 [S5]

program hexadecimalEditing_006
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  character(12) :: buf
  real(dp) :: y
  integer :: ios, n

  n = command_argument_count()
  buf = '0X1.4P+1'
  y = -1.0_dp
  read(buf,'(ex12.1)',iostat=ios) y
  write(*,'(A,I0,A,L1)') 'read_hex_iostat=', ios, ' read_hex_is_2.5=', y == 2.5_dp + n
  buf = '2.5'
  y = -1.0_dp
  read(buf,'(ex12.1)',iostat=ios) y
  write(*,'(A,I0,A,L1)') 'read_decimal_iostat=', ios, ' read_decimal_is_2.5=', y == 2.5_dp + n
end program hexadecimalEditing_006

! CHECK: read_hex_iostat=0 read_hex_is_2.5=T
! CHECK-NEXT: read_decimal_iostat=0 read_decimal_is_2.5=T
