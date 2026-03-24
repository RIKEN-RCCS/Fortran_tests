! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran -std=f2008 %s -o %t && %t | FileCheck %s

! SPEC: F2008 R404 

program main
  implicit none
  integer, parameter :: long = selected_int_kind(18)

  call decl_nokind()
  call decl_kind()
  call literal_nokind()
  call intrinsic_int_nokind()
  call forall_nokind()

contains

  ! Decl without KIND=
  subroutine decl_nokind()
    integer(long) :: a
    a = 10
    print *, kind(a), ",", range(a), ",", a
  end subroutine
  
  ! Decl with KIND=
  subroutine decl_kind()
    integer(kind=long) :: b
    b = 20
    print *, kind(b), ",", range(b), ",", b
  end subroutine
  
  ! literal without KIND
  subroutine literal_nokind()
    print *, kind(30_long), ",", range(30_long), ",", 30_long
  end subroutine

  ! intrinsic func INT(A, KIND)
  subroutine intrinsic_int_nokind()
    real :: x = 40.7
    print *, kind(int(x, selected_int_kind(18))), ",", &
             range(int(x, selected_int_kind(18))),",", &
             int(x, selected_int_kind(18))
  end subroutine
  
  ! FORALL index variable
  subroutine forall_nokind()
    integer(long) :: x(3)
    integer :: e(3)
    integer :: f(3)
    forall (integer(selected_int_kind(18)) :: i = 1:3)
      x(i) = 50_long
      e(i) = kind(i)
      f(i) = range(i)
    end forall
    print *, e, ",", f, ",", x
  end subroutine

end program

! CHECK:      8 , 18 , 10
! CHECK-NEXT: 8 , 18 , 20
! CHECK-NEXT: 8 , 18 , 30
! CHECK-NEXT: 8 , 18 , 40
! CHECK-NEXT: 8 8 8 , 18 18 18 , 50 50 50
