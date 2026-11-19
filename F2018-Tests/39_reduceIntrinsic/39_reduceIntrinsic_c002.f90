! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='reduce, has not been explicitly declared' --implicit-check-not='Keyword form of argument illegal' %s %}

! SPEC: N2161 5.11 [S2]


program reduce_c002
  implicit none
  real :: r(3)
  r = [1.0, 2.0, 3.0]
  print *, reduce(r, add)
  block
    real :: control
    control = reduce(r, radd)
  end block
contains
  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add
  pure real function radd(a, b)
    real, intent(in) :: a, b
    radd = a + b
  end function radd
end program reduce_c002
! FLANG: c002.f90:12:{{[0-9]+}}: error: OPERATION= argument of REDUCE() must have the same type as ARRAY=
! GFORT: c002.f90:12:{{[0-9]+(-[0-9]+)?}}:
! GFORT: Error: The ARRAY argument at {{.*}} but the function passed as OPERATION at {{.*}} returns INTEGER
! NVFORT: {{.*}}c002.f90: 12)
