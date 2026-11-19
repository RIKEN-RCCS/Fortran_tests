! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.1 [S1, S2, S3, S4, S5, S6, S7, S8, S9]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine inspect_d1(a) bind(c, name="inspect_d1")
      import :: c_double
      real(c_double) :: a(:)
    end subroutine
  end interface
  real(c_double), allocatable :: arr(:)
  allocate(arr(9))
  arr = 0
  call inspect_d1(arr(1:9:2))
end program main

! CHECK: [d1]
! CHECK-NEXT: base_addr: nonnull
! CHECK-NEXT: elem_len: 8
! CHECK-NEXT: version_is_CFI_VERSION: yes
! CHECK-NEXT: rank: 1
! CHECK-NEXT: type_is_CFI_type_t: yes
! CHECK-NEXT: attribute: other
! CHECK-NEXT: dim[0].lower_bound: 0
! CHECK-NEXT: dim[0].extent: 5
! CHECK-NEXT: dim[0].sm: {{16|8}}
