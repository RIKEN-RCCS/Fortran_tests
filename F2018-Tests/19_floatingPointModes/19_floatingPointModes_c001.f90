! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 4.2 [S1]


program floatingPointModes_c001
  implicit none
  block
    use, intrinsic :: ieee_exceptions, only: ieee_modes_type
    type(ieee_modes_type) :: control
  end block
  block
  ! FLANG: .f90:[[@LINE+5]]:{{[0-9]+}}: error:
  ! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
  ! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
  ! GFORT: Error:
  ! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
    type(ieee_modes_type) :: m
  end block
end program floatingPointModes_c001
