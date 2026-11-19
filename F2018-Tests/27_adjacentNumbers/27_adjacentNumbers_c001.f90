! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.10 [S1]


program adjacentNumbers_c001
  implicit none
  real :: x
  x = 1.0
  print *, ieee_next_up(x)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_next_up
    logical :: control
    control = .true.
  end block
end program adjacentNumbers_c001
! FLANG: No explicit type declared for 'ieee_next_up'
! GFORT: ieee_next_up
! NVFORT: ieee_next_up
