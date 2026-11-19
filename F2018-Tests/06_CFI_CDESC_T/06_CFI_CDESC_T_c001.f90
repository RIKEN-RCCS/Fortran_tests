! RUN: %if flang %{ %not %cc %S/06_CFI_CDESC_T_c001.c -c -o %t.o 2>&1 | %FileCheck --check-prefix=FLANG --implicit-check-not='undeclared function' %s %}
! RUN: %if gfortran %{ %not %cc %S/06_CFI_CDESC_T_c001.c -c -o %t.o 2>&1 | %FileCheck --check-prefix=GFORT --implicit-check-not='implicit declaration of function' %s %}
! RUN: %if nvfortran %{ %cc %S/06_CFI_CDESC_T_c001.c -c -o %t.o 2>&1 | %FileCheck --check-prefix=NVFORT --implicit-check-not='declared implicitly' %s %}

! SPEC: N2161 2.6 [S5]

program main
end program main

! FLANG: 06_CFI_CDESC_T_c001.c:9:
! FLANG-SAME: error: incompatible pointer types

! GFORT: 06_CFI_CDESC_T_c001.c:9:
! GFORT-SAME: error: passing argument 1 of {{.*}} from incompatible pointer type

! NVFORT: 06_CFI_CDESC_T_c001.c", line 9:
! NVFORT-SAME: warning: argument of type {{.*}} is incompatible with parameter of type
