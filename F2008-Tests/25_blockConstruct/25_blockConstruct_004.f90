! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 R807, R808, C806, C807, C808, NOTE 8.5

! ====================
! A-1
! B-1
! C-1
! D-2
! E-1
! F-3
! ====================
subroutine sub1(l, n, m, a)
    real, intent(in) :: l
    integer, intent(in) :: n, m
    real :: a(:)
    real :: b(8)

    b = a

    block
        integer :: i
        real, save :: b(8)
        do i = n, m
            b(i) = l * i
        end do
        print "(a, *(f6.2))", "b(in) =", b
    end block

    print "(a, *(f6.2))", "b(out) =", b

end subroutine sub1

program sample
    implicit none
    interface
        subroutine sub1(l, n, m, a)
            real, intent(in) :: l
            integer, intent(in) :: n, m
            real :: a(:)
        end subroutine sub1
    end interface
    integer i
    integer :: s = 8
    real  :: x(8)

    do i = 1,s
        x(i) = i
    end do
    print "(a, *(f6.2))", "x =", x

    call sub1(2.0, 1, s, x)
    call sub1(3.0, 5, 8, x)

end program sample

! CHECK: x =  1.00  2.00  3.00  4.00  5.00  6.00  7.00  8.00
! CHECK-NEXT: b(in) =  2.00  4.00  6.00  8.00 10.00 12.00 14.00 16.00
! CHECK-NEXT: b(out) =  1.00  2.00  3.00  4.00  5.00  6.00  7.00  8.00
! CHECK-NEXT: b(in) =  2.00  4.00  6.00  8.00 15.00 18.00 21.00 24.00
! CHECK-NEXT: b(out) =  1.00  2.00  3.00  4.00  5.00  6.00  7.00  8.00