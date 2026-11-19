! RUN: %if flang %{ %not %flang -c %s -o %t.o 2>&1 | FileCheck --check-prefix=FLANG %s %}
! RUN: %if gfortran %{ %not %gfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=GFORT %s %}
! RUN: %if nvfortran %{ %not %nvfortran -c %s -o %t.o 2>&1 | FileCheck --check-prefix=NVFORT %s %}

! SPEC: N2161 2.16 [S4]

program optionalArguments_c002
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    subroutine c_take_value(x) bind(c)
      import :: c_int
      integer(c_int), value, optional :: x
    end subroutine
  end interface
  integer(c_int) :: v = 7
  block
    interface
      subroutine c_take(x) bind(c)
        import :: c_int
        integer(c_int), intent(in), optional :: x
      end subroutine
    end interface
    call c_take(v)
  end block
end program optionalArguments_c002
! FLANG: VALUE attribute may not apply to an OPTIONAL in a BIND(C) procedure
! GFORT: Error: Variable 'x' at (1) cannot have both the OPTIONAL and the VALUE attribute because procedure 'c_take_value' is BIND(C)
! NVFORT: NVFORTRAN-S-1269-Dummy argument x cannot have both the VALUE and OPTIONAL attributes because procedure c_take_value has the BIND attribute
