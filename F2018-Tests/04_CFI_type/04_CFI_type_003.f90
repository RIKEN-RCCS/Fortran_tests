! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/04_CFI_type.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.4 [S4]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine dump2(a, b) bind(c, name="dump2")
      import :: c_int8_t, c_int64_t
      integer(c_int8_t)  :: a(:)
      integer(c_int64_t) :: b(:)
    end subroutine
  end interface
  integer(c_int8_t)  :: b8(2)
  integer(c_int64_t) :: w64(2)
  b8 = 0
  w64 = 0
  call dump2(b8, w64)
end program main

! CHECK: a_elem_len: 1
! CHECK-NEXT: b_elem_len: 8
! CHECK-NEXT: a_is_other: no
! CHECK-NEXT: b_is_other: no
! CHECK-NEXT: codes_differ: yes
