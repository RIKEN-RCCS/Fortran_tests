! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT %s %}

! SPEC: N2161 2.12 [S1, S9]

module assumedRank_c005_m
  implicit none
contains
  subroutine s(a)
    integer, intent(in) :: a(..)
    ok: select rank (a)
    rank (0) ok
    end select ok
    s1: select rank (a)
    rank (0) s1
  ! FLANG-NOT: : error:
  ! FLANG: .f90:[[@LINE+6]]:{{[0-9]+}}: error:
  ! GFORT-NOT: Error:
  ! GFORT: .f90:[[@LINE+4]]:{{[0-9]+}}:
  ! GFORT: Error:
  ! NVFORT-NOT: NVFORTRAN-
  ! NVFORT: NVFORTRAN-{{[SF]}}-{{.*}}.f90: [[@LINE+1]])
    end select s2
  end subroutine s
end module assumedRank_c005_m
