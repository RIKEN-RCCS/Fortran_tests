! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.20 [S1, S4]

program importControl_004
  implicit none
  integer :: a, b
  a = 10 + command_argument_count()
  b = 20 + command_argument_count()
  call sub()
contains
  subroutine sub()
    import, all
    write(*,'(A,I0,1X,I0)') 'all=', a, b
  end subroutine sub
end program importControl_004

! CHECK: all=10 20
