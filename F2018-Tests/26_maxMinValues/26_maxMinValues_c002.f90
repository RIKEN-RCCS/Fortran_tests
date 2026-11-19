! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.9 [S2]


program maxMinValues_c002
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real :: x
  real(real64) :: y
  x = 2.0
  y = 3.0_real64
  print *, ieee_max_num(x, y)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_max_num
    logical :: control
    control = .true.
  end block
end program maxMinValues_c002
! FLANG: No specific function of generic 'ieee_max_num' matches the actual arguments
! GFORT: no specific function for the generic {{.*}}ieee_max_num
! NVFORT: ieee_max_num
