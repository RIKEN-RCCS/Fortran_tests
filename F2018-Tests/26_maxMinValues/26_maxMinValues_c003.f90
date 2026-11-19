! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.9 [S2]


program maxMinValues_c003
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x
  integer :: n
  x = 2.0
  n = 3
  print *, ieee_min_num(x, n)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_min_num
    logical :: control
    control = .true.
  end block
end program maxMinValues_c003
! FLANG: No specific function of generic 'ieee_min_num' matches the actual arguments
! GFORT: no specific function for the generic {{.*}}ieee_min_num
! NVFORT: ieee_min_num
