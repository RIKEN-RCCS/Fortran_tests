! RUN: %if flang %{ %cc -c %S/08_procInterop_001.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/08_procInterop_001.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/08_procInterop_001.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.8 [S1]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_show(s, id) bind(c)
      import :: c_char, c_int
      character(kind=c_char, len=*), intent(in) :: s
      integer(c_int), value :: id
    end subroutine
  end interface
end module

program main
  use m
  implicit none
  character(kind=c_char, len=6) :: w = 'abcdef'
  call c_show(w, 0)
  call c_show(w(2:4), 1)
end program

! CHECK: whole elem_len=6 rank=0 type_ok=1 text=abcdef
! CHECK-NEXT: substring elem_len=3 rank=0 type_ok=1 text=bcd
