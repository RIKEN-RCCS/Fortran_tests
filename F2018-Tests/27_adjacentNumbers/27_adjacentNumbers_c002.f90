! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.10 [S2]


program adjacentNumbers_c002
  use, intrinsic :: ieee_arithmetic
  implicit none
  integer :: n
  n = 1
  print *, ieee_next_down(n)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_next_down
    logical :: control
    control = .true.
  end block
end program adjacentNumbers_c002
! FLANG: Actual argument for 'x=' has bad type 'INTEGER(4)'
! GFORT: ieee_next_down
! NVFORT: ieee_next_down
