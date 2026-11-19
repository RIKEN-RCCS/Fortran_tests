! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.11 [S4]


program reduce_003
  implicit none
  real :: x(3), z

  z = real(command_argument_count())
  x = [1.0 + z, -1.0 - z, 1.0e-20]
  write(*,'(A,L1)') 'ordered_sum_is_1e-20=', reduce(x, add, ordered=.true.) == 1.0e-20
contains
  pure real function add(a, b)
    real, intent(in) :: a, b
    add = a + b
  end function add
end program reduce_003
! CHECK: ordered_sum_is_1e-20=T
