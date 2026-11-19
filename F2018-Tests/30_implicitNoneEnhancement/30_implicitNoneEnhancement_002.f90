! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.2 [S1, S2]

program implicitNoneEnhancement_002
  implicit none (type, external)
  external :: ext_sub
  integer :: n
  n = 7 + command_argument_count()
  call apply(ext_sub, n)
  write(*,'(A,I0)') 'dummy_procedure=', n
contains
  subroutine apply(p, n)
    external :: p
    integer, intent(inout) :: n
    call p(n)
  end subroutine apply
end program implicitNoneEnhancement_002

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

! CHECK: dummy_procedure=8
