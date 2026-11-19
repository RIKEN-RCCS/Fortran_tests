! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-' %s %}

! SPEC: N2161 2.12 [S1, S11]

module assumedRank_c011_m
  implicit none
  type :: t
    integer :: i
  contains
    final :: fin
  end type t
contains
  impure elemental subroutine fin(x)
    type(t), intent(inout) :: x
  end subroutine fin
  subroutine take_out(a)
    type(t), intent(out) :: a(..)
  end subroutine take_out
  subroutine caller(b)
    type(t) :: b(..)
    type(t) :: c(2)
    call take_out(c)
  ! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
  ! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
  ! GFORT: Error:
  ! NVFORT: NVFORTRAN-{{[SF]}}-{{.*}}.f90: [[@LINE+1]])
    call take_out(b)
  end subroutine caller
end module assumedRank_c011_m
