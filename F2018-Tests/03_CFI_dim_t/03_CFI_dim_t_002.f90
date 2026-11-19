! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.3 [S1, S3, S4, S5]

program main
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine dims(a) bind(c, name="dims")
      import :: c_double
      real(c_double), pointer :: a(:,:)
    end subroutine
  end interface
  real(c_double), pointer :: p(:,:)
  allocate(p(-5:-1, 100:102))
  p = 0
  call dims(p)
end program main

! CHECK: rank: 2{{$}}
! CHECK-NEXT: elem_len: 8{{$}}
! CHECK-NEXT: dim[0]: lower_bound=-5 extent=5 sm=8{{$}}
! CHECK-NEXT: dim[1]: lower_bound=100 extent=3 sm=40{{$}}
