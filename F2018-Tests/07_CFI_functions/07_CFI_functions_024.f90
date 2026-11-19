! RUN: %if flang %{ %cc -c %S/07_CFI_functions_024.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_024.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_024.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S32, S35]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_select_real_part(z) bind(c)
      import :: c_double_complex
      complex(c_double_complex), intent(in) :: z(:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  complex(c_double_complex) :: z(2)
  z = [(1.0_c_double, -1.0_c_double), (2.0_c_double, -2.0_c_double)]
  call c_select_real_part(z)
end program

! CHECK: complex real part: rc=0 elem_len_ok=1 sm_ok=1 values 1.0 2.0
