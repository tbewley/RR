function [A,b,S,L]=RR_Structure_Analyze(S,L)
% This one code is used throughout the Structural Renaissance (SR) text.  In short:
% it sets up an Ax=b problem to calculate the internal forces in a 2D pin-jointed or 3D ball-jointed
% structure (truss, tensegrity, or frame), as defined by a structure S with given loads L, where:
% INPUTS: S.Q     = FREE nodes (required, there must be at least one free node in Q)
%         S.P     = PINNED nodes (optional)
%         S.P_vec = normal vector of the pinned nodes (optional)
%         S.R     = ROLLER nodes (optional)
%         S.R_vec = normal vector of the roller nodes (optional)
%         S.S     = FIXED nodes (optional)
%         S.S_vec = normal vector of the fixed nodes (optional)
%         S.C     = matrix of 0's and 1's defining the connectivity of the structure
%         S.mu    = mass per unit length of beams, assumed linear between nodes (optional)
%         S.g     = -9.81 m/s^2 (if using SI) or -32.2 ft/s^2 (if using feet - not recommended!)
%         L.U     = force applied at all of the q free nodes of the structure (required)
%         L.M     = moments applied to all of the m members of the structure (optional)
%         L.tension = preset tension in specified members (optional)
% OUPUTS: A and b in the corresponding Ax=b problem representing static equilibrium.
%         (The nullspace of A defines in what manner the structure is pretensionable.)
%         S,L are modified/augmented to a standard form for plotting, with 2-force members listed first.     
% TEST:   Test with the several example codes discussed throughout the SR text.
% NOTES:  dimensions: S.Q(S.d,S.q), S.P(S.d,S.p), S.R(S.d,S.r), S.S(S.d,S.s) where S.d=2 or 3 is the
%             problem dimension, and {S.q,S.p,S.r,S.s} are the number of {free,pinned,roller,fixed}
%             nodes in N=[S.Q S.P S.R S.S], with S.n=S.q+S.p+S.r+S.s total nodes.
%         C(m,n), where m is the number of members, describes the structure's connectivity,
%             with a "0" in most entries, and a "1" in each {i,j} entry or row i, where member i
%             attaches to node j.  Exactly 2 nonzero entries in a row denotes a 2-force member.
%         A structure with 2-force members ONLY is called a TRUSS; all others are called FRAMES.
%         A truss structure with pretensioning capability over the entire structure, so that many
%             members may be kept under tension for a wide range of applied forces, is called a
%             TENSEGRITY structure.
%         U(d,q) is the force applied at each of the q free nodes.
%         L(member,tension) prescribes the tension in one or more of the two-force members.
%         This code adjusts C to put a +1 and -1 in each row defining a two-force member.
%         Moments have 1 component (in z) for 2D problems, and 3 components for 3D problems.
%         At the S.q free nodes,   member   forces  resist node motion in all directions.
%         At the S.p pinned nodes, reaction forces  resist node motion in all directions.
%         At the S.r roller nodes, reaction forces  resist node motion in the R_vec direction only.
%         At the S.s fixed nodes,  reaction forces  resist node motion in all directions, AND
%                                  reaction moments resist member rotation in all directions.
%         Define a separate fixed node for every member with an end fixed (they could be collocated).
%  if global RR_VERBOSE =0 (or missing) runs silent, =1 shows minor stuff, =2 shows debug stuff
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

global RR_VERBOSE

% CHECK INPUTS
if ~isfield(S,'P'),  S.P=[]; end,         S.p=size(S.P,2); 
if ~isfield(S,'R'),  S.R=[]; end,         S.r=size(S.R,2); 
if ~isfield(S,'S'),  S.S=[]; end,         S.s=size(S.S,2); 
N=[S.Q S.P S.R S.S]; [S.m,S.n]=size(S.C); [S.d,S.q]=size(S.Q);

if S.n~=S.q+S.p+S.r+S.s, error('C has the wrong number of nodes'), end
if ~isfield(S,'P_vec')                                   % Default orientations:
  if S.d==2, for i=1:S.p, S.P_vec(:,i)=[0;1];   end      %   S.d=2: y is up
  else,      for i=1:S.p, S.P_vec(:,i)=[0;0;1]; end, end %   S.d=3: z is up
end
if ~isfield(S,'R_vec')
  if S.d==2, for i=1:S.r, S.R_vec(:,i)=[0;1];   end 
  else,      for i=1:S.r, S.R_vec(:,i)=[0;0;1]; end, end
end
if ~isfield(S,'S_vec')
  if S.d==2, for i=1:S.s, S.S_vec(:,i)=[0;1];   end 
  else,      for i=1:S.s, S.S_vec(:,i)=[0;0;1]; end, end 
end                 % note: t is a temp variable
if ~isfield(S,'mu'), S.mu=zeros(S.m,S.n); end
if ~isfield(S,'g'),  S.g=-9.81; end
if ~isfield(L,'U'), if S.d==2, L.U=zeros(2,S.q); else, L.U=zeros(3,S.q);  end
else,      if size(L.U,2)~=S.q, error('U has the wrong number of nodes'), end, end
if ~isfield(L,'M'), if S.d==2, L.M=zeros(1,S.m); else, L.M=zeros(3,S.m);  end, end
if ~isfield(L,'tension'), L.tension=[]; L.t=0;   else, L.t=size(L.tension,1);  end

% MOVE TWO-FORCE MEMBERS TO TOP OF C, with one positive and one negative entry per row
% (ala Skelton), making certain to move L.M and L.tension with S.C as members are rearranged.
S.C=abs(S.C);               % first, strip off any stray negative signs in C
S.tfm=0; S.mfm=0; t1=sum(boolean(S.C),2);
S.Ctfm=[]; L.tensiontfm=[]; % initialize scratch matrices to for the two-force   members
S.Cmfm=[]; L.Mmfm=[];       % initialize scratch matrices to for the multi-force members
for i=1:S.m
    if t1(i)<2, fprintf('warning: member %d has %d connections?\n',i,t1(i)), pause, end
    if t1(i)==2 & norm(L.M(:,i))==0 & norm(S.mu(:,i))==0
      j=find(S.C(i,:),2);   % check to see if there is a fixed support on either end
      if j(1)<=S.q+S.p+S.r & j(2)<=S.q+S.p+S.r, tfm=true; else, tfm=false; end
    else 
      tfm=false;
    end
    if L.t>0, k=find(L.tension(:,1)==i); else, k=0; end
    if tfm
      S.tfm=S.tfm+1; j=find(S.C(i,:),1); S.C(i,j)=-1;
      S.Ctfm(S.tfm,:)=S.C(i,:); 
      if k>0, L.tensiontfm=[L.tensiontfm; [S.tfm, L.tension(k,2)]]; end
    else
      S.mfm=S.mfm+1;
      % We now sort the nodes of each MFM from C=1 (start) to C=last (end)
      %   (we can later use boolean(C) to convert any C>0 to C=1)
      i_nodes=find(S.C(i,:));                            % look just at the nonzero nodes in row i of S.C
                 dx=max(N(1,i_nodes))-min(N(1,i_nodes))  % compute extent of this beam 
                 dy=max(N(2,i_nodes))-min(N(2,i_nodes))  % in the x, y, and z directions
      if S.d==3, dz=max(N(3,i_nodes))-min(N(3,i_nodes)), else, dz=0; end
      if dx>0.9*dy & dx>0.9*dz, [B,i_sorted]= sort(N(1,i_nodes));       % sort by x
      elseif dy>0.9*dz,         [B,i_sorted]= sort(N(2,i_nodes));       % sort by y
      else,                     [B,i_sorted]= sort(N(3,i_nodes)); end   % sort by z
      i_nodes_sorted=i_nodes(i_sorted);
      S.Cmfm(S.mfm,:)=zeros(1,S.n); for t=1:length(i_nodes), S.Cmfm(S.mfm,i_nodes_sorted(t))=t; end
      S.C(i,:)=S.Cmfm(S.mfm,:);
      L.Mmfm(:,S.mfm)=L.M(:,i);
      if k>0, error('Member %d is a multiforce member; pretensioning not allowed on it!',i), end
    end 
end, S.C=[S.Ctfm; S.Cmfm]; S.C
if RR_VERBOSE>0,
  if S.mfm==0, fprintf('All %d members are two-force members; structure S is a truss\n',S.tfm)
  else, fprintf('Structure S is a frame, with %d two-force member(s) and %d multi-force member(s)\n',S.tfm,S.mfm), end
end

% SET UP SYMBOLIC MATRICES FOR THE (TBD) REACTION FORCES AND MOMENTS at the pinned, roller, & fixed supports
if S.p>0, VP=sym('vp%d_%d',[S.d,S.p]);                                                                   else, VP=[]; end
if S.r>0, temp=sym('vr',[1,S.r]);  for i=1:S.r, VR(:,i)=temp(i)*S.R_vec(:,i); end,                       else, VR=[]; end 
if S.s>0, VS=sym('vs%d_%d',[S.d,S.s]); if S.d==2, MS=sym('ms',[1,S.s]); else, MS=sym('ms%d_%d',[3,S.s]); end, else, VS=[]; end

% SET UP UNKNOWNS X CORRESPONDING TO TENSION/COMPRESSION (+/-) IN THE TWO-FORCE MEMBERS (TFMs), ala Skelton
if S.tfm>0,
  M=N*S.Ctfm';                                   % compute matrix of TFM "member" vectors M(:,i)
  for i=1:S.tfm; D(:,i)=M(:,i)/norm(M(:,i)); end % compute the matrix of "direction" vectors D(:,i)
  x=sym('x',[1 S.tfm]); X=diag(x);               % set up symbolic vector x (tensions) and diagonal X matrix
end

% SET UP UNKNOWNS F CORRESPONDING TO THE FORCES APPLIED ON THE MULTI-FORCE MEMBERS (MFMs),
% in the direction d on each of the S.mfm members at each of the S.n nodes (zeros in elements implied by C)
F=sym('f%d_%d_%d',[S.d S.mfm S.n]);
for i=1:S.mfm, for j=1:S.n, F(:,i,j)=F(:,i,j)*boolean(S.Cmfm(i,j)); end, end

% BELOW IS THE GUTS OF THE CALCULATION.  Will seek the forces {X,F} and reactions {VP,VR,VS,MS} s.t. sys=0.

% We first set up to set the SUM OF FORCES AT EACH NODE, due to both the TFMs and MFMs, equal to zero
% note: the sum below adds all of the MFM forces acting on each of the nodes, then reshapes appropriately
%    from TFMs (ala Skelton)                 from MFMs     from reactions
if S.mfm>1;  G=sum(F,2);  else,  G=F;  end

if S.mfm==0,      temp=[D*X*S.Ctfm]                  -[L.U VP VR VS];
elseif S.tfm==0,  temp=             reshape(G,S.d,[])-[L.U VP VR VS];
else,             temp=[D*X*S.Ctfm]+reshape(G,S.d,[])-[L.U VP VR VS]; end

sys=reshape(temp,numel(temp),1);

% We then set up to set the SUM OF FORCES (POINTWISE + DISTRIBUTED) ON EACH MFM MEMBER equal to zero
temp=sum(F,3)
sys=[sys; reshape(temp,numel(temp),1)];
for i=1:S.mfm;
  for j=1:sum(boolean(S.Cmfm(i,:)),2)-1;    % compute DISTRIBUTED WEIGHT of each MFM segment
    [t,j1]=find(S.Cmfm(i,:)==j); [t,j2]=find(S.Cmfm(i,:)==j+1);
    segL(i,j)=norm(N(:,j2)-N(:,j1));
    segW(i,j)=S.g*segL(i,j)*(S.mu(i,j1)+S.mu(i,j2))/2;
    sys(end-S.mfm*S.d+2*i)=sys(end-S.mfm*S.d+2*i)+segW(i,j);       % account for this weight
  end
end

% We then set up to set the SUM OF MOMENTS ON EACH MFM MEMBER i equal to zero
% note: In 2D, (q x f)_z=q1*f2-q2*f1. In 3D, we just use cross(q,f).
for i=1:S.mfm, if S.d==2, t=0; else, t=[0; 0; 0]; end
  for j=1:S.n  % Pick up here contributions from all MFMs
    if S.d==2, t=t+N(1,j)*F(2,i,j)-N(2,j)*F(1,i,j);
    else,      t=t+cross(N(:,j),F(:,i,j));          end
  end
  Mm(:,i)=t+L.Mmfm(:,i);
  for j=1:sum(boolean(S.Cmfm(i,:)),2)-1 % compute DISTRIBUTED MOMENTS of each MFM segment
    [t,j1]=find(S.Cmfm(i,:)==j); [t,j2]=find(S.Cmfm(i,:)==j+1);
    mu1=S.mu(i,j1); mu2=S.mu(i,j2); Len=norm(N(:,j2)-N(:,j1));
    if S.d==2,   % account for this moment (see Example 4.2b, and footnote 5)
      s1=N(1,j1); s2=N(1,j2); 
      Mm(1,i)=Mm(1,i)+S.g*Len*(mu1*(2*s1+s2)+mu2*(s1+2*s2))/6;
    else
      s1x=N(1,j1); s2x=N(1,j2); s1z=N(3,j1); s2z=N(3,j2);   
      Mm(1,i)=Mm(1,i)+S.g*Len*(mu1*(2*s1z+s2z)+mu2*(s1z+2*s2z))/6; % <--- check this
      Mm(3,i)=Mm(3,i)+S.g*Len*(mu1*(2*s1x+s2x)+mu2*(s1x+2*s2x))/6;
    end
  end
end
if ~exist('Mm'), Mm=[]; end            
% add reaction moment at fixed node j to the moment on the MFM i to which it is connected
for j=1:S.s, [temp,i]=max(boolean(S.Cmfm(:,S.q+S.p+S.r+j))); Mm(:,i)=Mm(:,i)+MS(:,j); end  % (check this?)
sys=[sys; reshape(Mm,numel(Mm),1)];
eqns=length(sys);

if RR_VERBOSE>1,
   disp('The solver sets up the eqns listed below, with the variables as shown,')
   disp('in the form Ax=b, then looks for a solution such the sys=0.'),
   sys
end

% Now, set up x1 to xm (tensions in S.tfm members) as symbolic variables...
for i=1:S.tfm; exp="syms x"+i; eval(exp); end
% ... and set up the nonzero fk_i_j, vpk_i, vri, vsi, and ms as symbolic variables
for i=1:S.mfm, for j=1:S.n
  if S.Cmfm(i,j)>0, for k=1:S.d; exp="syms f"+k+"_"+i+"_"+j; eval(exp); end, end
end, end
for i=1:S.p,         for k=1:S.d, exp="syms vp"+k+"_"+i;      eval(exp); end, end
for i=1:S.r,                      exp="syms vr"+i;            eval(exp); end 
for i=1:S.s,         for k=1:S.d, exp="syms vs"+k+"_"+i;      eval(exp); end, end
for i=1:S.s,         if S.d==2,   exp="syms ms"+i;            eval(exp);
     else,           for k=1:S.d, exp="syms ms"+k+"_"+i;      eval(exp); end
end, end

% set up a symbolic equationsToMatrix command in SYS
SYS='equationsToMatrix([';
% implement the specified tension equations ...
for i=1:size(L.tensiontfm,1), SYS=SYS+"x"+L.tensiontfm(i,1)+"=="+L.tensiontfm(i,2)+","; end

% then implement all other eqns (SUM OF FORCES AT NODES=0, SUM OF FORCES ON MEMBERS=0,
% SUM OF MOMENTS ON MEMBERS=0)
for i=1:eqns, SYS=SYS+"sys("+i+")==0"; if i<eqns, SYS=SYS+","; end, end, SYS=SYS+"],[";
first=true; for i=1:S.tfm,
  if first, SYS=SYS+"x"+i; first=false;
  else,     SYS=SYS+",x"+i; end
end

for i=1:S.mfm, for j=1:S.n, if S.Cmfm(i,j)>0, for k=1:S.d; 
  if first, SYS=SYS+"f"+k+"_"+i+"_"+j; first=false;
  else,     SYS=SYS+",f"+k+"_"+i+"_"+j; end
end, end, end, end
for i=1:S.p, for k=1:S.d, SYS=SYS+",vp"+k+"_"+i; end, end
for i=1:S.r,              SYS=SYS+",vr"+i;       end
for i=1:S.s, for k=1:S.d, SYS=SYS+",vs"+k+"_"+i; end, end
for i=1:S.s, if S.d==2,   SYS=SYS+",ms"+i;       
       else, for k=1:S.d, SYS=SYS+",ms"+k+"_"+i; end, end, end
SYS=SYS+"])";

% finally, evaluate the large symbolic equationsToMatrix command assembled above,
% thus converting SYS to Ax=b form
[A,b]=eval(SYS);
A=eval(A); b=eval(b); % express A and b as a regular matrix and vector
[c1,c2]=size(A);
if RR_VERBOSE>0, disp("A has mhat="+c1+" equations, nhat="+c2+" unknowns, and rank="+rank(A)), end
end % function RR_Structure_Analyze