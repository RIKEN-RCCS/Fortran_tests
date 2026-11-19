! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.3 [S1, S3, S4, S5]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine dims(a) bind(c, name="dims")
      import :: c_int16_t
      integer(c_int16_t) :: a(:,:)
    end subroutine
  end interface
  integer(c_int16_t) :: arr(2,3)
  arr = 0
  call dims(arr)
end program main

! CHECK: rank: 2{{$}}
! CHECK-NEXT: elem_len: 2{{$}}
! CHECK-NEXT: dim[0]: lower_bound=0 extent=2 sm=2{{$}}
! CHECK-NEXT: dim[1]: lower_bound=0 extent=3 sm=4{{$}}
