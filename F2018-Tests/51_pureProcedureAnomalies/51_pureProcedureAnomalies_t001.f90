! RUN: %if flang %{ %flang %s -o %t %}
! RUN: %if flang %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if flang %{ FileCheck --check-prefix=OUT --implicit-check-not=after_stop %s < %t.out %}
! RUN: %if flang %{ bash -c 'FileCheck --check-prefix=REC-ERR %s < %t.err > /dev/null 2>&1 || echo "recommended_differs: REC-ERR"' %}
! RUN: %if flang %{ bash -c 'FileCheck --check-prefix=REC-ST %s < %t.st > /dev/null 2>&1 || echo "recommended_differs: REC-ST"' %}
! RUN: %if gfortran %{ %gfortran %s -o %t %}
! RUN: %if gfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if gfortran %{ FileCheck --check-prefix=OUT --implicit-check-not=after_stop %s < %t.out %}
! RUN: %if gfortran %{ bash -c 'FileCheck --check-prefix=REC-ERR %s < %t.err > /dev/null 2>&1 || echo "recommended_differs: REC-ERR"' %}
! RUN: %if gfortran %{ bash -c 'FileCheck --check-prefix=REC-ST %s < %t.st > /dev/null 2>&1 || echo "recommended_differs: REC-ST"' %}
! RUN: %if nvfortran %{ %nvfortran %s -o %t %}
! RUN: %if nvfortran %{ bash -c '%t > %t.out 2> %t.err; echo "status=$?" > %t.st' %}
! RUN: %if nvfortran %{ FileCheck --check-prefix=OUT --implicit-check-not=after_stop %s < %t.out %}
! RUN: %if nvfortran %{ bash -c 'FileCheck --check-prefix=REC-ERR %s < %t.err > /dev/null 2>&1 || echo "recommended_differs: REC-ERR"' %}
! RUN: %if nvfortran %{ bash -c 'FileCheck --check-prefix=REC-ST %s < %t.st > /dev/null 2>&1 || echo "recommended_differs: REC-ST"' %}

! SPEC: N2161 5.25 [S1]

module m_pure
  implicit none
contains
  pure function safe_sqrt(x) result(r)
    real, intent(in) :: x
    real :: r
    if (x < 0.0) error stop 'negative argument'
    r = sqrt(x)
  end function safe_sqrt
end module m_pure

program pureProcedureAnomalies_t001
  use, intrinsic :: iso_fortran_env, only: output_unit
  use m_pure
  implicit none
  integer :: n
  real :: y

  n = command_argument_count()
  write(*,'(A)') 'before_stop=T'
  flush(output_unit)
  y = safe_sqrt(-1.0 - n)
  write(*,'(A,F0.1)') 'after_stop=T y=', y
end program pureProcedureAnomalies_t001

! OUT: before_stop=T
! REC-ERR: negative argument
! REC-ST: status={{[1-9][0-9]*}}
