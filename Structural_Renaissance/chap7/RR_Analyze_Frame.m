function [A,b]=RR_Analyze_Frame(Structure,Loads)
% Sets up an Ax=b problem to calculate the internal forces in a 2D or 3D truss,
% as defined in Structure with given Loads.  A truss is defined as a pin-jointed
% structure with 
% INPUTS: Structure.Q        = free nodes (must be at least one free node in Q)
%         Structure.P        = pinned nodes (optional)
%         Structure.P_angles = normal vector of the pinned nodes (optional)
%         Structure.R        = roller nodes (optional)
%         Structure.R_angles = normal vector of the roller nodes (optional)
%         Structure.S        = fixed nodes (optional)
%         Structure.S_angles = normal vector of the fixed nodes (optional)
%         Structure.C        = connectivity matrix of structure
%         Loads.U            = force applied at each free node of the structure
%         Loads.tension      = tension (at the applied U) in the specified members
% OUPUTS: A and b in the corresponding Ax=b problem representing static equilibrium.
% NOTES:  Q(d,q), P(d,p), R(d,r) where d=2 or 3 is the dimension of the problem, and
%         {q,p,r} are the number of {free,pinned,roller} nodes, with n=q+p+r total nodes.
%         C(m,n), where m is the number of members, describes the structure's connectivity,
%             with a "0" in most entries, and a "1" in each {i,j} entry where member i
%             attaches to node j.
%         U(d,q) is the force applied at each of the q free nodes.
% IMPORTANT: in RR_Analyze_Truss, each row of C must have EXACTLY TWO "1" entries.
% RR_Analyze_Frame generalizes, allowing each row of C to have AT LEAST TWO "1" entries.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

% Sets up to calculate the internal forces in a 2D or 3D frame and specified loading
% INPUTS: Q=matrix with columns defining locations of the FREE nodes 
%         C=connectivity matrix, with (on each of the m rows defining the m members)
%           a 1 in each of the n columns that is connected to that member,
%           and a 0 in each of the other columns on that row, with nodes N=[Q P R S]
%         U=forces on all nodes
%              (with reaction forces resisting motion in ALL directions)
%         R=matrix with columns defining locations of the ROLLER support nodes, default=[]
%              (with reaction forces resisting motion in the VERTICAL (y) DIRECTION ONLY)
%         S=matrix with columns defining locations of the FIXED support nodes, default=[]
%              (with reaction forces resisting motion in ALL directions,
%               plus reaction moments resisting rotation in ALL directions)
%         M=moments on all m members, default=[]
% OUTPUTS: A,b = matrix, vector defining the Ax=b problem to be solved at equilibrium
% NOTE: use a separate fixed node for every member with an end fixed (they could be collocated)
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

if nargin<7, S=[]; if nargin<6, R=[]; if nargin<4, P=[]; end, end, end, N=[Q P R S];
if nargin<5, tension=[]; end
[m,n]=size(C); [ds,s]=size(S); [dr,r]=size(R); [dp,p]=size(P); [d,q]=size(Q);
if nargin<8, if d==2, M=zeros(1,m); else, M=zeros(3,m); end, end
if n~=q+p+r+s, error('wrong number of nodes in C'), end

% Set up symbolic matrix F, the nonzero elements of which are the forces applied
% in direction d on each member m at node n
F=sym('f',[d m n]); for i=1:m, for j=1:n, F(:,i,j)=F(:,i,j)*C(i,j); end, end
% Set up symbolic matrices for the (TBD) reaction forces at the pinned, roller, & fixed supports
VP=sym('vp%d_%d',[d,p]);
VR(2,:)=sym('vr',[1,r]); if r>0, VR(1,:)=0; if d==3, VR(3,:)=0; end, end
VS=sym('vs%d_%d',[d,s]); W=[U VP VR VS];
% Set up symbolic matrices for the (TBD) reaction moments at the fixed supports
if s>0, CT=C';
  if d==2, MS=sym('ms',[1,s]); else, MS=sym('ms',[3,s]); end
end

% Below is the guts of the calculation.  We will seek the {F,VP,VR,VS,MS} s.t. sys=0.
% We first set up to set the sum of the forces at each node n equal to zero
temp=reshape(sum(F,2),d,[])-W;
sys=reshape(temp,numel(temp),1);
% We then set up to set the sum of the forces on each member m equal to zero
temp=sum(F,3);
sys=[sys; reshape(temp,numel(temp),1)];
% We then set up to set the sum of the moments (QxF) on each member i=1..m equal to zero
% note: in 2D, (qxf)_z=q1*f2-q2*f1, in 3D, we just use cross(q,f)
for i=1:m, if d==2, t=0; else, t=[0; 0; 0]; end, for j=1:n,
  if d==2, t=t+N(1,j)*F(2,i,j)-N(2,j)*F(1,i,j);
  else,    t=t+cross(N(:,j),F(:,i,j));      end
end, Mm(:,i)=t+M(:,i); end
for i=1:s, [temp,j]=max(CT(q+p+r+i,:)); Mm(:,j)=Mm(:,j)+MS(:,i); end
sys=[sys; reshape(Mm,numel(Mm),1)];

[rows,cols]=size(tension); % Apply pretensioning
for i=1:cols
  [t1,j]=maxk(C(tension(1,i),:),2); xa=N(:,j(1));  xb=N(:,j(2));
  sys=[sys; (tension(2,i)*(xa-xb)/norm(xa-xb) - F(:,tension(1,i),j(1)))];
end
eqns=length(sys);

% Now, set up the nonzero fk_i_j, vpk_i, vri, vsi, and ms as symbolic variables,
% and convert SYS to A*x=b form
for i=1:m, for j=1:n
  if C(i,j)==1, for k=1:d; exp="syms f"+k+"_"+i+"_"+j; eval(exp); end, end
end, end
for i=1:p, for k=1:d, exp="syms vp"+k+"_"+i; eval(exp); end, end
for i=1:r,            exp="syms vr"+i;       eval(exp); end 
for i=1:s, for k=1:d, exp="syms vs"+k+"_"+i; eval(exp); end, end
for i=1:s, if d==2,   exp="syms ms"+i;       eval(exp);
     else, for k=1:d, exp="syms ms"+k+"_"+i; eval(exp); end
end, end

% uncomment below for some interesting verbose output
% sys, disp('The solver sets up the eqns listed above, with the variables as shown,')
%      disp('in the form Ax=b, then looks for a solution such the sys=0.'), disp(' ')

% set up a symbolic equationsToMatrix command in SYS
SYS='equationsToMatrix(['; for i=1:eqns, SYS=SYS+"sys("+i+")==0";
       if i<eqns, SYS=SYS+","; end, end, SYS=SYS+"],[";
flag=true; for i=1:m, for j=1:n, if C(i,j)==1,
  for k=1:d; 
    if flag, SYS=SYS+"f"+k+"_"+i+"_"+j; flag=false;
    else,    SYS=SYS+",f"+k+"_"+i+"_"+j; end
  end
end, end, end
for i=1:p, for k=1:d, SYS=SYS+",vp"+k+"_"+i; end, end
for i=1:r,            SYS=SYS+",vr"+i;       end
for i=1:s, for k=1:d, SYS=SYS+",vs"+k+"_"+i; end, end
for i=1:s, if d==2,         SYS=SYS+",ms"+i;       
           else, for k=1:d, SYS=SYS+",ms"+k+"_"+i; end, end, end
SYS=SYS+"])";

% finally, execute the symbolic equationsToMatrix command assembled above
[A,b]=eval(SYS);
A=eval(A); b=eval(b); % convert A and b to a regular matrix and vector
[c1,c2]=size(A);
disp("A has mhat="+c1+" equations, nhat="+c2+" unknowns, and rank="+rank(A))
% function RR_Convert_Frame_to_Ax_eq_b
