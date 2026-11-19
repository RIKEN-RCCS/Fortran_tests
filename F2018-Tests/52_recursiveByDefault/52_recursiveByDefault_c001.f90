! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=": error:" %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not="Error:" %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not="NVFORTRAN-" %s %}

! SPEC: N2161 5.26 [S2, S5]

module m_r
  implicit none
contains
  non_recursive function square(n) result(r)
    integer, intent(in) :: n
    integer :: r
    r = n * n
  end function square
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error: Attributes 'RECURSIVE' and 'NON_RECURSIVE' conflict with each other
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  recursive non_recursive subroutine both()
  end subroutine both
end module m_r
