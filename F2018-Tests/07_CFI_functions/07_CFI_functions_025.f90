! RUN: %if flang %{ %cc -c %S/07_CFI_functions_025.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/07_CFI_functions_025.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/07_CFI_functions_025.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.7 [S22, S26]

module m
  use, intrinsic :: iso_c_binding
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none
  interface
    subroutine c_allocate_deallocate(p) bind(c)
      import :: c_int
      integer(c_int), pointer, intent(inout) :: p(:)
    end subroutine
    subroutine c_deallocate(p) bind(c)
      import :: c_int
      integer(c_int), pointer, intent(inout) :: p(:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), pointer :: p(:), q(:)
  p => null()
  call c_allocate_deallocate(p)
  print '(a,l1)', 'after CFI_allocate and CFI_deallocate: associated=', associated(p)
  flush(output_unit)
  allocate(q(4))
  q = [1, 2, 3, 4]
  call c_deallocate(q)
  print '(a,l1)', 'Fortran allocate then CFI_deallocate: associated=', associated(q)
end program

! CHECK: CFI_allocate rc=0 base_addr_null=0
! CHECK-NEXT: CFI_deallocate rc=0 base_addr_null=1
! CHECK-NEXT: after CFI_allocate and CFI_deallocate: associated=F
! CHECK-NEXT: CFI_deallocate rc=0 base_addr_null=1
! CHECK-NEXT: Fortran allocate then CFI_deallocate: associated=F
