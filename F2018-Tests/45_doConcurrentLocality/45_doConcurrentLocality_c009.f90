! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.19 [S7]

subroutine doConcurrentLocality_c009(x)
  implicit none
  integer :: x(*)
  integer :: i, r(4)
  integer :: k, u, q(4)

! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error: Assumed-size array not permitted for {{.}}x{{.}} in LOCAL locality-spec
! NVFORT: NVFORTRAN-S-1048-LOCAL/LOCAL_INIT variable x is an assumed{{[ -]}}size array ({{.*}}.f90: [[@LINE+1]])
  do concurrent (i = 1:4) local(x)
    r(i) = i
  end do
  block
    do concurrent (k = 1:4) local(u)
      u = k
      q(k) = u
    end do
  end block
end subroutine doConcurrentLocality_c009
