! RUN: %if flang %{ %cc -c %S/09_lifetimes_003.c -o %t.o && %flang %s %t.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/09_lifetimes_003.c -o %t.o && %gfortran %s %t.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/09_lifetimes_003.c -o %t.o && %nvfortran %s %t.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.9 [S3, S5]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_save(x) bind(c)
      import :: c_int
      integer(c_int), target, intent(inout) :: x(:)
    end subroutine
    subroutine c_use_saved() bind(c)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), target :: t(3) = [5, 6, 7]
  call c_save(t)
  call c_use_saved()
  print '(a,3(1x,i0))', 't=', t
end program

! CHECK: c_save base_addr_null=0
! CHECK-NEXT: saved a= 5 6 7
! CHECK-NEXT: t= 5 99 7
