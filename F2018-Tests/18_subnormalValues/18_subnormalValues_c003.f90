! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 4.1 [S3]


! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
program subnormalValues_c003
  implicit none
  real :: x

  x = 1.0 + command_argument_count()
! FLANG: .f90:[[@LINE+3]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error:
  print *, ieee_support_subnormal(x)
  block
    use, intrinsic :: ieee_arithmetic, only: ieee_support_subnormal
    logical :: control
    control = .true.
  end block
end program subnormalValues_c003
