! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.18 [S3]

program impliedDoVariableKind_c003
  implicit none
  integer :: b(3,2)
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{[0-9]+}}-Symbol, j, has not been explicitly declared
  data ((b(i,j), integer :: i = 1, 3), j = 1, 2) /6*1/
  block
    integer :: c(3,2), m
    data ((c(k,m), integer :: k = 1, 3), m = 1, 2) /6*1/
  end block
end program impliedDoVariableKind_c003
