! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.28 [S3]

program dimArgumentRestriction_c001
  implicit none
  logical :: m(2, 3)

  m = .true.
  call run(1)
contains
  subroutine run(d)
    integer, optional, intent(in) :: d
    write(*,'(A,*(I0,:,1X))') 'count_const=', count(m, 1)
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
    write(*,'(A,*(I0,:,1X))') 'count_optional=', count(m, d)
  end subroutine
end program dimArgumentRestriction_c001
