! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.19 [S6]

program doConcurrentLocality_c002
  implicit none
  integer :: i, t, r(4)
  integer :: k, u, q(4)

  t = 1
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  do concurrent (i = 1:4) local(t) local_init(t)
    r(i) = i
  end do
  block
    u = 1
    do concurrent (k = 1:4) local_init(u)
      q(k) = u
    end do
  end block
end program doConcurrentLocality_c002
