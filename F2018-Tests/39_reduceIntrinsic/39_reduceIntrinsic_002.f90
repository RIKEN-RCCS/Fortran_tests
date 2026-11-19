! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.11 [S3, S5]


program reduce_002
  implicit none
  integer :: v(4), n
  logical :: m(4)

  n = command_argument_count()
  v = [5, 3, 8, 1] + n
  m = [.false., .true., .true., .false.]
  write(*,'(A,I0)') 'first=', reduce(v, first)
  write(*,'(A,I0)') 'first_masked=', reduce(v, first, mask=m)
contains
  pure integer function first(a, b)
    integer, intent(in) :: a, b
    first = a
  end function first
end program reduce_002
! CHECK: first=5
! CHECK-NEXT: first_masked=3
