! RUN: %if flang %{ %cc -c %S/07_CFI_functions_032.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_032.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_032.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S38]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_address_size1(a) bind(c)
      import :: c_int
      integer(c_int) :: a(..)
    end subroutine
    subroutine c_address_size2(b) bind(c)
      import :: c_int
      integer(c_int) :: b(..)
    end subroutine
  end interface
contains
  subroutine f_size1(a)
    integer(c_int) :: a(*)
    call c_address_size1(a)
  end subroutine
  subroutine f_size2(b)
    integer(c_int) :: b(2, *)
    call c_address_size2(b)
  end subroutine
end module

program main
  use m
  implicit none
  integer(c_int) :: a(5) = [10, 20, 30, 40, 50]
  integer(c_int) :: b(2, 3)
  b = reshape([1, 2, 3, 4, 5, 6], [2, 3])
  call f_size1(a)
  call f_size2(b)
end program

! CHECK: rank1: rank=1 values 10 20 30 40 50
! CHECK-NEXT: rank2: rank=2 values 1 2 3 4 5 6
