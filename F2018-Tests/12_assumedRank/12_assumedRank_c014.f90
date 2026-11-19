! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-' %s %}

! SPEC: N2161 2.12 [S1, S3]

module assumedRank_c014_m
  implicit none
contains
  subroutine t(x)
    integer, intent(inout) :: x(..)
  end subroutine t
  subroutine s(a)
    integer, intent(inout) :: a(..)
    call t(a)
  ! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
  ! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
  ! GFORT: Error:
  ! NVFORT: NVFORTRAN-{{[SF]}}-{{.*}}.f90: [[@LINE+1]])
    a(1) = 0
  end subroutine s
end module assumedRank_c014_m
