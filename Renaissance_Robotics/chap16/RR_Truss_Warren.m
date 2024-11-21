% script RR_Truss_Warren.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=4;     % number of horizontal sections in the truss
h=-0.3;   % height of the truss
parabolic_top_chord=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear Q P C U
% Locations of the fixed nodes of the truss (normalized units)
P=[0 1; 0 0]; p=2;  

% Locations of the free nodes of the Warren truss (for arbitrary s and h)
for i=1:s-1, Q(:,i)  =[i/s;       0]; end      % free nodes in bottom row
for i=0:s-1, Q(:,s+i)=[(i+0.5)/s; h]; end      % free nodes in top row
if parabolic_top_chord, for i=0:s-1, Q(2,s+i)=[h-4*h*((i+0.5)/s-0.5)^2]; end, end
q=2*s-1; n=q+p;

% External forces on the free nodes of the truss (normalized)
U=zeros(2,q);  U(2,floor(s/2))=-1;

% Connectivity of the Warren truss
% Note: each column of C^T has exactly one entry equal to +1, and one entry equal to -1.
m=4*s-1; C=zeros(m,q+p);
C(1,n-1)=-1;   C(1,1)=1; j=1;                               % bottom row to left fixed node
for i=1:s-2,   C(j+i,i)=-1; C(j+i,i+1)=1;  end, j=j+s-2;    % bottom row
C(j+1,s-1)=-1; C(j+1,n)=1; j=j+1;                           % bottom row to right fixed node
for i=1:s-1,   C(j+i,s-1+i)=-1; C(j+i,s+i)=1; end, j=j+s-1; % top row
C(j+1,n-1)=-1; C(j+1,s)=1; j=j+1;                           % left diagonal to fixed node
for i=1:s-1,   C(j+2*i-1,s+i-1)=-1; C(j+2*i-1,i)=1;         % internal diagonals
               C(j+2*i,i)=1;        C(j+2*i,s+i)=-1; end, j=j+2*s-2;  
C(j+1,n-2)=-1; C(j+1,n)=1; j=j+1;                             % right diagonal to fixed node

% Now, convert the D*X*CQ=U problem in (3a) to the standard A*x=u form in (3b)
[A,u]=RR_Convert_DXCQ_eq_U_to_Ax_eq_u(Q,P,C,U); 
% Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
x=pinv(A)*u; residual=norm(A*x-u),
if residual>1e-8, disp('No equilibrium solution'), beep, end
% Finally, plot the truss (blue = tension, red = compression)
RR_Plot_Truss(Q,P,C,U,x);
