program dbees                                  ! Numerical Renaissance Codebase 1.0f
! May be compiled on a unix machine with:  g95 dbees.f90 -o dbees
!!!!!!!!!!!!!!!!!!!!!!!!!! begin user input !!!!!!!!!!!!!!!!!!!!!!!!!!
integer, parameter :: G_max=3000, G_d=3
real*8, parameter  :: T=0.01, G_thresh=0.0001, G_dt=.0005, G_dx=0.4, G_sigma=4., G_b=1., G_r=48., G_L=25.
!!!!!!!!!!!!!!!!!!!!!!!!!! end of user input !!!!!!!!!!!!!!!!!!!!!!!!!!
integer :: D_m, D_n, G_Y(G_d,G_d), timestep
real*8  :: time=0, K(G_max), Pt(G_max)=0, k1(G_d), k2(G_d), k3(G_d), k4(G_d), y(G_d), yn(G_d), ys(G_d,0:10000)
type data; sequence; real*8 :: P(G_max), f(G_max,G_d)=0, v(G_max,G_d)=0, w(G_max,G_d)=0, u(G_max,G_d)=0
                     integer :: j(G_max,G_d)=0, k(G_max,G_d)=1, i(G_max,G_d)=1
end type data
type(data) :: D

do i=1,G_d; do j=1,G_d; G_Y(i,j)=0; end do; G_Y(i,i)=1; end do
call Init_D; h1=nint(G_dx/G_dt); y=(/-11.5, -10., 10. /); ys(:,0)=y
call Modify_pointset; call Rotate_Plot
do timestep=1,nint(T/G_dt); time=time+G_dt
  if (mod(timestep,1)==0) then; call Modify_pointset; end if
  call RHS_P; D%P(2:D_n)=D%P(2:D_n)+G_dt*K(2:D_n);     
  
  call RHS(y,k1); yn=y+(G_dt/2)*k1; call RHS(yn,k2); yn=y+(G_dt/2)*k2; call RHS(yn,k3); yn=y+G_dt*k3; call RHS(yn,k4)
  yn=y+(G_dt/6)*k1+(G_dt/3)*(k2+k3)+(G_dt/6)*k4; ys(:,timestep)=yn; y=yn
  
  if (mod(timestep,10)==0) then; call Rotate_Plot; end if
end do; call Rotate_Plot
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
contains
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine Init_D
integer :: l, i, j, k
l=1
! --------------------------------------- 3D Box --------------------------------------
do i=nint(-11.7/G_dx),nint(-11.3/G_dx)
 do j=nint(-10.2/G_dx),nint(-9.8/G_dx)
  do k=nint(9.8/G_dx),nint(10.2/G_dx)
    l=l+1; D%j(l,1)=i; D%j(l,2)=j; D%j(l,3)=k; D%P(l)=1
end do; end do; end do
! ------------------------------------ Single Point -----------------------------------
! l=2; D%j(l,1:3)=nint(9/G_dx); D%P(l)=1/G_dx^3
! -------------------------------------------------------------------------------------
D_m=l; D_n=D_m; call Init_V(2)
end subroutine Init_D
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine RHS(y,k)
real*8 :: y(G_d), k(G_d)              
k=(/ G_sigma*(y(2)-y(1)),  -y(2)-y(1)*y(3),  -G_b*y(3)+y(1)*y(2)-G_b*G_r /)
end subroutine RHS
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine Init_V(b)
integer :: b, c, l, t, a(1)
real*8  :: y, x(G_d), diff(G_d)
do l=b,D_n
  x(1:G_d)=G_dx*D%j(l,1:G_d); xh=G_dx/2
  ! ----------------------------- 3D Solid Body Rotation ------------------------------
  ! D%v(l,1)=2.*j(2)*G_dx; D%v(l,2)=-2.*j(1)*G_dx; D%v(l,3)=-.5
  ! ----------------------------------- 3D Lorenz -------------------------------------
  D%v(l,1)=G_sigma*(x(2)-(x(1)+xh))
  D%v(l,2)=-(x(2)+xh)-x(1)*x(3)
  D%v(l,3)=-G_b*(x(3)+xh)+x(1)*x(2)-G_b*G_r
  ! ------------------------- (keep one of the above 2 sections) ----------------------
  do c=1,G_d; D%w(l,c)=max(D%v(l,c),0); D%u(l,c)=min(D%v(l,c),0); end do  ! Init u and w.
end do
D%i(b:D_n,1:G_d)=1; D%k(b:D_n,1:G_d)=1
do l=D_n,-1,b                                           ! Search list for neighbors to
  do t=2,l-1; diff=abs(D%j(l,:)-D%j(t,:))                  ! init i and k.  For large D_n,
    if (count(mask=(diff==0))==1)   then
	  y=maxval(diff); a=maxloc(diff); c=a(1)                     ! THIS IS THE EXPENSIVE BIT
      if     (D%j(l,c)==D%j(t,c)+1) then; D%i(l,c)=t; D%k(t,a)=l ! Due to careful programming
      elseif (D%j(t,c)==D%j(l,c)+1) then; D%k(l,c)=t; D%i(t,a)=l ! of Modify_pointset, we do
  end if; end if; end do                                  ! not call it very often...
end do
end subroutine Init_V
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine Rotate_Plot
! figure(1); ! call check_connections(D,G)
! N=nint(2*G_L/G_dx)+1; M=(N-1)/2+1; Pfull=0
! do l=2,D_n, i=D%j(l,1)+M; j=D%j(l,2)+M; k=D%j(l,3)+M
!  if i>0 .and. i<=N .and. j>0 .and. j<=N .and. k>0 .and. k<=N then; Pfull(j,i,k)=D%P(l); end if; end do
! clf; isosurface([-G_L:G_dx:G_L],[-G_L:G_dx:G_L],[-G_L:G_dx:G_L],Pfull,5*G_thresh)
! axis([-G_L G_L -G_L G_L -G_L G_L]); 
! plot3(ys(1,:),ys(2,:),ys(3,:),'k-');
! plot3(ys(1,end),ys(2,end),ys(3,end),'k*');
print *,time,D_n
end subroutine Rotate_Plot
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine Modify_pointset                         ! Shift dataset to relevant gridpoints.
integer :: c, e
D_m=D_n; l=D_m
do while (D%P(l)<G_thresh); l=l-1; D_m=D_m-1; end do; l=l-1  ! Find last big element.
do while (l>1); if (D%P(l)<G_thresh) then  ! We now move all big elements to the range 2:D_m,
  do c=1,G_d                          ! and small elements to the range D_m+1:D_n.
    if     (D%i(l,c)==D_m) then; D%i(l,c)=D%i(D_m,c); D%i(D_m,c)=l  ! First, fix pointers...
    elseif (D%i(D_m,c)==l) then; D%i(D_m,c)=D%i(l,c); D%i(l,c)=D_m
    else;  call ISwap(D%i(l,c),D%i(D_m,c));  end if
    if     (D%k(l,c)==D_m) then; D%k(l,c)=D%k(D_m,c); D%k(D_m,c)=l
    elseif (D%k(D_m,c)==l) then; D%k(D_m,c)=D%k(l,c); D%k(l,c)=D_m
    else;  call ISwap(D%k(l,c),D%k(D_m,c));  end if
    D%i(D%k(l,c),c)=l; D%i(D%k(D_m,c),c)=D_m
	D%k(D%i(l,c),c)=l; D%k(D%i(D_m,c),c)=D_m
    call ISwap(D%j(l,c),D%j(D_m,c))                     ! ... then swap elements l and D_m.
    call Swap(D%v(l,c),D%v(D_m,c)) 
    call Swap(D%f(l,c),D%f(D_m,c))
    call Swap(D%u(l,c),D%u(D_m,c))
    call Swap(D%w(l,c),D%w(D_m,c))
  end do                                            
  call Swap(D%P(l),  D%P(D_m))    
  D_m=D_m-1
end if; l=l-1; end do           
D%f(D_m+1:D_n,1)=0                ! Next, identify the neighbors to the big elements,
do l=2,D_m; do c=1,G_d            ! and create entries for them if necessary.
  if (D%i(l,c)==1) then; call Create(D%j(l,:)-G_Y(c,:)); else; D%f(D%i(l,c),1)=1; end if
  if (D%k(l,c)==1) then; call Create(D%j(l,:)+G_Y(c,:)); else; D%f(D%k(l,c),1)=1; end if
  do e=c,G_d                      ! (the following computes the corner entries)
    if (D%i(D%i(l,e),c)==1) then; call Create(D%j(l,:)-G_Y(c,:)-G_Y(e,:))
	  else; D%f(D%i(D%i(l,e),c),1)=1; end if
    if (D%i(D%k(l,e),c)==1) then; call Create(D%j(l,:)-G_Y(c,:)+G_Y(e,:))
	  else; D%f(D%i(D%k(l,e),c),1)=1; end if
    if (D%k(D%i(l,e),c)==1) then; call Create(D%j(l,:)+G_Y(c,:)-G_Y(e,:))
	  else; D%f(D%k(D%i(l,e),c),1)=1; end if
    if (D%k(D%k(l,e),c)==1) then; call Create(D%j(l,:)+G_Y(c,:)+G_Y(e,:))
	  else; D%f(D%k(D%k(l,e),c),1)=1; end if
  end do
end do; end do                     ;  print *,D_n;
l=D_m+1; do while (l<=D_n); if (D%f(l,1)/=1) then ! Remove small elements which do not neighbor
  do c=1,G_d                                 ! the big elements.  First, fix pointers...
    D%i(D%k(l,c),c)=1; if (l<D_n) then; D%i(D%k(D_n,c),c)=l; end if
    D%k(D%i(l,c),c)=1; if (l<D_n) then; D%k(D%i(D_n,c),c)=l; end if
    if (sum(abs(D%j(D_n,:)-G_Y(c,:)-D%j(l,:)))==0) then; D%i(l,c)=1; else; D%i(l,c)=D%i(D_n,c); end if
    if (sum(abs(D%j(D_n,:)+G_Y(c,:)-D%j(l,:)))==0) then; D%k(l,c)=1; else; D%k(l,c)=D%k(D_n,c); end if
  end do                                        
  D%j(l,:)=D%j(D_n,:); D%P(l)=D%P(D_n); D%v(l,:)=D%v(D_n,:)     ! then replace element
  D%u(l,:)=D%u(D_n,:); D%w(l,:)=D%w(D_n,:); D%f(l,1)=D%f(D_n,1) ! l with element D_n.
  D_n=D_n-1
else; l=l+1; end if; end do
do l=2,D_n; D%P(l)=max(D%P(l),0); end do; D%P(1)=0; D%i(1,1:G_d)=1; D%k(1,1:G_d)=1
D%P(1:D_n)=D%P(1:D_n)/sum(D%P(1:D_m)); 
end subroutine Modify_pointset
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine Swap(a,b);  real*8  :: a,b,c; c=a; a=b; b=c; end subroutine Swap  ! Swap two reals
subroutine ISwap(i,j); integer :: i,j,k; k=i; i=j; j=k; end subroutine ISwap ! Swap two integers
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine Create(j)                            ! Create a new element in D
integer :: j(G_d)
D_n=D_n+1; D%P(D_n)=0; D%j(D_n,:)=j; call Init_V(D_n); D%f(D_n,1)=1
end subroutine Create
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine RHS_P
integer :: c, l, e, p
D%f(1:D_n,1:G_d)=0; D%P(1)=0; K(1:D_n)=0
! -------------------------------- NONCONSERVATIVE FORM -------------------------------
! do l=2,D_n; do c=1,G_d; K(l)=K(l)-D%w(D%i(l,c),c)*(D%P(l)-D%P(D%i(l,c)))/G_dx &
! &		                 -D%u(l,c)*(D%P(D%k(l,c))-D%P(l))/G_dx;  end do; end do
! --------------------------------- CONSERVATIVE FORM ---------------------------------                                         
do l=2,D_n; do c=1,G_d; D%f(l,c)=D%w(l,c)*D%P(l)+D%u(l,c)*D%P(D%k(l,c)); end do; end do
! ------------------------ (keep one of the above 2 sections) -------------------------
do c=1,G_d; do l=2,D_n; i=D%i(l,c); if (l<=D_m .or. (i>1 .and. i<=D_m)) then
  F=G_dt*(D%P(l)-D%P(i))/(2*G_dx);      
  do e=1,G_d; if (e/=c) then
    D%f(l,e)=D%f(l,e)-D%w(l,e)*D%w(i,c)*F; j=D%i(l,e)   ! Compute corner transport
    D%f(j,e)=D%f(j,e)-D%u(j,e)*D%w(i,c)*F;              ! upwind (CTU) flux terms.
    D%f(i,e)=D%f(i,e)-D%w(i,e)*D%u(i,c)*F; p=D%i(i,e)
    D%f(p,e)=D%f(p,e)-D%u(p,e)*D%u(i,c)*F;
   end if; end do
  if (D%v(i,c)>0) then; th=(D%P(i)-D%P(D%i(i,c)))/(D%P(l)-D%P(i))         ! Compute second-order
  else;                 th=(D%P(D%k(l,c))-D%P(l))/(D%P(l)-D%P(i)); end if ! correction flux term.
  av=abs(D%v(i,c)); D%f(i,c)=D%f(i,c)+av*(G_dx/G_dt-av)*F*MC(th)          ! Flux: use MC or VL.
end if; end do; end do
do l=2,D_n; do c=1,G_d; K(l)=K(l)-(D%f(l,c)-D%f(D%i(l,c),c))/G_dx; end do; end do
end subroutine RHS_P
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
real function MC(th); MC=max(0,min((1+th)/2,2,2*th));     end function MC  ! Flux limiters
real function VL(th); VL=min((th+abs(th))/(1+abs(th)),0); end function VL
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine check_connections
integer :: c, l
do l=2,D_n; do c=1,G_d
  if ((D%i(l,c)>1) .and. sum(abs(D%j(D%i(l,c),:)+G_Y(c,:)-D%j(l,:)))>0) then; print *,'prob!'; end if
  if ((D%k(l,c)>1) .and. sum(abs(D%j(D%k(l,c),:)-G_Y(c,:)-D%j(l,:)))>0) then; print *,'prob!'; end if
end do; end do; print *,'checked!'
end subroutine check_connections
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end program dbees
