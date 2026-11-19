! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='not found in module' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='not found in module' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='Illegal use of symbol' %s %}

! SPEC: N2161 4.9 [S1]


program maxMinValues_c001
  implicit none
  real :: x, y
  x = 2.0
  y = 3.0
  print *, ieee_max_num(x, y)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_max_num
    logical :: control
    control = .true.
  end block
end program maxMinValues_c001
! FLANG: No explicit type declared for 'ieee_max_num'
! GFORT: Function {{.*}}ieee_max_num{{.*}} has no IMPLICIT type
! NVFORT: ieee_max_num
