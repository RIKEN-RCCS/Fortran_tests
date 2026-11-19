! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='c003.f90:18:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='c003.f90:18:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='c003.f90: 18)' %s %}

! SPEC: N2161 4.4 [S5]


program roundedConversions_c003
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: x
  x = 2.5
  print *, ieee_rint(x, 1)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_rint, ieee_nearest
    real :: control
    control = 2.5
    control = ieee_rint(control, ieee_nearest)
  end block
end program roundedConversions_c003
! FLANG: c003.f90:13:{{.*}}No specific function of generic 'ieee_rint' matches the actual arguments
! GFORT: c003.f90:13:
! GFORT: no specific function for the generic {{.*}}ieee_rint
! NVFORT: Could not resolve generic procedure 'ieee_rint' {{.*}}c003.f90: 13)
