function [A,b]=RR_Analyze_Truss(Structure,Loads ,U,tension); 
% Sets up an Ax=b problem to calculate the internal forces in a 2D or 3D truss,
% as defined in Structure with given Loads.
% INPUTS: Structure.Q = free nodes
%
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

Q=Structure.Q;  % Every structure must have at least one free node in Q.
if isfield(Structure,'P'); P=Structure.P; else, P=[]; end
if isfield(Structure,'R'); R=Structure.R; else, R=[]; end
C=Structure.C;  % Every structure must have a connectivity matrix C.

N=[Q P]; [t,p]=size(P); [t,r]=size(R); [d,q]=size(Q);

[m,n]=size(C); 

U=Loads.U;  % Every structure must have at least one free node in Q.
if isfield(Loads,'tension'); tension=Loads.tension; else, tension=[]; end


N=[Q P]; [m,n]=size(C); [dp,p]=size(P); [dr,r]=size(R); [d,q]=size(Q);
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
