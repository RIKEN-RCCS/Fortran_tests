! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.11 [S3, S8]


program reduce_001
  implicit none
  integer :: v(4), n

  n = command_argument_count()
  v = [1, 2, 3, 4] + n
  write(*,'(A,I0)') 'sum=', reduce(v, add)
  write(*,'(A,I0)') 'ordered_false=', reduce(v, add, ordered=.false.)
  write(*,'(A,L1)') 'result_kind_ok=', kind(reduce(v, add)) == kind(0)
contains
  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add
end program reduce_001
! CHECK: sum=10
! CHECK-NEXT: ordered_false=10
! CHECK-NEXT: result_kind_ok=T
