! RUN: %flang %s -o %t && %t | FileCheck %s
! RUN: %gfortran %s -o %t && %t | FileCheck %s

! SPEC: F2008 R807, R808, C806, C807, C808, NOTE 8.5

! ====================
! A-1
! B-1
! C-1
! D-2
! E-2
! F-2
! ====================
integer function func1(n, m, a)
    integer, intent(in) :: n, m
    real :: a(:)
    real, save :: b(4)

    print "(a, *(f6.2))", "b(out) :before =", b
    b = a(1:4)

    block
        integer :: i
        real, save :: c(8)
        print "(a, *(f6.2))", "c(in) :before =", c
        do i = n, m
            c(i) = 2.5 * i
        end do
        print "(a, *(f6.2))", "c(in) :after =", c
    end block

    print "(a, *(f6.2))", "b(out) :after =", b

    func1 = 1
end function func1

program sample
    implicit none
    interface
        integer function func1(n, m, a)
            integer, intent(in) :: n, m
            real :: a(:)
        end function func1
    end interface
    integer i, res
    integer :: s = 8
    real  :: x(8)

    do i = 1,s
        x(i) = i
    end do
    print "(a, *(f6.2))", "x =", x

    res = func1(1, 5, x)
    res = func1(4, 8, x)

end program sample

! CHECK: x =  1.00  2.00  3.00  4.00  5.00  6.00  7.00  8.00
! CHECK-NEXT: b(out) :before =  0.00  0.00  0.00  0.00
! CHECK-NEXT: c(in) :before =  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00
! CHECK-NEXT: c(in) :after =  2.50  5.00  7.50 10.00 12.50  0.00  0.00  0.00
! CHECK-NEXT: b(out) :after =  1.00  2.00  3.00  4.00
! CHECK-NEXT: b(out) :before =  1.00  2.00  3.00  4.00
! CHECK-NEXT: c(in) :before =  2.50  5.00  7.50 10.00 12.50  0.00  0.00  0.00
! CHECK-NEXT: c(in) :after =  2.50  5.00  7.50 10.00 12.50 15.00 17.50 20.00
! CHECK-NEXT: b(out) :after =  1.00  2.00  3.00  4.00