! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.2 [S2]

program implicitNoneEnhancement_c002
  implicit none (external)
  external :: ext_sub
  integer :: ext_fn
  integer :: n
  n = 5
  call ext_sub(n)
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  n = ext_fn(n)
end program implicitNoneEnhancement_c002

subroutine ext_sub(n)
  implicit none
  integer, intent(inout) :: n
  n = n + 1
end subroutine ext_sub

integer function ext_fn(n)
  implicit none
  integer, intent(in) :: n
  ext_fn = 2 * n
end function ext_fn
