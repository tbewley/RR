function [A,b]=RR_Convert_Frame_to_Ax_eq_b(Q,P,R,C,U,M); 
% Sets up to calculate the internal forces in a Frame defined by Q,P,C and loading U

% First, compute forces
N=[Q P]; [m,n]=size(C); [d,p]=size(P); [d,r]=size(R); [d,q]=size(Q);
% Set up symbolic matrix F, the nonzero elements of which are the forces applied
% in direction d on each member m at node n
F=sym('f',[d m n]); for i=1:m, for j=1:n, F(:,i,j)=F(:,i,j)*C(i,j); end, end
% Set up symbolic matrix V for the (TBD) reaction forces at the pinned & fixed supports
V=sym('v',[d,p+r]);

W=[U V];

% Below is the guts of the calculation.  We will seek the F and V s.t. sys=0.
% We first set up to set the sum of the forces at each node n equal to zero
temp=reshape(sum(F,2),2,[])+W;
sys=reshape(temp,numel(temp),1);
% We then set up to set the sum of the forces on each member m equal to zero
temp=sum(F,3);
sys=[sys; reshape(temp,numel(temp),1)];
% We then set up to set the sum of the moments (QxF) on each member i=1..m equal to zero
% note: (qxf)_z=q1*f2-q2*f1;
for i=1:m, t=0; for j=1:n, t=t+N(1,j)*F(2,i,j)-N(2,j)*F(1,i,j); end, Mm(i)=t+M(i); end
sys=[sys; reshape(Mm,numel(Mm),1)];

% Now, set up the nonzero fk_i_j (for k=1:2, i=1:m, j=1:n) as symbolic variables,
% and the vk_i (for k=1:2, i=1:p+r) as symbolic variables, and convert SYS to A*x=b form
for i=1:m, for j=1:n,
  if C(i,j)==1, for k=1:2; exp="syms f"+k+"_"+i+"_"+j; eval(exp); end, end,
end, end
for i=1:p+r, for k=1:2; exp="syms v"+k+"_"+i; eval(exp); end, end,
% set up a symbolic equationsToMatrix command in SYS
s=2*n+2*m+m;

SYS='equationsToMatrix(['; for i=1:s, SYS=SYS+"sys("+i+")==0";
       if i<s, SYS=SYS+","; end, end, SYS=SYS+"],[";
for i=1:m, for j=1:n, if C(i,j)==1,
  for k=1:2; SYS=SYS+"f"+k+"_"+i+"_"+j; SYS=SYS+","; end
end, end, end
for i=1:p+r, for k=1:d,
    SYS=SYS+"v"+k+"_"+i; if i<p+r|k<d, SYS=SYS+","; end
end, end   
SYS=SYS+"])";
% finally, execute the symbolic equationsToMatrix command assembled above
[A,b]=eval(SYS);        
A=eval(A); b=eval(b); % convert A and b to a regular matrix and vector
[c1,c2]=size(A);
disp("A has mhat="+c1+" equations, nhat="+c2+" unknowns, and rank="+rank(A))
end % function RR_Convert_Frame_to_Ax_eq_b
