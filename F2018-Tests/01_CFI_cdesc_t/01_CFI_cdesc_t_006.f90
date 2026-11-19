! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/01_CFI_cdesc_t.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.1 [S1, S2, S3, S4, S5, S6, S7, S8, S9]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine inspect_z1(a) bind(c, name="inspect_z1")
      import :: c_double_complex
      complex(c_double_complex) :: a(:)
    end subroutine
    subroutine inspect_i2(a) bind(c, name="inspect_i2")
      import :: c_int16_t
      integer(c_int16_t) :: a(:)
    end subroutine
  end interface
  complex(c_double_complex), allocatable :: z(:)
  integer(c_int16_t), allocatable :: h(:)
  allocate(z(3), h(2))
  z = 0
  h = 0
  call inspect_z1(z)
  call inspect_i2(h)
end program main

! CHECK: [z1]
! CHECK-NEXT: base_addr: nonnull
! CHECK-NEXT: elem_len: 16
! CHECK-NEXT: version_is_CFI_VERSION: yes
! CHECK-NEXT: rank: 1
! CHECK-NEXT: type_is_CFI_type_t: yes
! CHECK-NEXT: attribute: other
! CHECK-NEXT: dim[0].lower_bound: 0
! CHECK-NEXT: dim[0].extent: 3
! CHECK-NEXT: dim[0].sm: 16
! CHECK: [i2]
! CHECK-NEXT: base_addr: nonnull
! CHECK-NEXT: elem_len: 2
! CHECK-NEXT: version_is_CFI_VERSION: yes
! CHECK-NEXT: rank: 1
! CHECK-NEXT: type_is_CFI_type_t: yes
! CHECK-NEXT: attribute: other
! CHECK-NEXT: dim[0].lower_bound: 0
! CHECK-NEXT: dim[0].extent: 2
! CHECK-NEXT: dim[0].sm: 2
