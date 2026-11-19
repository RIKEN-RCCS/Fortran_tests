! RUN: %if flang %{ %flang %s -o %t && %t | FileCheck %s %}
! RUN: %if gfortran %{ %gfortran %s -o %t && %t | FileCheck %s %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t && %t | FileCheck %s %}

! SPEC: N2161 5.23 [S1, S3]

module m_g
  implicit none
  type :: circle
    real :: r
  end type circle
  generic :: write(formatted) => write_c
contains
  subroutine write_c(dtv, unit, iotype, v_list, iostat, iomsg)
    class(circle), intent(in) :: dtv
    integer, intent(in) :: unit
    character(*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(*), intent(inout) :: iomsg
    write(unit, '(A,F0.1,A)', iostat=iostat, iomsg=iomsg) 'circle(', dtv%r, ')'
  end subroutine write_c
end module m_g

program genericStatement_005
  use m_g
  implicit none
  real :: x
  x = real(command_argument_count())
  write(*,'(A,DT)') 'dtio=', circle(1.5 + x)
end program genericStatement_005

! CHECK: dtio=circle(1.5)
