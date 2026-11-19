! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.23 [S1, S6]

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
  generic, private :: hidden => area_c
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

program genericStatement_c001
  use m_g
  implicit none
  print *, area(circle(1.0))
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  print *, hidden(circle(1.0))
end program genericStatement_c001
