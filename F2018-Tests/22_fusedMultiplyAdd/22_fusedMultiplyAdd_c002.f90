! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.5 [S2]


program fusedMultiplyAdd_c002
  use, intrinsic :: ieee_arithmetic
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  real :: a, b
  real(real64) :: c
  a = 1.0
  b = 2.0
  c = 3.0_real64
  print *, ieee_fma(a, b, c)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_fma
    logical :: control
    control = .true.
  end block
end program fusedMultiplyAdd_c002
! FLANG: Actual argument for 'f3=' has bad type or kind 'REAL(8)'
! GFORT: no specific function for the generic {{.*}}ieee_fma
! NVFORT: Could not resolve generic procedure 'ieee_fma' {{.*}}c002.f90: 17)
