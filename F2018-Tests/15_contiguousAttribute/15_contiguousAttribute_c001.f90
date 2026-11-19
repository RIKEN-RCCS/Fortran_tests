! RUN: %if flang %{ %flang -pedantic -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 2.15 [S4]

module m
  implicit none
contains
  subroutine sub()
! FLANG: .f90:[[@LINE+3]]:{{[0-9]+}}: portability: CONTIGUOUS entity
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error:
    integer, contiguous :: a(5)
    integer, contiguous, pointer :: p(:)
    a = 0
    print *, a
  end subroutine
end module
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE-8]])
