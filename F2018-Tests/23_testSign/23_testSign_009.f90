! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 4.6 [S1, S2, S3, S4, S6]


module testSign_009_m
  use ieee_arithmetic
  implicit none
contains
  pure logical function is_negative(v)
    real, intent(in) :: v
    is_negative = ieee_signbit(v)
  end function is_negative
end module testSign_009_m

program testSign_009
  use ieee_arithmetic
  use testSign_009_m
  implicit none
  real :: v(2)
  logical :: r(2), supported
  integer :: i, n

  n = command_argument_count()
  v = [1.5 + n, -1.5 - n]
  supported = ieee_support_datatype(v(1))
  write(*,'(A,L1)') 'datatype_supported=', supported
  if (supported) then
    write(*,'(A,L1)') 'pure_function=', is_negative(v(2))
    do concurrent (i = 1:2)
      r(i) = ieee_signbit(v(i))
    end do
    write(*,'(A,L1)') 'do_concurrent=', all(r .eqv. [.false., .true.])
  else
    write(*,'(A)') 'pure_function=UNSUPPORTED'
    write(*,'(A)') 'do_concurrent=UNSUPPORTED'
  end if
end program testSign_009
! CHECK: datatype_supported=T
! CHECK-NEXT: pure_function=T
! CHECK-NEXT: do_concurrent=T
