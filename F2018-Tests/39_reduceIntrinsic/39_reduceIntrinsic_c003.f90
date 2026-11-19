! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='reduce, has not been explicitly declared' --implicit-check-not='Keyword form of argument illegal' %s %}

! SPEC: N2161 5.11 [S2]


program reduce_c003
  implicit none
  integer :: v(3)
  v = [1, 2, 3]
  print *, reduce(v, add, identity=0.0)
  block
    integer :: control
    control = reduce(v, add, identity=0)
  end block
contains
  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add
end program reduce_c003
! FLANG: c003.f90:12:{{[0-9]+}}: error: Actual argument for 'identity=' has bad type
! GFORT: c003.f90:12:{{[0-9]+}}:
! GFORT: Error: The IDENTITY argument at {{.*}} must be a scalar with the same type as ARRAY
! NVFORT: {{.*}}c003.f90: 12)
