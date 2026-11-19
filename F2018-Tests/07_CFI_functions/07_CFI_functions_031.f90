! RUN: %if flang %{ %cc -c %S/07_CFI_functions_031.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_031.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_031.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S33]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_select_imag_rank2(z) bind(c)
      import :: c_double_complex
      complex(c_double_complex), intent(in) :: z(:,:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  complex(c_double_complex) :: z(2, 3)
  integer :: i
  z = reshape([(cmplx(real(i, c_double), -real(i, c_double), c_double_complex), i = 1, 6)], [2, 3])
  call c_select_imag_rank2(z)
end program

! CHECK: rank 2: rc=0 rank=2 elem_len_ok=1 extents=2,3 sm_ok=1 values -1.0 -2.0 -3.0 -4.0 -5.0 -6.0
