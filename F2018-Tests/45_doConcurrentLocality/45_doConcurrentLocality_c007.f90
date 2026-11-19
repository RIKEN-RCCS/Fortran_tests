! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.19 [S7]

module doConcurrentLocality_c007_m
  implicit none
  type :: fin_t
    integer :: n = 0
  contains
    final :: cleanup
  end type fin_t
contains
  subroutine cleanup(x)
    type(fin_t), intent(inout) :: x
    x%n = -1
  end subroutine cleanup
end module doConcurrentLocality_c007_m

program doConcurrentLocality_c007
  use doConcurrentLocality_c007_m
  implicit none
  type(fin_t) :: f
  integer :: i, r(4)
  integer :: k, u, q(4)

! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  do concurrent (i = 1:4) local(f)
    f%n = i
    r(i) = f%n
  end do
  block
    do concurrent (k = 1:4) local(u)
      u = k
      q(k) = u
    end do
  end block
end program doConcurrentLocality_c007
