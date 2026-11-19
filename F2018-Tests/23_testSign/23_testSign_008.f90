! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.6 [S1, S2, S3, S4, S6]


program testSign_008
  use ieee_arithmetic
  implicit none
  real :: a(2,3), zero
  real, allocatable :: empty(:)
  logical :: supported
  logical, allocatable :: r2(:,:), r0(:)
  integer :: n

  n = command_argument_count()
  zero = 0.0 + n
  supported = ieee_support_datatype(zero)
  write(*,'(A,L1)') 'datatype_supported=', supported
  if (supported) then
    a = reshape([1.5 + n, -1.5 - n, 2.0 + n, -2.0 - n, zero, ieee_value(zero, ieee_negative_zero)], [2, 3])
    allocate(empty(n))
    r2 = ieee_signbit(a)
    r0 = ieee_signbit(empty)
    write(*,'(A,I0,1X,I0)') 'rank2_shape=', shape(r2)
    write(*,'(A,L1)') 'rank2_values=', &
         all(r2 .eqv. reshape([.false., .true., .false., .true., .false., .true.], [2, 3]))
    write(*,'(A,I0)') 'zero_size=', size(r0)
  else
    write(*,'(A)') 'rank2_shape=UNSUPPORTED'
    write(*,'(A)') 'rank2_values=UNSUPPORTED'
    write(*,'(A)') 'zero_size=UNSUPPORTED'
  end if
end program testSign_008
! CHECK: datatype_supported=T
! CHECK-NEXT: rank2_shape=2 3
! CHECK-NEXT: rank2_values=T
! CHECK-NEXT: zero_size=0
