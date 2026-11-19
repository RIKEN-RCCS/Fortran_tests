! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.11 [S3, S7]


program reduce_004
  implicit none
  integer :: a(2, 3), n

  n = command_argument_count()
  a = reshape([1, 2, 3, 4, 5, 6] + n, [2, 3])
  write(*,'(A,I0,2(1X,I0))') 'add_dim1=', reduce(a, add, 1)
  write(*,'(A,I0,1X,I0)') 'add_dim2=', reduce(a, add, 2)
  write(*,'(A,I0,2(1X,I0))') 'first_dim1=', reduce(a, first, 1)
  write(*,'(A,I0,1X,I0)') 'first_dim2=', reduce(a, first, 2)
  write(*,'(A,I0)') 'rank1_dim1_rank=', size(shape(reduce([1, 2, 3] + n, add, 1)))
contains
  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add
  pure integer function first(a, b)
    integer, intent(in) :: a, b
    first = a
  end function first
end program reduce_004
! CHECK: add_dim1=3 7 11
! CHECK-NEXT: add_dim2=9 12
! CHECK-NEXT: first_dim1=1 3 5
! CHECK-NEXT: first_dim2=1 2
! CHECK-NEXT: rank1_dim1_rank=0
