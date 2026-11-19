! RUN: %if flang %{ %flang %s -c -o %t.f.o && %cc %S/10_ptrdiffT.c -c -o %t.c.o && %flang %t.f.o %t.c.o -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -c -o %t.f.o && %cc %S/10_ptrdiffT.c -c -o %t.c.o && %gfortran %t.f.o %t.c.o -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -c -o %t.f.o && %cc %S/10_ptrdiffT.c -c -o %t.c.o && %nvfortran %t.f.o %t.c.o -o %t && %t | FileCheck %s %}

! SPEC: N2161 2.10 [S1]

program ptrdiffT_002
  use, intrinsic :: iso_c_binding
  implicit none
  interface
    function c_diff(a, b) bind(c, name="c_diff") result(r)
      import :: c_ptrdiff_t, c_int
      integer(c_int), intent(in) :: a(*), b(*)
      integer(c_ptrdiff_t) :: r
    end function
    function c_neg_ptrdiff_max() bind(c, name="c_neg_ptrdiff_max") result(r)
      import :: c_ptrdiff_t
      integer(c_ptrdiff_t) :: r
    end function
  end interface
  integer(c_int) :: v(5)
  integer(c_ptrdiff_t) :: d

  v = command_argument_count()
  write(*,'(A,I0)') 'c_diff(v(4),v(1))=', c_diff(v(4), v(1))
  write(*,'(A,I0)') 'c_diff(v(1),v(4))=', c_diff(v(1), v(4))
  write(*,'(A,L1)') '-PTRDIFF_MAX==-huge=', c_neg_ptrdiff_max() == -huge(d)
end program ptrdiffT_002
! CHECK: c_diff(v(4),v(1))=3
! CHECK-NEXT: c_diff(v(1),v(4))=-3
! CHECK-NEXT: -PTRDIFF_MAX==-huge=T
