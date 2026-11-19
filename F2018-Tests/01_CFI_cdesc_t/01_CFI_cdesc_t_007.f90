! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.1 [S1, S2, S3, S4, S5, S6, S8, S9]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine inspect_c0(a) bind(c, name="inspect_c0")
      import :: c_char
      character(len=*, kind=c_char) :: a
    end subroutine
  end interface
  character(len=5, kind=c_char), allocatable :: s
  allocate(s)
  s = "12345"
  call inspect_c0(s)
end program main

! CHECK: [c0]
! CHECK-NEXT: base_addr: nonnull
! CHECK-NEXT: elem_len: 5
! CHECK-NEXT: version_is_CFI_VERSION: yes
! CHECK-NEXT: rank: 0
! CHECK-NEXT: type_is_CFI_type_t: yes
! CHECK-NEXT: attribute: other
! CHECK-NEXT: type_is_CFI_type_char: yes
! CHECK-NEXT: value: 12345
