function RR_Four_Bar_Seesaw(lA,lB,phi,fyA,fyB,h,w,verbose,ax)

% This function solves and plots the forces in a four-bar seesaw
% INPUTS: lA,  lB   % Locations of the masses, in meters
%         fyA, fyB  % Values of the externally-applied forces, in Newtons
%         phi       % Deflection of the frame, in degrees
%         h, w      % Parameters defining the physical frame, in meters
%         verbose   % OPTIONAL Logical flag (prints useful diagnostics to screen if true)
% TEST:   RR_Four_Bar_Seesaw(.03,.18,1,1,10,.1,.2,true)

lA=lA/100; lB=lB/100; phi=phi*pi/180;

c=cos(phi); s=sin(phi); % (intermediate variables)

% x=[fCAx fCAy fCGx fCGy fCBx fCBy fDAx fDAy fDGx fDGy fDBx fDBy
  A=[  1    0    0    0    0    0    1    0    0    0    0    0;
       0    1    0    0    0    0    0    1    0    0    0    0;
       0    0    0    0    1    0    0    0    0    0    1    0;
       0    0    0    0    0    1    0    0    0    0    0    1;
       1    0    1    0    1    0    0    0    0    0    0    0;
       0    1    0    1    0    1    0    0    0    0    0    0;
       0    0    0    0    0    0    1    0    1    0    1    0;
       0    0    0    0    0    0    0    1    0    1    0    1;
      -h    0    0    0    0    0    h    0    0    0    0    0;
       0    0    0    0   -h    0    0    0    0    0    h    0;
       s    c    0    0   -s   -c    0    0    0    0    0    0;
       0    0    0    0    0    0    s    c    0    0   -s   -c];
  
  b=[  0   fyA   0   fyB   0    0    0    0 -lA*fyA lB*fyB 0  0]';

x=pinv(A)*b;  % Use the pseudoinverse!

if nargin<9, ax=axes, end
plotframe(h,w,phi,fyA,fyB,lA,lB,x,ax)

if nargin>8 & verbose
  [C,L,R,N,Ap,r]=RR_Subspaces(A,false); r, 
  disp('here is the error of A*x=b');
  eps=norm(A*x-b); pause
  disp('here is x_N (a vector that spans the nullspace), and the error of A*(x+x_N)=b');    
  N, check=norm(A*N), alpha=randn*100, x1=x+alpha*N
  eps=norm(A*x1-b); pause
  disp('here is a vector that spans the left nullspace')
  L
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotframe(h,w,phi,fyA,fyB,lA,lB,x,ax)

cla(ax), hold(ax,"on")
c=cos(phi); s=sin(phi); fac=0.1;
plot(ax,[0 0],        [-h 3*h],         'k-',LineWidth=6)   % Draw the frame itself
plot(ax,[-2*w  2*w],  [-h -h],          'k-',LineWidth=10)
plot(ax,[-w*c  w*c],  [3*h+w*s 3*h-w*s],'b-',LineWidth=3)
plot(ax,[-w*c  w*c],  [1*h+w*s 1*h-w*s],'r-',LineWidth=3)
plot(ax,[-w*c -w*c],  [3*h+w*s 1*h+w*s],'k-',LineWidth=3)
plot(ax,[ w*c  w*c],  [3*h-w*s 1*h-w*s],'k-',LineWidth=3)
plot(ax,[-w*c -w*c-w],[2*h+w*s 2*h+w*s],'k-',LineWidth=3)
plot(ax,[ w*c  w*c+w],[2*h-w*s 2*h-w*s],'k-',LineWidth=3)

arrow=@(x,y,varargin) quiver(ax,x(1),y(1),x(2)-x(1),y(2)-y(1),0, ...   % plots a vector
                      varargin{:},'linewidth',3,'MaxHeadSize',10);
arrow([-w*c-lA -w*c-lA],    [2*h+w*s+fac*fyA 2*h+w*s], 'color','k'); % applied forces
arrow([ w*c+lB  w*c+lB],    [2*h-w*s+fac*fyB 2*h-w*s], 'color','k');
arrow([-w*c  -w*c+x(1)*fac],[3*h+w*s 3*h+w*s+x(2)*fac],'color','b'); % internal forces
arrow([ 0         x(3)*fac],[3*h     3*h+x(4)*fac],    'color','b');
arrow([ w*c   w*c+x(5)*fac],[3*h-w*s 3*h-w*s+x(6)*fac],'color','b');
arrow([-w*c  -w*c+x(7)*fac],[h+w*s   h+w*s+x(8)*fac],  'color','r');
arrow([ 0         x(9)*fac],[h       h+x(10)*fac],     'color','r');
arrow([ w*c  w*c+x(11)*fac],[h-w*s   h-w*s+x(12)*fac], 'color','r');
plot(ax,-2.5*w,-2*h,'k.')
plot(ax, 2.5*w,-2*h,'k.')
plot(ax,-2.5*w, 5*h,'k.')
plot(ax, 2.5*w, 5*h,'k.')
axis equal
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
