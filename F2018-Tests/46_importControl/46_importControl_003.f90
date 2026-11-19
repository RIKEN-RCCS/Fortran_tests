! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.20 [S1, S3]

program importControl_003
  implicit none
  integer :: a, b
  a = 10 + command_argument_count()
  b = 20 + command_argument_count()
  call sub()
contains
  subroutine sub()
    import, none
    integer :: a
    a = 1
    write(*,'(A,I0)') 'none_local_a=', a
  end subroutine sub
end program importControl_003

! CHECK: none_local_a=1
