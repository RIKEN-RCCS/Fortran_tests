! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.2 [S6, S7]

program implicitNoneEnhancement_005
  implicit none (external)
  implicit integer (a)
  ax = 3 + command_argument_count()
  write(*,'(A,L1)') 'ax_is_integer=', kind(ax) == kind(0)
end program implicitNoneEnhancement_005

! CHECK: ax_is_integer=T
