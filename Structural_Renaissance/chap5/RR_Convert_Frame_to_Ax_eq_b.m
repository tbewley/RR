function [A,b]=RR_Convert_Frame_to_Ax_eq_b_new(Q,C,U,P,R,S,M); 
% Sets up to calculate the internal forces in a 2D or 3D frame and specified loading
% INPUTS: Q=matrix with columns defining locations of the FREE nodes
%         C=connectivity matrix, with (on each of the m rows defining the m members)
%           a 1 in each of the n columns that is connected to that member,
%           and a 0 in each of the other columns on that row
%         U=forces on all nodes, N=[Q P R S]
%         P=matrix with columns defining locations of the PINNED support nodes, default=[]
%              (with reaction forces resisting motion in ALL directions)
%         R=matrix with columns defining locations of the ROLLER support nodes, default=[]
%              (with reaction forces resisting motion in the VERTICAL (y) DIRECTION ONLY)
%         S=matrix with columns defining locations of the FIXED support nodes, default=[]
%              (with reaction forces resisting motion in ALL directions,
%               plus reaction moments resisting rotation in ALL directions)
%         M=moments on all m members, default=[]
% OUTPUTS: A,b = matrix, vector defining the Ax=b problem to be solved at equilibrium

if nargin<6, S=[]; if nargin<5, R=[]; if nargin<4, P=[]; end, end, end, N=[Q P R S];
[m,n]=size(C); [ds,s]=size(S); [dr,r]=size(R); [dp,p]=size(P); [d,q]=size(Q);
if nargin<7, if d==2, M=zeros(1,m); else, M=zeros(3,m); end, end
if n~=q+p+r+s, error('wrong number of nodes in C'), end

% Set up symbolic matrix F, the nonzero elements of which are the forces applied
% in direction d on each member m at node n
F=sym('f',[d m n]); for i=1:m, for j=1:n, F(:,i,j)=F(:,i,j)*C(i,j); end, end
% Set up symbolic matrices for the (TBD) reaction forces at the pinned, roller, & fixed supports
VP=sym('vp',[d,p]); VR=sym('vr',[d,r]); VR(1,:)=0; if d==3, VR(3,:)=0; end
VS=sym('vp',[d,s]); W=[U VP VR VS];
% Set up symbolic matrices for the (TBD) reaction moments at the fixed supports
if s>0; if d==2, MS=sym('ms',[1,s]); M=M+[zeros(d,q+p+r) MS];
        else,    MS=sym('ms',[3,s]); M=M+[zeros(d,q+p+r) MS]; end, end

% Below is the guts of the calculation.  We will seek the {F,VP,VR,VS,MS} s.t. sys=0.
% We first set up to set the sum of the forces at each node n equal to zero
temp=reshape(sum(F,2),2,[])-W;
sys=reshape(temp,numel(temp),1);
% We then set up to set the sum of the forces on each member m equal to zero
temp=sum(F,3);
sys=[sys; reshape(temp,numel(temp),1)];
% We then set up to set the sum of the moments (QxF) on each member i=1..m equal to zero
% note: in 2D, (qxf)_z=q1*f2-q2*f1, in 3D, just use cross(q,f)
for i=1:m, if d==2, t=0; else, t=[0; 0; 0]; end, for j=1:n,
  if d==2, t=t+N(1,j)*F(2,i,j)-N(2,j)*F(1,i,j);
  else,    t=t+cross(N(:,j),F(:,i,j));          end
end, Mm(:,i)=t+M(:,i); end
sys=[sys; reshape(Mm,numel(Mm),1)];
eqns=length(sys);

% Now, set up the nonzero fk_i_j, vpk_i, vri, vsi, and ms as symbolic variables,
% and convert SYS to A*x=b form
for i=1:m, for j=1:n
  if C(i,j)==1, for k=1:d; exp="syms f"+k+"_"+i+"_"+j; eval(exp); end, end
end, end
for i=1:p, for k=1:d, exp="syms vp"+k+"_"+i; eval(exp); end, end
for i=1:r,            exp="syms vr"+i;       eval(exp); end 
for i=1:s, for k=1:d, exp="syms vs"+k+"_"+i; eval(exp); end, end
for i=1:s, if d==2,         exp="syms ms"+i;       eval(exp);
           else, for k=1:d, exp="syms ms"+k+"_"+i; eval(exp); end
end, end

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
