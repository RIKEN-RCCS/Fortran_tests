! RUN: %if flang %{ %cc -c %S/07_CFI_functions_010.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_010.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_010.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S32, S33, S35]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  type, bind(c) :: pt
    integer(c_int) :: i
    real(c_double) :: d
  end type
  interface
    subroutine c_select_struct(a) bind(c)
      import :: pt
      type(pt), intent(in) :: a(:)
    end subroutine
    subroutine c_select_complex(z) bind(c)
      import :: c_double_complex
      complex(c_double_complex), intent(in) :: z(:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  type(pt) :: a(3)
  complex(c_double_complex) :: z(2)
  a = [pt(1, 0.5_c_double), pt(2, 1.5_c_double), pt(3, 2.5_c_double)]
  z = [(1.0_c_double, -1.0_c_double), (2.0_c_double, -2.0_c_double)]
  call c_select_struct(a)
  call c_select_complex(z)
end program

! CHECK: struct component: rc=0 elem_len_ok=1 sm_ok=1 values 0.5 1.5 2.5
! CHECK-NEXT: complex imaginary part: rc=0 elem_len_ok=1 sm_ok=1 values -1.0 -2.0
