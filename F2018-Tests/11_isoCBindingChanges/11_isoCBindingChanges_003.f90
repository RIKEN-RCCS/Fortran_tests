! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.11 [S4, S5]

module m
  use, intrinsic :: iso_c_binding
  implicit none
contains
  function noninterop_add(x, y) result(r)
    integer, intent(in) :: x, y
    integer :: r
    r = x + y
  end function
end module

program main
  use m
  implicit none
  abstract interface
    function add_if(x, y) result(r)
      integer, intent(in) :: x, y
      integer :: r
    end function
  end interface
  procedure(add_if), pointer :: pp
  type(c_funptr) :: cp
  integer :: n

  n = command_argument_count()
  cp = c_funloc(noninterop_add)
  print '(a,l1)', 'c_funloc_associated=', c_associated(cp)
  call c_f_procpointer(cp, pp)
  print '(a,i0)', 'c_f_procpointer_call=', pp(3 + n, 4)
end program

! CHECK: c_funloc_associated=T
! CHECK-NEXT: c_f_procpointer_call=7
