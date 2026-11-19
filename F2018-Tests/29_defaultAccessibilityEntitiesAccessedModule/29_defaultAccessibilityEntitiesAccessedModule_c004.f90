! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.1 [S1, S5]

module m_b
  implicit none
  integer :: x = 1
  integer :: y = 2
end module m_b

module m_a
  use m_b, z => x
  implicit none
  private :: m_b
  integer :: v = 4
end module m_a

program defaultAccessibility_c004
  use m_a
  implicit none
  write(*,'(A,I0)') 'v=', v
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  write(*,'(A,I0)') 'z=', z
end program defaultAccessibility_c004
