! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.7 [S2]


program integerConversion_c003
  use, intrinsic :: ieee_arithmetic
  implicit none
  real :: a
  a = 2.5
  print *, ieee_int(a, 1)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_int
    logical :: control
    control = .true.
  end block
end program integerConversion_c003
! FLANG: Actual argument for 'round=' has bad type 'INTEGER(4)'
! GFORT: ieee_int
! NVFORT: ieee_int
