! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 2.10 [S1]

program ptrdiffT_c001
  implicit none
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+4]])
! FLANG: .f90:[[@LINE+3]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error:
  integer(c_ptrdiff_t) :: d
  block
    use, intrinsic :: iso_c_binding, only: c_ptrdiff_t
    logical :: control
    control = .true.
  end block
end program ptrdiffT_c001
