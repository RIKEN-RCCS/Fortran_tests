! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='is not an intrinsic' %s %}

! SPEC: N2161 5.14 [S2]


program random_init_c001
  implicit none
  intrinsic :: random_init
  call random_init(.true.)
  block
    call random_init(.true., .false.)
  end block
end program random_init_c001
! FLANG: c001.f90:11:{{[0-9]+}}: error: missing mandatory 'image_distinct=' argument
! GFORT: c001.f90:11:{{[0-9]+}}:
! GFORT: Error: Missing actual argument {{.*}}image_distinct{{.*}} in call to {{.*}}random_init
! NVFORT: {{.*}}c001.f90: 11)
