! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.11 [S5]


program comparisons_008
  use, intrinsic :: ieee_arithmetic
  implicit none
  integer :: i
  real :: equal, larger

  i = 3 + command_argument_count()
  equal = 3.0 + command_argument_count()
  larger = 5.0 + command_argument_count()
  write(*,'(A,6L2)') 'int(3)_vs_real(5) == >= > <= < /=', &
       i == larger, i >= larger, i > larger, i <= larger, i < larger, i /= larger
  write(*,'(A,6L2)') 'real(3)_vs_int(3) .eq. .ge. .gt. .le. .lt. .ne.', &
       equal .eq. i, equal .ge. i, equal .gt. i, equal .le. i, equal .lt. i, equal .ne. i
end program comparisons_008
! CHECK: int(3)_vs_real(5) == >= > <= < /= F F F T T T
! CHECK-NEXT: real(3)_vs_int(3) .eq. .ge. .gt. .le. .lt. .ne. T T F T F F
