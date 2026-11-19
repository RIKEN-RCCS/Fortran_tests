! RUN: %if flang %{ %cc -c %S/09_lifetimes_002.c -o %t.o && %flang %s %t.o -o %t && %t | %FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/09_lifetimes_002.c -o %t.o && %gfortran %s %t.o -o %t && %t | %FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/09_lifetimes_002.c -o %t.o && %nvfortran %s %t.o -o %t && %t | %FileCheck %s %}

! SPEC: N2161 2.9 [S2, S5]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_associate(p, src) bind(c)
      import :: c_int
      integer(c_int), pointer, intent(inout) :: p(:)
      integer(c_int), target, intent(in) :: src(:)
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  integer(c_int), target :: src(4) = [10, 20, 30, 40]
  integer(c_int), pointer :: p(:)
  p => null()
  call c_associate(p, src)
  print '(a,l1)', 'associated(p,src)=', associated(p, src)
  print '(a,4(1x,i0))', 'p=', p
end program

! CHECK: CFI_setpointer rc=0
! CHECK-NEXT: associated(p,src)=T
! CHECK-NEXT: p= 10 20 30 40
