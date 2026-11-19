! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 5.20 [S3]

module m_host
  implicit none
  integer :: a = 10
  interface
    subroutine ext(x)
      import, none
      integer, intent(in) :: x
    end subroutine ext
  end interface
  interface
    module subroutine show()
    end subroutine show
  end interface
end module m_host

submodule (m_host) s_host
! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error:
! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
! GFORT: Error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
  import, none
contains
  module subroutine show()
    print *, a
  end subroutine show
end submodule s_host
