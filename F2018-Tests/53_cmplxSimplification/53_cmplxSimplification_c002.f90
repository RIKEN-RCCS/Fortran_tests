! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.27 [S1, S2, S3]

program cmplxSimplification_c002
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  complex :: z
  complex(dp) :: c
  integer :: k
  z = (1.5, -2.5)
  k = dp
  block
    complex(dp) :: w
    w = cmplx(z, dp)
  end block
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  c = cmplx(z, y=2.0)
end program cmplxSimplification_c002
