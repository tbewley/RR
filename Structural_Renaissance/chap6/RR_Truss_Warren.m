% script RR_Truss_Warren.m
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a slight generalization of RR_Truss_Warren4, with 3 parameters
% For the kitchen-sink generalization, see RR_Truss_GUI.  Easy.  Enjoy!
s=5;     % number of horizontal sections in the truss (set as parameter!)
h=0.4;   % height of the truss (set as parameter!)
parabolic_top_chord=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear Q P C U, figure(1), clf
% Locations of the fixed nodes of the truss (normalized units)
P=[0 1; 0 0]; p=2;  

% Locations of the free nodes of the Warren truss (for arbitrary s and h)
for i=1:s-1, Q(:,i)  =[i/s;       0]; end      % free nodes in bottom row
for i=0:s-1, Q(:,s+i)=[(i+0.5)/s; h]; end      % free nodes in top row (height=h)
if parabolic_top_chord, for i=0:s-1, Q(2,s+i)=[h-4*h*((i+0.5)/s-0.5)^2]; end, end
q=2*s-1; n=q+p;

% External forces on the free nodes of the truss (normalized)
U=zeros(2,q);  U(2,floor(s/2))=-1; % Tweak here if you want force applied elsewhere...

% Connectivity of the Warren truss with s sections
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

% Now, convert the D*X*CQ=U problem in (6.3a) to the standard A*x=u form in (6.3b)
[A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, just solve for the tension and compression in the members, and plot.
x=pinv(A)*b, error=norm(A*x-b) % This just implements (6.4b),  Assumes zero pretension!
if error>1e-8, disp('No equilibrium solution'), beep, end
RR_Plot_Truss(Q,P,C,U,x);  % Plot truss (red=positive=tension, blue=negative=compression)