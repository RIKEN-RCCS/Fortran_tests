! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/03_CFI_dim_t.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.3 [S1, S3, S4, S5]

module m2
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine dims(a) bind(c, name="dims")
      import :: c_double
      real(c_double) :: a(..)
    end subroutine
  end interface
contains
  subroutine forward2(x)
    real(c_double) :: x(3,*)
    call dims(x)
  end subroutine
end module m2

program main
  use m2
  implicit none
  real(c_double) :: v(3,5)
  v = 0
  call forward2(v)
end program main

! CHECK: rank: 2{{$}}
! CHECK-NEXT: elem_len: 8{{$}}
! CHECK-NEXT: dim[0]: lower_bound=0 extent=3 sm=8{{$}}
! CHECK-NEXT: dim[1]: lower_bound=0 extent=-1 sm=24{{$}}
