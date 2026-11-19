! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not=': error:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='Error:' %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='NVFORTRAN-S-' %s %}

! SPEC: N2161 2.8 [S6]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  type, bind(c) :: t
    integer(c_int) :: i = 1
  end type
  type, bind(c) :: u
    integer(c_int) :: j
  end type
  interface
! GFORT: .f90:[[@LINE+2]]:{{[0-9]+}}:
! GFORT: Error:
    subroutine c_sub(a) bind(c)
      import :: t
! FLANG: .f90:[[@LINE+2]]:{{[0-9]+}}: error:
! NVFORT: NVFORTRAN-S-{{.*}}.f90: [[@LINE+1]])
      type(t), allocatable :: a(:)
    end subroutine
    subroutine c_ok(b) bind(c)
      import :: u
      type(u), allocatable :: b(:)
    end subroutine
  end interface
end module
