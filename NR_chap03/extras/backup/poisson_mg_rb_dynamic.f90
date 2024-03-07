program RC_poisson_mg_rb             ! A 2D Poisson solver on uniform mesh using Multigrid
implicit none                     ! and Red/Black RC_Gauss-Seidel (Fortran90 syntax).
real     :: max_error             ! By Paolo Luchini, Thomas Bewley, and Anish Karandikar.
integer  :: i, j, smooth, ta(8)
real*8   :: sum, e, o, t
real*8, dimension(:,:), allocatable :: v, d, di
type grid; sequence; integer xbc, ybc, nx, ny, xo, yo, xm, ym; end type grid;
type(grid) :: g
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Take XBC and YBC = 1 for homogeneous Dirichlet (grid:  0:NX   and  0:NY  ), 
!                  = 2 for homogeneous Neumann   (grid: -1:NX+1 and -1:NY+1), and
!                  = 3 for periodic              (grid: -1:NX   and -1:NY  ).
integer, parameter :: XBC = 1, YBC = 1, NX = 1024, NY = 1024,  n1=2, n2=1, n3=2
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
g%xbc = XBC; g%ybc = YBC; g%nx = NX; g%ny = NY;
print *, 'Grid: nx = ',g%nx,', ny = ',g%ny,'  BCs: (',g%xbc,',',g%ybc,')'
select case(g%xbc); case(1); g%xm=g%nx+1; g%xo=1
                    case(2); g%xm=g%nx+3; g%xo=2
                    case(3); g%xm=g%nx+2; g%xo=2; end select
select case(g%ybc); case(1); g%ym=g%ny+1; g%yo=1
                    case(2); g%ym=g%ny+3; g%yo=2
                    case(3); g%ym=g%ny+2; g%yo=2; end select
allocate(v(g%xm, g%ym),d(g%xm, g%ym),di(g%xm-4, g%ym-4)); v = 0.0; d = 0.0
call random_seed; sum = 0.0
do i=1,g%xm-4; do j=1,g%ym-4; call random_number(di(i,j)); sum=sum+di(i,j); end do; end do
di=di-sum/((g%xm-4)*(g%ym-4)); d(3:g%xm-2,3:g%ym-2)=di
e = max_error(v,d,g,g%xm,g%ym); print *,'Iteration =  0 , error = ',e
do smooth=1,n1; call RC_poisson_rb(v,d,g,g%xm,g%ym); end do
call date_and_time(values=ta); t = ta(5)*3600 + ta(6)*60 + ta(7) + 0.001*ta(8)
main: do i=1,15
   o=e; call RC_poisson_mg(v,d,g,g%xm,g%ym,n2,n3); e = max_error(v,d,g,g%xm,g%ym)
   print *,'Iteration = ',i,', error = ',e,', factor = ',o/e
   if (o/e==1) then; print *,'Converged'; exit main; end if
end do main
deallocate(v,d,di); 
call date_and_time(values=ta); t = ta(5)*3600 + ta(6)*60 + ta(7) + 0.001*ta(8) - t
print *,'Total wall time =',t,'sec for',i,'iterations  -> time/iteration: ',t/i,' sec'
end program RC_poisson_mg_rb
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine enforce_bcs(v,g,gxm,gym)
! Enforce the Neumann and/or periodic boundary conditions (nothing to do for Dirichlet)
integer    :: gxm,gym,m,n
real*8, dimension(gxm,gym) :: v
type grid; sequence; integer xbc, ybc, nx, ny, xo, yo, xm, ym; end type grid;
type(grid) :: g
select case(g%xbc); case(2); m=g%ym-1; v(1,2:m)=v(3,     2:m); v(g%xm,2:m)=v(g%xm-2,2:m)
                    case(3); m=g%ym-1; v(1,2:m)=v(g%xm-1,2:m); v(g%xm,2:m)=v(2,     2:m)
end select
select case(g%ybc); case(2); n=g%xm-1; v(2:n,1)=v(2:n,3     ); v(2:n,g%ym)=v(2:n,g%ym-2)
                    case(3); n=g%xm-1; v(2:n,1)=v(2:n,g%ym-1); v(2:n,g%ym)=v(2:n,2     )
end select     
end subroutine enforce_bcs
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
recursive subroutine RC_poisson_mg(vf,df,gf,gfxm,gfym,n2,n3)
integer    :: gfxm, gfym, n2, n3, smooth, ic, jc
real*8, dimension(gfxm, gfym)       :: vf, df
real*8, dimension(:,:), allocatable :: vc, dc
type grid; sequence; integer xbc, ybc, nx, ny, xo, yo, xm, ym; end type grid;
type(grid) :: gf, gc
gc%nx=gf%nx/2;  gc%ny=gf%ny/2;  gc%xbc=gf%xbc;  gc%ybc=gf%ybc; 
select case(gc%xbc); case(1); gc%xm=gc%nx+1; gc%xo=1
                     case(2); gc%xm=gc%nx+3; gc%xo=2
                     case(3); gc%xm=gc%nx+2; gc%xo=2; end select
select case(gc%ybc); case(1); gc%ym=gc%ny+1; gc%yo=1
                     case(2); gc%ym=gc%ny+3; gc%yo=2
                     case(3); gc%ym=gc%ny+2; gc%yo=2; end select
do smooth=1,n2; call RC_poisson_rb(vf,df,gf,gf%xm,gf%ym); end do 
allocate(vc(gc%xm,gc%ym),dc(gc%xm,gc%ym)); dc = 0.0
do jc=2,gc%ym-1;  do ic=2,gc%xm-1                               ! Compute residual and
   i=2*(ic-gc%xo)+gf%xo; j=2*(jc-gc%yo)+gf%yo;                  ! restrict to coarser grid
   dc(ic,jc)=((vf(i,j+1)+vf(i,j-1)+vf(i+1,j)+vf(i-1,j))*0.25-vf(i,j)+df(i,j));
end do; end do
vc=dc; call enforce_bcs(vc,gc,gc%xm,gc%ym)
if (gc%nx > 3 .and. gc%ny > 3 .and. mod(gf%nx,4)==0 .and. mod(gf%ny,4)==0) then
   call RC_poisson_mg(vc,dc,gc,gc%xm,gc%ym,n2,n3)                   ! Continue to even
else                                                             ! coarser grid, or
   do smooth=1,20; call RC_poisson_rb(vc,dc,gc,gc%xm,gc%ym); end do ! solve coarsest system
end if
do jc=2,gc%ym;  do ic=2,gc%xm                                    ! Prolongation back to
   i=2*(ic-gc%xo)+gf%xo; j=2*(jc-gc%yo)+gf%yo;                   ! finer grid
   if (j<=gf%ym) then; vf(i-1,j)=vf(i-1,j)+(vc(ic-1,jc)+vc(ic,jc)); end if
   if (i<=gf%xm) then; vf(i,j-1)=vf(i,j-1)+(vc(ic,jc-1)+vc(ic,jc)); end if
end do; end do
call enforce_bcs(vf,gf,gf%xm,gf%ym);  deallocate(vc,dc)
do smooth=1,n3; call RC_poisson_rb(vf,df,gf,gf%xm,gf%ym); end do  
end subroutine RC_poisson_mg
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine RC_poisson_rb(v,d,g,gxm,gym)
integer :: gxm, gym, rb, i, j, m, n, mp, mm, np, nm, jp, jm
real*8, dimension(gxm,gym) :: v, d
type grid; sequence; integer xbc, ybc, nx, ny, xo, yo, xm, ym; end type grid;
type(grid) :: g
do rb=0,1; do j=2,g%ym-1                 ! Update red points first, then black points
   m=2+mod(j+rb+g%xo+g%yo,2); n=g%xm-1;  ! In Fortran, inner loop should be on FIRST index
   mp=m+1; mm=m-1; np=n+1; nm=n-1; jp=j+1; jm=j-1;
   v(m:n:2,j)=(v(mp:np:2,j)+v(mm:nm:2,j)+v(m:n:2,jp)+v(m:n:2,jm))*0.25+d(m:n:2,j);
end do; call enforce_bcs(v,g,g%xm,g%ym); end do
end subroutine RC_poisson_rb
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
real function max_error(v,d,g,gxm,gym)
integer :: gxm, gym, i, j
real*8, dimension(gxm,gym) :: v, d
type grid; sequence; integer xbc, ybc, nx, ny, xo, yo, xm, ym; end type grid;
type(grid) :: g
max_error = 0.0; do j=2,g%ny;  do i=2,g%nx
   max_error=max(max_error,abs((v(i,j+1)+v(i,j-1)+v(i+1,j)+v(i-1,j))*0.25+d(i,j)-v(i,j)))
end do;  end do
end function max_error
