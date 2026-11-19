! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='is not an intrinsic' %s %}

! SPEC: N2161 5.14 [S1]


program random_init_c003
  implicit none
  intrinsic :: random_init
  logical :: l
  l = random_init(.true., .false.)
  block
    call random_init(.true., .false.)
  end block
end program random_init_c003
! FLANG: c003.f90:12:{{[0-9]+}}: error: Cannot call subroutine 'random_init' like a function
! GFORT: c003.f90:12:{{[0-9]+}}:
! GFORT: Error: {{.*}}random_init{{.*}} at (1) is not a function
! NVFORT: {{.*}}c003.f90: 12)
