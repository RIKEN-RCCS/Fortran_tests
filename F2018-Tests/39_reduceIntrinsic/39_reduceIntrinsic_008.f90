! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.11 [S1, S5]


program reduce_008
  implicit none
  integer :: v(4), n
  logical :: m(4)

  n = command_argument_count()
  v = [1, 2, 3, 4] + n
  m = [.true., .true., .false., .true.]
  write(*,'(A,I0)') 'keyword_all=', reduce(ordered=.true., identity=0, mask=m, dim=1, operation=add, array=v)
contains
  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add
end program reduce_008
! CHECK: keyword_all=7
