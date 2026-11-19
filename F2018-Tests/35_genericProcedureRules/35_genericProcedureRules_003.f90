! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.7 [S4]

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
  interface mix
    module procedure mixp, mixd
  end interface mix
contains
  subroutine add1()
    acc = acc + 1
  end subroutine add1
  subroutine mixp(p)
    procedure(sub0) :: p
    who = 'mixp'
    call p()
  end subroutine mixp
  subroutine mixd(k)
    integer, intent(in) :: k
    who = 'mixd'
    acc = k
  end subroutine mixd
end module m

program genericProcedureRules_003
  use m
  implicit none
  call mix(add1)
  write(*,'(A,A)') 'procedure=', trim(who)
  call mix(5 + command_argument_count())
  write(*,'(A,A)') 'data=', trim(who)
end program genericProcedureRules_003

! CHECK: procedure=mixp
! CHECK-NEXT: data=mixd
