! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.2 [S1, S2, S6]

program implicitNoneEnhancement_001
  implicit none (external)
  external :: ext_sub, ext_fn
  integer :: ext_fn
  k = 5 + command_argument_count()
  call ext_sub(k)
  write(*,'(A,I0)') 'ext_sub=', k
  write(*,'(A,I0)') 'ext_fn=', ext_fn(k)
  write(*,'(A,L1)') 'implicit_k_is_integer=', kind(k) == kind(0)
end program implicitNoneEnhancement_001

subroutine ext_sub(n)
  implicit none
  integer, intent(inout) :: n
  n = n + 1
end subroutine ext_sub

integer function ext_fn(n)
  implicit none
  integer, intent(in) :: n
  ext_fn = 2 * n
end function ext_fn

! CHECK: ext_sub=6
! CHECK-NEXT: ext_fn=12
! CHECK-NEXT: implicit_k_is_integer=T
