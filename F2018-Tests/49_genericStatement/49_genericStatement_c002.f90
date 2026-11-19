! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.23 [S2]

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
! FLANG: .f90:[[@LINE+2]]:{{[0-9]+}}: error: Generic 'dup' may not have specific procedures
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  generic :: dup => dup1, dup2
contains
  real function area_c(c)
    type(circle), intent(in) :: c
    area_c = c%r**2
  end function area_c
  real function area_s(s)
    type(square), intent(in) :: s
    area_s = s%a**2
  end function area_s
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error: Ambiguous interfaces in generic interface 'dup'
  real function dup1(c)
    type(circle), intent(in) :: c
    dup1 = c%r
  end function dup1
  real function dup2(c)
    type(circle), intent(in) :: c
    dup2 = 2 * c%r
  end function dup2
end module m_g
