! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.7 [S1]


program integerConversion_c001
  use, intrinsic :: ieee_arithmetic, only: ieee_to_zero
  implicit none
  real :: a
  a = 2.5
  print *, ieee_int(a, ieee_to_zero)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_int
    logical :: control
    control = .true.
  end block
end program integerConversion_c001
! FLANG: No explicit type declared for 'ieee_int'
! GFORT: ieee_int
! NVFORT: ieee_int
