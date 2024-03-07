program RC_poisson_mg_rb_3d
! A 3D Poisson solver on uniform mesh using Multigrid and Red/Black RC_Gauss-Seidel.
! By Thomas Bewley and Paolo Luchini
include 'RC_poisson_mg_rb_3d.header'
integer :: ta(8);  real*8 :: s, c, y, u, t, w, z, e, nudge, max_error 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! USER INPUT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! XBC=1 for hom. Dirichlet (0:NX), =2 for periodic (-1:NX), =3 for hom. Neumann (-1:NX+1).
! Similar for YBC, ZBC.   NX, NY, NZ must be powers of two.
NX=128; NY=256; NZ=512; XBC=3; YBC=2; ZBC=1; N1=3; N2=3; N3=2
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! END OF USER INPUT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
print *, 'BCs: ',XBC,',',YBC,',',ZBC,'. Smoothing: ',N1,',',N2,',',N3,'.  Grids:'
select case(XBC); case(1); xo=1; case(2); xo=2; case(3); xo=2; end select
select case(YBC); case(1); yo=1; case(2); yo=2; case(3); yo=2; end select
select case(ZBC); case(1); zo=1; case(2); zo=2; case(3); zo=2; end select
nlev=int(log10(real(min(NX,NY,NZ)))/log10(2.0))-1; call random_seed;                  
do lev=0,nlev
   g(lev)%nx = NX/(2**lev); g(lev)%ny = NY/(2**lev); g(lev)%nz = NZ/(2**lev);
   g(lev)%xm=g(lev)%nx+XBC; g(lev)%ym=g(lev)%ny+YBC; g(lev)%zm=g(lev)%nz+ZBC;
   allocate(v(lev)%d(g(lev)%xm,g(lev)%ym,g(lev)%zm));
   allocate(d(lev)%d(g(lev)%xm,g(lev)%ym,g(lev)%zm));
   v(lev)%d=0.0d0; d(lev)%d=0.0d0;  print *,lev,g(lev)%nx,g(lev)%ny,g(lev)%nz
end do
do k=4,g(0)%zm-3; do j=4,g(0)%ym-3; do i=4,g(0)%xm-3
   call random_number(harvest); d(0)%d(i,j,k) = harvest-0.5;
end do; end do; end do;
s=sum(d(0)%d); print *,'SumA = ',s; nudge=s/dfloat((g(0)%xm-6)*(g(0)%ym-6)*(g(0)%zm-6)); 
do k=4,g(0)%zm-3; do j=4,g(0)%ym-3; do i=4,g(0)%xm-3
   d(0)%d(i,j,k)=d(0)%d(i,j,k)-nudge;
end do; end do; end do; s=sum(d(0)%d); print *,'SumB = ',s;

e = max_error(0); print *,'Iteration =  0 , error = ',e	
do i=1,N1; call RC_poisson_rb(0); end do 
call date_and_time(values=ta); t = ta(5)*3600 + ta(6)*60 + ta(7) + 0.001*ta(8) 
iter=1; do
   o=e; call RC_poisson_mg(0); e = max_error(0)
   print *,'Iteration = ',iter,', error = ',e, 'factor = ', o/e
   if (e<1E-12) then; print *,'Converged'; exit; end if 
   if (iter==10) then; print *,'Fed up, quitting.'; exit; end if; iter=iter+1
end do 
call date_and_time(values=ta); t = ta(5)*3600 + ta(6)*60 + ta(7) + 0.001*ta(8) - t 
print *,'Total time =',t,'sec for',iter,'iterations -> time/iteration: ',t/iter,' sec'
do lev=0,nlev; deallocate(v(lev)%d); deallocate(d(lev)%d); end do	
end program RC_poisson_mg_rb_3d
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine enforce_bcs(lev)
include 'RC_poisson_mg_rb_3d.header'
! Enforce the Neumann and/or periodic boundary conditions (nothing to do for Dirichlet)
i=g(lev)%xm; j=g(lev)%ym; k=g(lev)%zm; 
if (XBC==3) then; v(lev)%d(1,        1:j,1:k)=v(lev)%d(3,          1:j,1:k)
				  v(lev)%d(g(lev)%xm,1:j,1:k)=v(lev)%d(g(lev)%xm-2,1:j,1:k); end if
if (YBC==3) then; v(lev)%d(1:i,1,        1:k)=v(lev)%d(1:i,3,          1:k)
				  v(lev)%d(1:i,g(lev)%ym,1:k)=v(lev)%d(1:i,g(lev)%ym-2,1:k); end if
if (ZBC==3) then; v(lev)%d(1:i,1:j,1        )=v(lev)%d(1:i,1:j,3          ) 
				  v(lev)%d(1:i,1:j,g(lev)%zm)=v(lev)%d(1:i,1:j,g(lev)%zm-2); end if
if (XBC==2) then; v(lev)%d(1,        1:j,1:k)=v(lev)%d(g(lev)%xm-1,1:j,1:k) 
				  v(lev)%d(g(lev)%xm,1:j,1:k)=v(lev)%d(2,          1:j,1:k); end if
if (YBC==2) then; v(lev)%d(1:i,1,        1:k)=v(lev)%d(1:i,g(lev)%ym-1,1:k)
                  v(lev)%d(1:i,g(lev)%ym,1:k)=v(lev)%d(1:i,2,          1:k); end if
if (ZBC==2) then; v(lev)%d(1:i,1:j,1        )=v(lev)%d(1:i,1:j,g(lev)%zm-1) 
                  v(lev)%d(1:i,1:j,g(lev)%zm)=v(lev)%d(1:i,1:j,2          ); end if
end subroutine enforce_bcs
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
recursive subroutine RC_poisson_mg(lev)
real*8 :: sum, nudge
include 'RC_poisson_mg_rb_3d.header'
do i=1,N2; call RC_poisson_rb(lev); end do 
do kc=2,g(lev+1)%zm-1; do jc=2,g(lev+1)%ym-1; do ic=2,g(lev+1)%xm-1 ! Compute residual and 
   i=2*(ic-xo)+xo; j=2*(jc-yo)+yo; k=2*(kc-zo)+zo               ! restrict to coarser grid
   d(lev+1)%d(ic,jc,kc)=(v(lev)%d(i+1,j,k)    +v(lev)%d(i-1,j,k) +v(lev)%d(i,j+1,k)  &
      & +v(lev)%d(i,j-1,k) +v(lev)%d(i,j,k+1) +v(lev)%d(i,j,k-1))/6.d0               &
      & -v(lev)%d(i,j,k)   +d(lev)%d(i,j,k);                                  
end do; end do; end do
v(lev+1)%d=d(lev+1)%d; call enforce_bcs(lev)
if (lev<nlev-1) then; call RC_poisson_mg(lev+1)     ! Continue to even coarser grid, or
else; do i=1,50; call RC_poisson_rb(nlev); end do   ! solve coarsest system (almost exactly)
end if 
do kc=2,g(lev+1)%zm; do jc=2,g(lev+1)%ym; do ic=2,g(lev+1)%xm ! Prolongation (using
   i=2*(ic-xo)+xo; j=2*(jc-yo)+yo; k=2*(kc-zo)+zo             ! bilinear interpolation)
   if ((j<=g(lev)%ym).and.(k<=g(lev)%zm)) then                ! on black interior points
      v(lev)%d(i-1,j,k) = v(lev)%d(i-1,j,k)+(v(lev+1)%d(ic-1,jc,kc)+v(lev+1)%d(ic,jc,kc));
   end if
   if ((i<=g(lev)%xm).and.(k<=g(lev)%zm)) then
      v(lev)%d(i,j-1,k) = v(lev)%d(i,j-1,k)+(v(lev+1)%d(ic,jc-1,kc)+v(lev+1)%d(ic,jc,kc));
   end if
   if ((i<=g(lev)%xm).and.(j<=g(lev)%ym)) then
      v(lev)%d(i,j,k-1) = v(lev)%d(i,j,k-1)+(v(lev+1)%d(ic,jc,kc-1)+v(lev+1)%d(ic,jc,kc));
   end if
v(lev)%d(i-1,j-1,k-1)=v(lev)%d(i-1,j-1,k-1)+(v(lev+1)%d(ic,jc,kc)+v(lev+1)%d(ic-1,jc,kc) &
   & + v(lev+1)%d(ic,jc-1,kc)  +v(lev+1)%d(ic-1,jc-1,kc) + v(lev+1)%d(ic,jc,kc-1)        &
   & + v(lev+1)%d(ic-1,jc,kc-1)+v(lev+1)%d(ic,jc-1,kc-1)+v(lev+1)%d(ic-1,jc-1,kc-1))*0.25;
end do; end do; end do    ! Note that the next call to RC_poisson_rb takes care of red points
call enforce_bcs(lev)
do i=1,N3; call RC_poisson_rb(lev); end do 
end subroutine RC_poisson_mg 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine RC_poisson_rb(lev)
include 'RC_poisson_mg_rb_3d.header'      ! Apply Red/Black RC_Gauss-Seidel, with L from Poisson
do irb=0,1; do k=2,g(lev)%zm-1; do j=2,g(lev)%ym-1   ! update red points first, then black
m=2+mod(j+k+irb+xo+yo+zo,2); n=g(lev)%xm-1;
mp=m+1; mm=m-1; np=n+1; nm=n-1; jp=j+1; jm=j-1; kp=k+1; km=k-1
v(lev)%d(m:n:2,j,k)=(v(lev)%d(mp:np:2,j,k) +v(lev)%d(mm:nm:2,j,k) +v(lev)%d(m:n:2,jp,k) &
   & +v(lev)%d(m:n:2,jm,k) +v(lev)%d(m:n:2,j,kp) +v(lev)%d(m:n:2,j,km))/6.d0            &
   & +d(lev)%d(m:n:2,j,k);
end do; end do; call enforce_bcs(lev); end do
end subroutine RC_poisson_rb
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
real*8 function max_error(lev)
include 'RC_poisson_mg_rb_3d.header' 
max_error = 0.0; do k=2,g(lev)%nz; do j=2,g(lev)%ny; do i=2,g(lev)%nx
max_error = max(max_error,abs((v(lev)%d(i+1,j,k) + v(lev)%d(i-1,j,k) +v(lev)%d(i,j+1,k) &
   & +v(lev)%d(i,j-1,k) +v(lev)%d(i,j,k-1) + v(lev)%d(i,j,k+1))/6.d0                    &
   & +d(lev)%d(i,j,k)   -v(lev)%d(i,j,k)))
end do; end do; end do
end function max_error
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
recursive subroutine RC_MergeSort(x,a,b)
! This subroutine reorders the vector x based on the elements in its first column.
integer :: b,a,b1,a1; real*8 :: t, x(:)
include 'RC_poisson_mg_rb_3d.header' 
if (b-a>0) then
  b1=a+int((b-a)/2); a1=b1+1; call RC_MergeSort(x,a,b1); call RC_MergeSort(x,a1,b);
  do; if ((b1-a<0) .or. (b-a1<0)) then; exit; end if; 
      if (x(a1)<x(a)) then; t=x(a1); x(a+1:a1)=x(a:a1-1); x(a)=t; a1=a1+1; b1=b1+1; end if
  a=a+1; end do;
end if
end subroutine RC_MergeSort
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

