! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.20 [S1, S2]

program importControl_002
  implicit none
  integer :: a, b
  a = 10 + command_argument_count()
  b = 20 + command_argument_count()
  block
    import, only: b
    write(*,'(A,I0)') 'block_b=', b
  end block
end program importControl_002

! CHECK: block_b=20
