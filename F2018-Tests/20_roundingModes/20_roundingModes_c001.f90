! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 4.3 [S1]


program roundingModes_c001
  implicit none
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_round_type, ieee_away
    type(ieee_round_type) :: control
    control = ieee_away
  end block
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_round_type
    type(ieee_round_type) :: r
  ! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
  ! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
  ! GFORT: Error:
  ! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
    r = ieee_away
  end block
end program roundingModes_c001
