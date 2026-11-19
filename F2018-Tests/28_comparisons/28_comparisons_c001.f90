! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.11 [S1]


program comparisons_c001
  implicit none
  real :: a, b
  a = 1.0
  b = 2.0
  print *, ieee_quiet_eq(a, b)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_quiet_eq
    logical :: control
    control = .true.
  end block
end program comparisons_c001
! FLANG: No explicit type declared for 'ieee_quiet_eq'
! GFORT: Function {{.*}}ieee_quiet_eq{{.*}} has no IMPLICIT type
! NVFORT: ieee_quiet_eq
