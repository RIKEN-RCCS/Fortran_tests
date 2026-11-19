! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' --implicit-check-not='ieee_signbit, has not been explicitly declared' %s %}

! SPEC: N2161 4.6 [S1, S2, S7]


program testSign_c004
  use ieee_arithmetic
  implicit none
  logical, parameter :: p = ieee_signbit(-1.5)
  print *, p
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_signbit
    real :: x
    logical :: control
    x = -1.5
    control = ieee_signbit(x)
  end block
end program testSign_c004
! FLANG: c004.f90:11:{{[0-9]+}}: error: Must be a constant value
! GFORT: Function {{.*}}ieee_signbit{{.*}} in initialization expression at (1) must be an intrinsic function
! NVFORT: Non-constant expression where constant expression required {{.*}}c004.f90: 11)
