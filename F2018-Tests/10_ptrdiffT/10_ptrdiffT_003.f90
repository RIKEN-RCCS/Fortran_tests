! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/10_ptrdiffT.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/10_ptrdiffT.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/10_ptrdiffT.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.10 [S1]

program ptrdiffT_003
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    function c_ptrdiff_max() bind(c, name="c_ptrdiff_max") result(r)
      import :: c_ptrdiff_t
      integer(c_ptrdiff_t) :: r
    end function
  end interface
  integer(c_ptrdiff_t) :: d

  write(*,'(A,L1)') 'huge==PTRDIFF_MAX=', huge(d) == c_ptrdiff_max()
end program ptrdiffT_003
! CHECK: huge==PTRDIFF_MAX=T
