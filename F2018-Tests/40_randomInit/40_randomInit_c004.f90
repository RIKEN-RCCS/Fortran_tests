! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='is not an intrinsic' %s %}

! SPEC: N2161 5.14 [S6]


program random_init_c004
  implicit none
  intrinsic :: random_init
  call init_seed()
  block
    call random_init(.true., .false.)
  end block
contains
  pure subroutine init_seed()
    call random_init(.true., .false.)
  end subroutine init_seed
end program random_init_c004
! FLANG: c004.f90:17:{{[0-9]+}}: error: Procedure 'random_init' referenced in pure subprogram 'init_seed' must be pure too
! GFORT: c004.f90:17:{{[0-9]+}}:
! GFORT: Error: Subroutine call to intrinsic {{.*}}random_init{{.*}} is not PURE
! NVFORT: {{.*}}c004.f90: 17)
