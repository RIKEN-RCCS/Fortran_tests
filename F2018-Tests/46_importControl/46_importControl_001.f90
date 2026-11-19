! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.20 [S1, S2, S5]

program importControl_001
  implicit none
  integer :: a, b
  a = 10 + command_argument_count()
  b = 20 + command_argument_count()
  call sub()
contains
  subroutine sub()
    import, only: a
    integer :: b
    b = 5
    write(*,'(A,I0)') 'only_a=', a
    write(*,'(A,I0)') 'local_b=', b
  end subroutine sub
end program importControl_001

! CHECK: only_a=10
! CHECK-NEXT: local_b=5
