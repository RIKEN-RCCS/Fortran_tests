! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='reduce, has not been explicitly declared' --implicit-check-not='Keyword form of argument illegal' %s %}

! SPEC: N2161 5.11 [S2]


program reduce_c001
  implicit none
  integer :: v(3)
  v = [1, 2, 3]
  print *, reduce(v, impure_add)
  block
    integer :: control
    control = reduce(v, add)
  end block
contains
  integer function impure_add(a, b)
    integer, intent(in) :: a, b
    impure_add = a + b
  end function impure_add
  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add
end program reduce_c001
! FLANG: c001.f90:12:{{[0-9]+}}: error: OPERATION= argument of REDUCE() must be a pure function
! GFORT: c001.f90:12:{{[0-9]+}}:
! GFORT: Error: OPERATION argument at {{.*}} must be a PURE function
! NVFORT: {{.*}}c001.f90: 12)
