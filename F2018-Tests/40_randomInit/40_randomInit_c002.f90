! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='is not an intrinsic' %s %}

! SPEC: N2161 5.14 [S2]


program random_init_c002
  implicit none
  intrinsic :: random_init
  call random_init(1, 0)
  block
    call random_init(.true., .false.)
  end block
end program random_init_c002
! FLANG: c002.f90:11:{{[0-9]+}}: error: Actual argument for 'repeatable=' has bad type
! GFORT: c002.f90:11:{{[0-9]+}}:
! GFORT: Error: {{.*}}repeatable{{.*}} argument of {{.*}}random_init{{.*}} must be LOGICAL
! NVFORT: {{.*}}c002.f90: 11)
