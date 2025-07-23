function [A,b]=RR_Analyze_Truss(Structure,Loads)
% Sets up an Ax=b problem to calculate the internal forces in a 2D or 3D truss,
% as defined in Structure with given Loads.  A truss is defined as a pin-jointed
% structure with 
% INPUTS: Structure.Q        = free nodes (must be at least one free node in Q)
%         Structure.P        = pinned nodes (optional)
%         Structure.P_angles = normal vector of the pinned nodes (optional)
%         Structure.R        = roller nodes (optional)
%         Structure.R_angles = normal vector of the roller nodes (optional)
%         Structure.C        = connectivity matrix of structure
%         Loads.U            = force applied at each free node of the structure
%         Loads.tension      = tension (at the applied U) in the specified members
% OUPUTS: A and b in the corresponding Ax=b problem representing static equilibrium.
% NOTES:  Q(d,q), P(d,p), R(d,r) where d=2 or 3 is the dimension of the problem, and
%            {q,p,r} are the number of {free,pinned,roller} nodes, with n=q+p+r total nodes.
%         C(m,n), where m is the number of members, describes the structure's connectivity,
%            with a "0" in most entries, and a "1" in each {i,j} entry where member i
%            attaches to node j.
%         The unknowns in the problem, the m values of the vector x, are just the
%            tensions (if positive) or compressions (if negative) of the m members.
%         U(d,q) is the force applied at each of the q free nodes.
% IMPORTANT: in RR_Analyze_Truss, each row of C must have EXACTLY TWO "1" entries.
% RR_Analyze_Frame generalizes, allowing each row of C to have AT LEAST TWO "1" entries.
% Internally, the gonculator ...
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

Q=Structure.Q;

if isfield(Structure,'P');        P=Structure.P; else, P=[]; end
if isfield(Structure,'P_angles'); P_angles=Structure.P; else, P=[]; end

if isfield(Structure,'R'); R=Structure.R; else, R=[]; end
if isfield(Structure,'R_angles'); R_angles=Structure.R; else, R=[]; end
  
C=Structure.C;  % Every structure must have a connectivity matrix C.

N=[Q P R]; [d,q]=size(Q); [t,p]=size(P); [t,r]=size(R);  [m,n]=size(C); 
if n~=q+p+r, error('C has wrong number of columns'), end

U=Loads.U; if isfield(Loads,'tension'); tension=Loads.tension; else, tension=[]; end

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
