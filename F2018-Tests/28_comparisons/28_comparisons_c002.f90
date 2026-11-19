! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.11 [S4]


program comparisons_c002
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real :: a
  real(real64) :: b
  a = 1.0
  b = 2.0_real64
  print *, ieee_signaling_lt(a, b)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_signaling_lt
    logical :: control
    control = .true.
  end block
end program comparisons_c002
! FLANG: No specific function of generic 'ieee_signaling_lt' matches the actual arguments
! GFORT: no specific function for the generic {{.*}}ieee_signaling_lt
! NVFORT: ieee_signaling_lt
