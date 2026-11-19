! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.20 [S1, S6]

program importControl_005
  implicit none
  integer :: a, b
  a = 10 + command_argument_count()
  b = 20 + command_argument_count()
  call sub()
contains
  subroutine sub()
    import :: a
    write(*,'(A,I0,1X,I0)') 'traditional=', a, b
  end subroutine sub
end program importControl_005

! CHECK: traditional=10 20
