! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT %s %}

! SPEC: N2161 2.16 [S3]

module m
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_take(x) bind(c)
      import :: c_int
      integer(c_int), intent(in) :: x
    end subroutine
  end interface
end module

program optionalArguments_c001
  use m
  implicit none
  integer(c_int) :: v = 7
  call c_take()
  block
    call c_take(v)
  end block
end program optionalArguments_c001
! FLANG: Dummy argument 'x=' (#1) is not OPTIONAL and is not associated with an actual argument in this procedure reference
! GFORT: Error: Missing actual argument for argument 'x'
! NVFORT: NVFORTRAN-S-0186-Argument missing for formal argument x
