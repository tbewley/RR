% script RR_Truss_Pratt.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=4;     % number of horizontal sections in the truss
h=.2;   % height of the truss
l=0.4;
parabolic_top_chord=true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear Q P C U
% Locations of the fixed nodes of the truss (normalized units)
P=[0 1; 0 0]; p=2;  

% Locations of the free nodes of the Pratt truss (for arbitrary s and h)
for i=1:s-1, Q(:,i)    =[i/s; 0]; end      % free nodes in bottom row
for i=1:s-1, Q(:,s-1+i)=[i/s; h]; end      % free nodes in top row
if parabolic_top_chord, for i=1:s-1, Q(2,s-1+i)=[h-4*h*(i/s-0.5)^2]; end, end
q=2*s-2; n=q+p;

% External forces on the free nodes of the truss (normalized)
s1=floor(l*s); s2=ceil(l*s);
U=zeros(2,q);
if s1==s2, U(2,s1)=-1; else
  if s1>0, U(2,s1)=s*l-s2; end
  if s2<s, U(2,s2)=s1-s*l; end
end
U

% Connectivity of the Pratt truss
% Note: each column of C^T has exactly one entry equal to +1, and one entry equal to -1.
m=4*s-3; C=zeros(m,q+p);
C(1,n-1)=-1;   C(1,1)=1; j=1;                               % bottom row to left fixed node
for i=1:s-2,   C(j+i,i)=-1; C(j+i,i+1)=1;  end, j=j+s-2;    % bottom row
C(j+1,s-1)=-1; C(j+1,n)=1; j=j+1;                           % bottom row to right fixed node
for i=1:s-2,   C(j+i,s-1+i)=-1; C(j+i,s+i)=1; end, j=j+s-2; % top row
C(j+1,n-1)=-1; C(j+1,s)=1; j=j+1;                           % left diagonal to fixed node
for i=1:s-1,   C(j+i,i)=-1; C(j+i,s-1+i)=1; end, j=j+s-1;   % internal verticals
num=ceil((s-2)/2);
for i=1:num, C(j+i,i+1)=-1; C(j+i,s+i-1)=1;    end, j=j+num;  % up/left  diagonals
for i=1:num, C(j+i,s-i-1)=-1; C(j+i,2*s-i-1)=1;  end, j=j+num;  % up/right diagonals
C(j+1,n-2)=-1; C(j+1,n)=1; j=j+1;                           % right diagonal to fixed node

% Now, convert the D*X*CQ=U problem in (3a) to the standard A*x=u form in (3b)
[A,u]=RR_Convert_DXCQ_eq_U_to_Ax_eq_u(Q,P,C,U); 
% Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
x=pinv(A)*u;
% Finally, plot the truss (blue = tension, red = compression)
RR_Plot_Truss(Q,P,C,U,x);
