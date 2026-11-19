! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.11 [S3, S8]

module mc
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
  use mc
  implicit none
  type :: t
    sequence
    integer :: v
    character(len=1) :: tag
  end type
  type(c_ptr) :: raw
  type(t) :: m
  type(t), pointer :: np(:)
  integer :: n

  n = command_argument_count()
  raw = c_malloc(int(2 * storage_size(m) / 8, c_size_t))
  call c_f_pointer(raw, np, [2])
  np(1) = t(99 + n, 'x')
  np(2) = t(-7 - n, 'y')
  print '(a,i0,1x,a,1x,i0,1x,a)', 'c_f_pointer_derived=', np(1)%v, np(1)%tag, np(2)%v, np(2)%tag

  call c_free(raw)
end program

! CHECK: c_f_pointer_derived=99 x -7 y
