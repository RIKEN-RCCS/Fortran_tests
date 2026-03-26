! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 R807, R808, C806, C807, C808, NOTE 8.5

! ====================
! A-1
! B-1
! C-1
! D-1
! E-1
! F-7
! ====================
module mod9

contains

    subroutine sub1(l, n, m, a)
        real, intent(in) :: l
        integer, intent(in) :: n, m
        real :: a(:)
        real :: b(4)

        b = a(1:4)
        print "(a, *(f6.2))", "b(out) =", b

        block
            integer :: i
            real :: b(m-n)
            do i = 1, m-n
                b(i) = l * i
            end do
            print "(a, *(f6.2))", "b(in) =", b
        end block
    end subroutine sub1
end module mod9

program sample
    use mod9
    implicit none
    integer i, res
    integer :: s = 8
    real  :: x(8)

    do i = 1,s
        x(i) = i
    end do
    print "(a, *(f6.2))", "x =", x
    call sub1(2.0, 1, s, x)
    call sub1(3.0, 5, 8, x)

contains

end program sample

! CHECK: x =  1.00  2.00  3.00  4.00  5.00  6.00  7.00  8.00
! CHECK-NEXT: b(out) =  1.00  2.00  3.00  4.00
! CHECK-NEXT: b(in) =  2.00  4.00  6.00  8.00 10.00 12.00 14.00
! CHECK-NEXT: b(out) =  1.00  2.00  3.00  4.00
! CHECK-NEXT: b(in) =  3.00  6.00  9.00
