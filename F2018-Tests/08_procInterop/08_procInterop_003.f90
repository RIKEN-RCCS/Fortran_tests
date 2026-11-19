! RUN: %if flang %{ %cc -c %S/08_procInterop_003.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/08_procInterop_003.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/08_procInterop_003.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.8 [S2]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_show(p, id) bind(c)
      import :: c_int
      integer(c_int), pointer, intent(in) :: p(:)
      integer(c_int), value :: id
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), target :: t(6) = [1, 2, 3, 4, 5, 6]
  integer(c_int), pointer :: p(:)
  p => null()
  call c_show(p, 0)
  p(-1:) => t(2:6:2)
  call c_show(p, 1)
end program

! CHECK: pointer_disassociated attribute_ok=1 rank=1 base_addr_null=1
! CHECK-NEXT: pointer_associated attribute_ok=1 rank=1 base_addr_null=0 lower_bound=-1 extent=3 values 2 4 6
