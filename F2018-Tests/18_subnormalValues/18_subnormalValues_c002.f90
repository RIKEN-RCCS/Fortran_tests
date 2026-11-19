! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 4.1 [S2]


! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
program subnormalValues_c002
  implicit none
! FLANG: .f90:[[@LINE+3]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error:
  print *, ieee_subnormal
  block
    use, intrinsic :: ieee_features, only: ieee_subnormal
    logical :: control
    control = .true.
  end block
end program subnormalValues_c002
