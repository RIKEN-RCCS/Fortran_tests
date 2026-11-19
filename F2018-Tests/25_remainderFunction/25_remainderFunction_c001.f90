! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.8 [S1]


program remainderFunction_c001
  implicit none
  real :: a, b
  a = 5.0
  b = 3.0
  print *, ieee_rem(a, b)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_rem
    logical :: control
    control = .true.
  end block
end program remainderFunction_c001
! FLANG: No explicit type declared for 'ieee_rem'
! GFORT: Function {{.*}}ieee_rem{{.*}} has no IMPLICIT type
! NVFORT: Symbol, ieee_rem, has not been explicitly declared
