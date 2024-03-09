program test
real*8  :: a(3), b
integer :: i(1)
a=(/ 3.2, 1.4, 5.7 /)
b=maxval(a); i=maxloc(a)
print *,a; print *,b; print *,i
end program test