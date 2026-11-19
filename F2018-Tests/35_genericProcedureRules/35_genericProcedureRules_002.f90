! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.7 [S1]

module m
  implicit none
  integer :: acc = 0
  character(len=8) :: who = ''
  abstract interface
    subroutine sub0()
    end subroutine sub0
    integer function ifun0()
    end function ifun0
  end interface
  interface ev
    module procedure ev1, ev2
  end interface ev
contains
  integer function seven()
    seven = 7 + acc
  end function seven
  integer function three()
    three = 3 + acc
  end function three
  integer function ev1(f)
    procedure(ifun0) :: f
    ev1 = f()
  end function ev1
  integer function ev2(g, f)
    procedure(ifun0) :: g, f
    ev2 = g() * 10 + f()
  end function ev2
end module m

program genericProcedureRules_002
  use m
  implicit none
  acc = command_argument_count()
  write(*,'(A,I0)') 'one=', ev(seven)
  write(*,'(A,I0)') 'two=', ev(seven, three)
end program genericProcedureRules_002

! CHECK: one=7
! CHECK-NEXT: two=73
