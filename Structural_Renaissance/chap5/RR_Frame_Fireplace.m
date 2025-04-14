% script RR_Frame_Fireplace.m
% NOTE: this routine does not yet work...  Someone buy me a beer...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear Q P C U V M
% Locations of the fixed nodes of the truss (normalized units) 
P=[ 6  6;  % Columns denote (x,y) locations of each of the p=2 fixed nodes
    1 -1];
Q=[-2 -2  0  2  2  4  6  6;    % Locations of each of the n=6 free nodes
    1 -1  0  1 -1  0  1 -1];
U=[ 0  0  0  0  0  0  0  0;    % External forces on the n free nodes
   -1  1  0  0  0  0  0  0];  
   % m=4 members (columns) 
CT=[ 1 0 0 0;  % q_1   Connectivity of a pin-jointed frame
     0 1 0 0;  % q_2   Note: members may connect 3 or more nodal points
     1 1 0 0;  % q_3   (and, thus, may bear internal bending loads!), and 
     0 1 1 0;  % q_4   each node may have 3 or more members attached in
     1 0 0 1;  % q_5   addition to having a applied external load.
     0 0 1 1;  % q_6 
     0 0 0 1;  % p_1
     0 0 1 0]; % p_2
C=CT';

% Now, convert the linear eqns for the interior forces in the frame into
% standard A*x=u form
% [A,b]=RR_Frame_to_Ax_eq_b(Q,P,C,U); 
% Then, solve for the interior forces
% x=pinv(A)*b, error=norm(A*x-b)
% if error>1e-8, disp('No equilibrium solution'), beep, end

% Finally, plot the frame.
RR_Plot_Frame(Q,P,C,U)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A,b]=RR_Frame_to_Ax_eq_b(Q,P,C,U); 
% Sets up to calculate the internal forces in a Frame defined by Q,P,C and loading U
% NOTE: this routine does not yet work.

N=[Q P]; [m,n]=size(C); [d,p]=size(P); [d,q]=size(Q);
CQ=C(:,1:q); CP=C(:,q+(1:p)); M=N*C';       % partition connectivity matrix, compute M
for i=1:m; D(:,i)=M(:,i)/norm(M(:,i)); end  % compute the direction vectors D(:,i)
x=sym('x',[1 m]); X=diag(x);                % set up a symbolic and diagonal X matrix
% set up (3a) in RR symbolically.  note that sys has d rows and q cols. 
sys=D*X*CQ-U;                               % we seek the (diagonal) X s.t. sys=0.

% Now, set up x1 to xm as symbolic variables, and convert (3a) to (3b) [i.e., A*x=b]
for i=1:m; exp="syms x"+i; eval(exp); end
% set up a symbolic equationsToMatrix command in SYS
SYS='equationsToMatrix(['; for i=1:d, for j=1:q, SYS=SYS+"sys("+i+","+j+")==0";
       if i<d | j<q, SYS=SYS+","; end, end, end, SYS=SYS+"],[";
for i=1:m, SYS=SYS+"x"+i; if i<m, SYS=SYS+","; end, end, SYS=SYS+"])";
% finally, execute the symbolic equationsToMatrix command assembled above
[A,b]=eval(SYS);        
A=eval(A); b=eval(b); % convert A and b to a regular matrix and vector
disp("A has mhat="+d*q+" equations, nhat="+m+" unknowns, and rank="+rank(A))
end % function RR_Frame_to_Ax_eq_b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RR_Plot_Frame(Q,P,C,U);
% NOTE: this routine does not yet work fully.
figure(1), clf, hold on, axis off, axis equal
N=[Q P]; [m,n]=size(C); [d,p]=size(P); [d,q]=size(Q);
if d==2
  [row,col] = find(C'); % This finds the row and col of nonzero entries of C'
  member=0;
  for i=1:length(row)
    switch col(i)
      case 1, sy='b-';
      case 2, sy='g-';
      case 3, sy='r-';
      case 4, sy='c-';
      case 5, sy='m-';
      otherwise, sy='k-'; 
    end
    newx=N(1,row(i)); newy=N(2,row(i));
    if col(i)>member, member=member+1;
    else, plot([lastx newx],[lasty newy],sy,"LineWidth",6); end
    lastx=newx; lasty=newy;
  end
  flip=[1 -1];
  fac=1; for i=1:p
    fill(P(1,i)+fac*[-.2 0 .2],P(2,i)+flip(i)*fac*[-.3 0 -.3],'k-')
  end
  fac=1; h=-1; for i=1:q
    if h>0
      f=quiver(N(1,i),N(2,i),fac*U(1,i),fac*U(2,i),0);
    else
      f=quiver(N(1,i)-fac*U(1,i),N(2,i)-fac*U(2,i),fac*U(1,i),fac*U(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','m');
  end
else % d=3 case
  % TODO.
end
end % function RR_Plot_Frame