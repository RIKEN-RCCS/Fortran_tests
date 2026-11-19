! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.5 [S1]


program fusedMultiplyAdd_c001
  implicit none
  real :: a, b, c
  a = 1.0
  b = 2.0
  c = 3.0
  print *, ieee_fma(a, b, c)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_fma
    logical :: control
    control = .true.
  end block
end program fusedMultiplyAdd_c001
! FLANG: No explicit type declared for 'ieee_fma'
! GFORT: Function {{.*}}ieee_fma{{.*}} has no IMPLICIT type
! NVFORT: Symbol, ieee_fma, has not been explicitly declared {{.*}}c001.f90: 8)
