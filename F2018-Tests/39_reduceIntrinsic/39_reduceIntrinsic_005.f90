! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.11 [S5, S6, S9]


program reduce_005
  implicit none
  integer :: v(4), n
  integer, allocatable :: e(:)

  n = command_argument_count()
  v = [1, 2, 3, 4] + n
  allocate(e(n))
  write(*,'(A,I0)') 'mask_scalar_true=', reduce(v, add, mask=.true.)
  write(*,'(A,I0)') 'mask_scalar_false=', reduce(v, add, mask=.false., identity=7)
  write(*,'(A,I0)') 'mask_all_false=', reduce(v, add, mask=[.false., .false., .false., .false.], identity=0)
  write(*,'(A,I0)') 'zero_size=', reduce(e, add, identity=-1)
  write(*,'(A,I0)') 'identity_not_used=', reduce([1, 2, 3] + n, add, mask=[.true., .false., .true.], identity=100)
contains
  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add
end program reduce_005
! CHECK: mask_scalar_true=10
! CHECK-NEXT: mask_scalar_false=7
! CHECK-NEXT: mask_all_false=0
! CHECK-NEXT: zero_size=-1
! CHECK-NEXT: identity_not_used=4
