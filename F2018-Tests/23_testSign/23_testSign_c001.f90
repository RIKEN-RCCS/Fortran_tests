! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.6 [S1]


program testSign_c001
  implicit none
  real :: x
  x = -1.0
  print *, ieee_signbit(x)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_signbit
    logical :: control
    control = .true.
  end block
end program testSign_c001
! FLANG: No explicit type declared for 'ieee_signbit'
! GFORT: Function {{.*}}ieee_signbit{{.*}} has no IMPLICIT type
! NVFORT: Symbol, ieee_signbit, has not been explicitly declared {{.*}}c001.f90: 8)
