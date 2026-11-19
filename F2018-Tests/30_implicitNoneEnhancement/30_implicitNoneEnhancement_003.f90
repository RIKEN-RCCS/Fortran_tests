! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.2 [S3, S4]

program implicitNoneEnhancement_003
  call type_only()
  call no_spec()
contains
  subroutine type_only()
    implicit none (type)
    integer :: n
    n = 10 + command_argument_count()
    call ext_sub(n)
    write(*,'(A,I0)') 'type_only=', n
  end subroutine type_only
  subroutine no_spec()
    implicit none
    integer :: n
    n = 10 + command_argument_count()
    call ext_sub(n)
    write(*,'(A,I0)') 'no_spec=', n
  end subroutine no_spec
end program implicitNoneEnhancement_003

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

! CHECK: type_only=11
! CHECK-NEXT: no_spec=11
