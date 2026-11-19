! RUN: %if flang %{ %cc -c %S/13_assumedType_002.c -o %t.o && %flang %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %cc -c %S/13_assumedType_002.c -o %t.o && %gfortran %s %t.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %cc -c %S/13_assumedType_002.c -o %t.o && %nvfortran %s %t.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.13 [S1, S2, S4]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_call(x, present_flag) bind(c)
      import :: c_int
      type(*), intent(in) :: x(*)
      integer(c_int), value :: present_flag
    end subroutine
  end interface
contains
  subroutine outer(tag, x, y)
    use, intrinsic :: iso_fortran_env, only: output_unit
    character(*), intent(in) :: tag
    type(*), intent(in) :: x(*)
    type(*), intent(in), optional :: y(*)
    print '(2a,i0)', tag, ' rank=', rank(x)
    print '(2a,l1)', tag, ' present y=', present(y)
    flush(output_unit)
    call c_call(x, merge(1, 0, present(y)))
  end subroutine
end module

program main
  use m
  implicit none
  integer(c_int) :: v(3) = [7, 8, 9]
  call outer('absent', v)
  call outer('given', v, v)
end program

! CHECK: absent rank=1
! CHECK-NEXT: absent present y=F
! CHECK-NEXT: x(1)=7
! CHECK-NEXT: given rank=1
! CHECK-NEXT: given present y=T
! CHECK-NEXT: x(1)=7
