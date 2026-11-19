! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.11 [S2]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    function c_malloc(n) bind(c, name='malloc') result(p)
      import :: c_ptr, c_size_t
      integer(c_size_t), value :: n
      type(c_ptr) :: p
    end function
    subroutine c_free(p) bind(c, name='free')
      import :: c_ptr
      type(c_ptr), value :: p
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  type(c_ptr) :: raw
  integer, pointer :: fp(:)
  integer :: n

  n = command_argument_count()
  raw = c_malloc(4_c_size_t * 4_c_size_t)
  call c_f_pointer(raw, fp, [4])
  fp = [10, 20, 30, 40] + n
  print '(a,i0,3(1x,i0))', 'c_f_pointer_integer=', fp

  call c_free(raw)
end program

! CHECK: c_f_pointer_integer=10 20 30 40
