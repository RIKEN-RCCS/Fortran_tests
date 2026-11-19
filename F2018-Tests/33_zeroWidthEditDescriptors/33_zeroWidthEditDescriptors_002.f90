! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.5 [S1, S5, S7]

program zeroWidthEditDescriptors_002
  implicit none
  integer, parameter :: dp = selected_real_kind(15)
  real(dp) :: s, h
  character(len=40) :: line
  integer :: n

  n = command_argument_count()
  s = 0.0005_dp + n
  h = 1.0e100_dp + n
  write(line,'(ss,e0.3)') s
  write(*,'(A,A,A)') 'e0.3_small=[', trim(line), ']'
  write(line,'(ss,es0.3)') s
  write(*,'(A,A,A)') 'es0.3_small=[', trim(line), ']'
  write(line,'(ss,e0.3)') h
  write(*,'(A,A,A)') 'e0.3_huge=[', trim(line), ']'
end program zeroWidthEditDescriptors_002

! CHECK: e0.3_small=[{{0?}}.500{{(E-03|-003)}}]
! CHECK-NEXT: es0.3_small=[5.000{{(E-04|-004)}}]
! CHECK-NEXT: e0.3_huge=[{{0?}}.100+101]
