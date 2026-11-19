! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT --implicit-check-not='reduce, has not been explicitly declared' %s %}

! SPEC: N2161 5.11 [S10]


module reduce_c004_ops
  implicit none
contains
  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add
end module reduce_c004_ops

program reduce_c004
  use reduce_c004_ops
  implicit none
  integer, parameter :: p = reduce([1, 2, 3], add)
  print *, p
  block
    integer :: control
    control = reduce([1, 2, 3], add)
  end block
end program reduce_c004
! FLANG: c004.f90:20:{{[0-9]+}}: error: Value of named constant 'p' {{.*}} cannot be computed as a constant value
! GFORT: c004.f90:20:{{[0-9]+}}:
! GFORT: Error: transformational intrinsic {{.*}}reduce{{.*}} is not permitted in an initialization expression
! NVFORT: Non-constant expression where constant expression required ({{.*}}c004.f90: 20)
