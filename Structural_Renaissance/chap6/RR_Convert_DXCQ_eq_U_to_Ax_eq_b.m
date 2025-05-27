function [A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U,tension)
% Sets up to calculate the internal forces in a Truss defined by Q,P,C and loading U
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

N=[Q P]; [m,n]=size(C); [d,p]=size(P); [d,q]=size(Q);
CQ=C(:,1:q); CP=C(:,q+(1:p)); M=N*C';       % partition connectivity matrix, compute M
for i=1:m; D(:,i)=M(:,i)/norm(M(:,i)); end  % compute the direction vectors D(:,i)
x=sym('x',[1 m]); X=diag(x);                % set up symbolic vector x and diagonal X matrix

% set up (3a) in RR symbolically.  note that sys has d rows and q cols. 
sys=D*X*CQ-U;                                % we seek the (diagonal) X s.t. sys=0.

% Now, set up x1 to xm as symbolic variables, and convert (3a) to (3b) [i.e., A*x=b]
for i=1:m; exp="syms x"+i; eval(exp); end
% set up a symbolic equationsToMatrix command in SYS
SYS='equationsToMatrix([';

if nargin==5, for i=1:size(tension,2), SYS=SYS+"x"+tension(1,i)+"=="+tension(2,i)+","; end, end

for i=1:d, for j=1:q, SYS=SYS+"sys("+i+","+j+")==0";
  if i<d | j<q, SYS=SYS+","; end
end, end, SYS=SYS+"],[";
for i=1:m, SYS=SYS+"x"+i; if i<m, SYS=SYS+","; end, end, SYS=SYS+"])";
% finally, execute the symbolic equationsToMatrix command assembled above
[A,b]=eval(SYS);        
A=eval(A); b=eval(b); % convert A and b to a regular matrix and vector
disp("A has mhat="+d*q+" equations, nhat="+m+" unknowns, and rank="+rank(A))
