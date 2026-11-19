! RUN: %if flang %{ %cc -c %S/07_CFI_functions_019.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_019.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_019.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S8, S12, S14]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_establish_more() bind(c)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  call c_establish_more()
end program

! CHECK: other null base_addr: rc=0 base_addr_null=1 attribute_ok=1 rank=1
! CHECK-NEXT: null base_addr with extents: rc=0 base_addr_null=1
! CHECK-NEXT: rank 0 with extents: rc=0 rank=0
