! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.5 [S1, S5, S7]

program zeroWidthEditDescriptors_001
  implicit none
  integer, parameter :: dp = selected_real_kind(15)
  real(dp) :: p, q, z, b
  character(len=40) :: line
  integer :: n

  n = command_argument_count()
  p = 1250.0_dp + n
  q = -1250.0_dp - n
  z = 0.0_dp + n
  b = 125000.0_dp + n
  write(line,'(ss,e0.3)') p
  write(*,'(A,A,A)') 'e0.3_pos=[', trim(line), ']'
  write(line,'(ss,e0.3)') q
  write(*,'(A,A,A)') 'e0.3_neg=[', trim(line), ']'
  write(line,'(ss,e0.3)') z
  write(*,'(A,A,A)') 'e0.3_zero=[', trim(line), ']'
  write(line,'(ss,d0.3)') p
  write(*,'(A,A,A)') 'd0.3_pos=[', trim(line), ']'
  write(line,'(ss,es0.3)') p
  write(*,'(A,A,A)') 'es0.3_pos=[', trim(line), ']'
  write(line,'(ss,es0.3)') q
  write(*,'(A,A,A)') 'es0.3_neg=[', trim(line), ']'
  write(line,'(ss,en0.3)') p
  write(*,'(A,A,A)') 'en0.3_pos=[', trim(line), ']'
  write(line,'(ss,en0.3)') b
  write(*,'(A,A,A)') 'en0.3_big=[', trim(line), ']'
end program zeroWidthEditDescriptors_001

! CHECK: e0.3_pos=[{{0?}}.125{{(E\+04|\+004)}}]
! CHECK-NEXT: e0.3_neg=[-{{0?}}.125{{(E\+04|\+004)}}]
! CHECK-NEXT: e0.3_zero=[{{0?}}.000{{(E\+00|\+000)}}]
! CHECK-NEXT: d0.3_pos=[{{0?}}.125{{(D\+04|E\+04|\+004)}}]
! CHECK-NEXT: es0.3_pos=[1.250{{(E\+03|\+003)}}]
! CHECK-NEXT: es0.3_neg=[-1.250{{(E\+03|\+003)}}]
! CHECK-NEXT: en0.3_pos=[1.250{{(E\+03|\+003)}}]
! CHECK-NEXT: en0.3_big=[125.000{{(E\+03|\+003)}}]
