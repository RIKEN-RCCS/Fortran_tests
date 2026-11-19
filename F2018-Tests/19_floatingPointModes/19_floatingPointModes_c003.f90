! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 4.2 [S3]


program floatingPointModes_c003
  use, intrinsic :: ieee_exceptions, only: ieee_modes_type, ieee_get_modes, ieee_set_modes
  implicit none
  type(ieee_modes_type) :: ok
  real :: m
  m = 1.0
  call ieee_get_modes(ok)
  call ieee_set_modes(ok)
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  call ieee_set_modes(m)
end program floatingPointModes_c003
