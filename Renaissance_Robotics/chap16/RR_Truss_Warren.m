% script RR_Truss_Warren.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=4;   % number of horizontal sections in the truss
h=1/s; % height of the truss
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% First, define the fixed nodes
P=[0 1; 0 0]; p=2;

% Next define the Warren truss (for arbitrary s and h)
for i=1:s-1, Q(:,i)=[i/s; 0]; end              % free nodes in bottom row
for i=0:s-1, Q(:,s+i)=[(i+0.5)/s; h]; end      % free nodes in top row
m=4*s-1; q=2*s-1; n=q+p; C=zeros(m,q+p); % m = total number of members

C(1,n-1)=-1; C(1,1)=1; j=1;                               % bottom row to left fixed node
for i=1:s-2, C(j+i,i)=-1; C(j+i,i+1)=1;  end, j=j+s-2;    % bottom row
C(j+1,s-1)=-1; C(j+1,n)=1; j=j+1;                         % bottom row to right fixed node
for i=1:s-1, C(j+i,s-1+i)=-1; C(j+i,s+i)=1; end, j=j+s-1; % top row
C(j+1,n-1)=-1; C(j+1,s)=1; j=j+1;                         % left diagonal to fixed node
for i=1:s-1, C(j+2*i-1,s+i-1)=-1; C(j+2*i-1,i)=1;         % internal diagonals
             C(j+2*i,i)=1;        C(j+2*i,s+i)=-1; end, j=j+2*s-2;  
C(j+1,n-2)=-1; C(j+1,n)=1; j=j+1;                         % right diagonal to fixed node

% Now set up some external forces on the truss
U=zeros(2,q);  U(2,s/2)=-1; U

% Now set up to calculate the internal forces in the truss
N=[Q P]; [m,n]=size(C); [d,q]=size(Q); [d,p]=size(P);
CQ=C(:,1:q); CP=C(:,q+(1:p)); M=N*C';       % partition connectivity matrix, compute M
for i=1:m; D(:,i)=M(:,i)/norm(M(:,i)); end  % compute the direction vectors D(:,i)
x=sym('x',[1 m]); X=diag(x);                % set up a symbolic, diagonal, X matrix
% set up (3a) in RR symbolically.  note that sys has d rows and q cols. 
sys=D*X*CQ-U;                               % we seek the (diagonal) X s.t. sys=0.

% Now, set up x1 to xm as symbolic variables, and convert (3a) to (3b) [i.e., Ase*x=u]
for i=1:m; exp="syms x"+i; eval(exp); end
% set up a symbolic equationsToMatrix command in SYS
SYS='equationsToMatrix(['; for i=1:d, for j=1:q, SYS=SYS+"sys("+i+","+j+")==0";
       if i<d | j<q, SYS=SYS+","; end, end, end, SYS=SYS+"],[";
for i=1:m, SYS=SYS+"x"+i; if i<m, SYS=SYS+","; end, end, SYS=SYS+"])";
% finally, execute the symbolic equationsToMatrix command assembled above
[Ase,u]=eval(SYS);        
Ase=eval(Ase); u=eval(u); % convert Ase and u to a regular matrix and vector
mhat=d*q; nhat=m;         % note that Ase=Ase_(mhat x nhat)
disp("Ase has mhat="+mhat+" equations, nhat="+nhat+" unknowns, and rank="+rank(Ase))

% Finally, actually solve for the internal forces in the truss
x=pinv(Ase)*u

% Now plot the truss
N=[Q P]; [m,n]=size(C); [d,q]=size(Q); [d,p]=size(P);
close all; figure(1);
axis equal, axis tight, axis off, axis([-0.05 1.05 -0.2 h+.2]), hold on
if h<0; fac=0; else, fac=1; end
fill(P(1,1)+[-.035     0 .035*fac],P(2,2)+[-.05 0 -.05],'k-')
fill(P(1,2)+[-.035*fac 0 .035    ],P(2,2)+[-.05 0 -.05],'k-')
N=[Q P]; 
for i=1:m
  [i1,d1]=max(C(i,:)); [i2,d2]=min(C(i,:)); 
  if x(i)<-0.01, sy='r-'; elseif x(i)>0.01, sy='b-'; else, sy='k--'; end
  plot([N(1,d1) N(1,d2)],[N(2,d1) N(2,d2)],sy,"LineWidth",3)
end
disp('In members: blue=tension, red=compression, black dashed=no force')
fac=0.1; for i=1:q
  plot([N(1,i) N(1,i)+fac*U(1,i)],[N(2,i) N(2,i)+fac*U(2,i)],'k-',"LineWidth",3)
end