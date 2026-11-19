! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.5 [S1, S5, S6, S7]

program zeroWidthEditDescriptors_003
  implicit none
  integer, parameter :: dp = selected_real_kind(15)
  real(dp) :: p, f
  character(len=40) :: line
  integer :: n

  n = command_argument_count()
  p = 1250.0_dp + n
  f = 12.5_dp + n
  write(line,'(ss,g0.3)') p
  write(*,'(A,A,A)') 'g0.3_e=[', trim(line), ']'
  line = repeat('#', len(line))
  write(line,'(ss,g0.3,A)') f, '|'
  write(*,'(A,A,A)') 'g0.3_f=[', line(1:index(line, '|') - 1), ']'
end program zeroWidthEditDescriptors_003

! CHECK: g0.3_e=[{{0?}}.125{{(E\+04|\+004)}}]
! CHECK-NEXT: g0.3_f=[12.5]
