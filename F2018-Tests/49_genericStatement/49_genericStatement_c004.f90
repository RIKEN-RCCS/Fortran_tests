! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.23 [S1]

module m_g
  implicit none
  type :: circle
    real :: r
  end type circle
  type :: square
    real :: a
  end type square
  generic :: area => area_c
  generic :: area => area_s
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error: Procedure {{.}}notproc{{.}} in generic interface 'g3'{{.*}}is neither function nor subroutine
  integer :: notproc = 0
! FLANG: .f90:[[@LINE+2]]:{{[0-9]+}}: error: 'notproc' is not a procedure
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  generic :: g3 => notproc
contains
  real function area_c(c)
    type(circle), intent(in) :: c
    area_c = c%r**2
  end function area_c
  real function area_s(s)
    type(square), intent(in) :: s
    area_s = s%a**2
  end function area_s

end module m_g
