! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.4 [S2]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine cptr_check(a) bind(c, name="cptr_check")
      import :: c_ptr
      type(c_ptr) :: a(:)
    end subroutine
  end interface
  type(c_ptr) :: v(2)
  v = c_null_ptr
  call cptr_check(v)
end program main

! CHECK: cptr_type_is_CFI_type_cptr: yes
