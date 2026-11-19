! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.2 [S5]

program implicitNoneEnhancement_004
  implicit none ()
  integer :: n
  n = 3 + command_argument_count()
  write(*,'(A,L1)') 'empty_list_ok=', n == 3
end program implicitNoneEnhancement_004

! CHECK: empty_list_ok=T
