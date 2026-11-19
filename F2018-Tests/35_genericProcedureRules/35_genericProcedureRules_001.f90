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
  interface run
    module procedure run1, run2
  end interface run
contains
  subroutine add1()
    acc = acc + 1
  end subroutine add1
  subroutine dbl()
    acc = acc * 2
  end subroutine dbl
  subroutine run1(p)
    procedure(sub0) :: p
    who = 'run1'
    call p()
  end subroutine run1
  subroutine run2(q, p)
    procedure(sub0) :: q, p
    who = 'run2'
    call q()
    call p()
  end subroutine run2
end module m

program genericProcedureRules_001
  use m
  implicit none
  acc = 1 + command_argument_count()
  call run(add1)
  write(*,'(A,A,1X,I0)') 'one=', trim(who), acc
  acc = 1 + command_argument_count()
  call run(add1, dbl)
  write(*,'(A,A,1X,I0)') 'two=', trim(who), acc
  acc = 1 + command_argument_count()
  call run(q=dbl, p=add1)
  write(*,'(A,A,1X,I0)') 'keyword=', trim(who), acc
end program genericProcedureRules_001

! CHECK: one=run1 2
! CHECK-NEXT: two=run2 4
! CHECK-NEXT: keyword=run2 3
