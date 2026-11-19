! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG --implicit-check-not='_c002.f90:20:' %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT --implicit-check-not='_c002.f90:20:' %s %}
! RUN: %if nvfortran %{ %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='_c002.f90: 20)' %s %}

! SPEC: N2161 2.14 [S3]

module m
  use, intrinsic :: iso_c_binding
  implicit none
contains
  subroutine f_reset(a) bind(c)
    integer(c_int), allocatable, intent(out) :: a(:)
  end subroutine
end module

program allocatableIntentOut_c002
  use m
  implicit none
  integer(c_int), allocatable :: b(:)
  call f_reset(b)
  call s(b)
contains
  subroutine s(x)
    integer(c_int), allocatable, intent(in) :: x(:)
    ! FLANG: .f90:[[@LINE+4]]:{{[0-9]+}}: error: {{.*}}not definable
    ! GFORT: .f90:[[@LINE+3]]:{{[0-9]+}}:
    ! GFORT: INTENT(IN) in variable definition context
    ! NVFORT: NVFORTRAN-W-0193-{{.*}}does not match INTENT (OUT) {{.*}}.f90: [[@LINE+1]])
    call f_reset(x)
  end subroutine
end program allocatableIntentOut_c002
