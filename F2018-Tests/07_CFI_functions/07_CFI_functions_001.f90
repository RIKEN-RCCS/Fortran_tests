! RUN: %if flang %{ %cc -c %S/07_CFI_functions_001.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_001.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_001.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S5, S12, S14, S42]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_establish_array() bind(c)
    end subroutine
  end interface
contains
  subroutine f_show(a) bind(c)
    real(c_double), intent(in) :: a(:,:)
    print '(a,2(1x,i0))', 'shape', shape(a)
    print '(a,6(1x,f3.1))', 'values', a
    flush(output_unit)
  end subroutine
end module

program main
  use m
  implicit none
  call c_establish_array()
end program

! CHECK: CFI_establish rc=0
! CHECK-NEXT: base_addr_ok=1 elem_len_ok=1 version_ok=1
! CHECK-NEXT: rank=2 type_ok=1 attribute_ok=1
! CHECK-NEXT: dim0 lower_bound=0 extent=2 sm_ok=1
! CHECK-NEXT: dim1 lower_bound=0 extent=3 sm_ok=1
! CHECK-NEXT: shape 2 3
! CHECK-NEXT: values 1.0 2.0 3.0 4.0 5.0 6.0
