! RUN: %if flang %{ %cc -c %S/07_CFI_functions_014.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_014.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_014.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S39]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    integer(c_int) function c_is_contiguous(a) bind(c)
      import :: c_int
      integer(c_int), intent(in) :: a(:)
    end function
  end interface
end module

program main
  use m
  implicit none
  integer(c_int) :: a(10)
  a = 0
  print '(a,i0)', 'CFI_is_contiguous a(1:10)=', c_is_contiguous(a)
  print '(a,i0)', 'CFI_is_contiguous a(3:7)=', c_is_contiguous(a(3:7))
  print '(a,i0)', 'CFI_is_contiguous a(1:9:2)=', c_is_contiguous(a(1:9:2))
end program

! CHECK: CFI_is_contiguous a(1:10)=1
! CHECK-NEXT: CFI_is_contiguous a(3:7)=1
! CHECK-NEXT: CFI_is_contiguous a(1:9:2)={{[01]}}
