! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.6 [S1, S2]


program testSign_c003
  use ieee_arithmetic
  implicit none
  complex :: z
  z = (-1.0, 0.0)
  print *, ieee_signbit(z)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_signbit
    logical :: control
    control = .true.
  end block
end program testSign_c003
! FLANG: No specific function of generic 'ieee_signbit' matches the actual arguments
! GFORT: no specific function for the generic {{.*}}ieee_signbit
! NVFORT: Could not resolve generic procedure 'ieee_signbit' {{.*}}c003.f90: 13)
