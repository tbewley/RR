function RR_Structure_Plot(S,L,x,ax)
% Plots structure S with loads L, as analyzed by computing the solution to Ax=b as set up by
% [A,b,S,L]=RR_Analyze_Structure(S,L), where x=pinv(A)*b + any linear combination of vectors
% from null(A).  Note: to confirm that at least one solution exists, calculate norm(A*x-b).
% Also note that RR_Analyze_Structure augments and rearranges S,L such that the TFMs
% (two-force members) are listed first, and the MFMs (multi-force members) are listed next. 
% INPUTS: S.Q     = FREE nodes (required, must be at least one free node in Q)
%         S.P     = PINNED support nodes (optional)
%         S.P_vec = normal vector of the pinned nodes (optional)
%         S.R     = ROLLER support nodes (optional)
%         S.R_vec = normal vector of the roller nodes (optional)
%         S.S     = FIXED  support nodes (optional)
%         S.S_vec = normal vector of the fixed nodes (optional)
%         S.C     = matrix of 0's and 1's defining the connectivity of the structure
%         L.U     = force applied at all of the q free nodes of the structure (required)
%         L.M     = moments applied to all of the m members of the structure (optional)
%         L.tension = preset tension in specified members (optional)
%         ax is an optional field (as opposed to S,L,x) that contains the figure axes
%  if global RR_VERBOSE =0 (or missing) runs silent, =1 shows minor stuff, =2 shows debug stuff
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

global RR_VERBOSE % runs silent if =0 (or missing), minor stuff if =1, debug stuff if =2

y=x(S.tfm+1:end); x=x(1:S.tfm); % keep TFM forces in x, move MFM forces to y
if ~isfield(L,'U_in'), L.U_in=true(S.q,1); end  % Default vectors indicating applied forces
if ~isfield(S,'P_in'), S.P_in=true(S.p,1); end  % at free nodes and reaction forces at support
if ~isfield(S,'R_in'), S.R_in=true(S.r,1); end  % all point IN to the node.
if ~isfield(S,'S_in'), S.S_in=true(S.s,1); end  % (set one or more to false to point OUT)

% {sy,sw} defines the line {color,width} to be used for each TFM
% {slack,tension,compression} TFMs are {black,red,blue}
if S.tfm>0
  mx=max(x); if RR_VERBOSE>0 & mx>0, fprintf('maximum tension in TFMs (red, bold)   = %0.5g\n',mx), end
  mn=min(x); if RR_VERBOSE>0 & mn<0, fprintf('maximum compression TFMs (blue, bold) = %0.5g\n',abs(mn)), end
  for i=1:S.tfm  
    if norm(x(i))<1e-5, sy(i,:)='k-';  sw(i)=3; 
      if RR_VERBOSE>0, fprintf('Two-force member (TFM)  #%d is nearly slack.\n',i), end
    elseif x(i)>0,      sy(i,:)='r-'; if x(i)>mx*0.9, sw(i)=6; else, sw(i)=3; end
      if RR_VERBOSE>0, fprintf('Pure tension     in TFM #%d = %0.5g\n',i, x(i)), end
    else,               sy(i,:)='b-'; if x(i)<mn*0.9, sw(i)=6; else, sw(i)=3; end
      if RR_VERBOSE>0, fprintf('Pure compression in TFM #%d = %0.5g\n',i,-x(i)), end, end
  end
end

% extract nonzero MFM forces, reaction forces, and reaction moments from y
F(1:S.mfm,1:S.n,1:S.d)=0;       
for i=1:S.mfm, sy(S.tfm+i,:)='g-'; sw(S.tfm+i)=6;       % MFMs are magenta
  for j=1:S.n, if S.Cmfm(i,j)==1, for k=1:S.d, F(i,j,k)=y(1); y=y(2:end); end,end,end
end
VP=[]; VR=[]; VS=[]; % extract nonzero reaction forces at P,R,S support points from y
for i=1:S.p, for k=1:S.d, VP(k,i)=y(1);   y=y(2:end); end, end
for i=1:S.r, VR(:,i)=y(1)*S.R_vec(:,i);   y=y(2:end); end 
for i=1:S.s, for k=1:S.d, VS(k,i)=y(1);   y=y(2:end); end, end
% extract nonzero reaction moments at S support points from x
for i=1:S.s, if S.d==2,       MS(i)=y(1);   y=y(2:end);
           else, for k=1:S.d, MS(k,i)=y(1); y=y(2:end); end
end, end

if RR_VERBOSE>0
  for i=1:size(L.U,2),
    t=norm(L.U(:,i));
    if t>0, fprintf('Norm of externally-applied load at free node #%d: %0.5g\n',i,t), end
  end
  disp('(external loads at other free nodes are zero)');
  for i=1:size(VP,2),
    fprintf('Norm of reaction force at pinned node #%d: %0.5g\n',i,norm(VP(:,i)))
  end
  for i=1:size(VR,2),
    fprintf('Norm of reaction force at roller node #%d: %0.5g\n',i,norm(VR(:,i)))
  end
  for i=1:size(VS,2),
    fprintf('Norm of reaction force at  fixed node #%d: %0.5g\n',i,norm(VS(:,i)))
    if (S.d==2)
      fprintf('Reaction moment at fixed node #%d: %0.5g\n',i,MS(i)),
    else
      fprintf('Norm of reaction moment at fixed node #%d: %0.5g\n',i,norm(MS(:,i))),
    end
  end
end
N=[S.Q S.P S.R S.S];
fac_b=1*(max(max(N))-min(min(N))); fac_f=0.1/max(max(abs([L.U VP VR VS])))*fac_b; 
if nargin<4, clf, ax=axes; end, axes(ax), hold(ax,'on')

if S.d==2 % Draw little 2D triagles/squares below the {pinned,roller,fixed} support points
  for i=1:S.p, drawtriangle(ax,S.P(:,i),S.P_vec(:,i),fac_b,'k-'), end
  for i=1:S.r, drawtriangle(ax,S.R(:,i),S.R_vec(:,i),fac_b,'b-'), end % do the roller one in blue
  for i=1:S.s, drawsquare(  ax,S.S(:,i),S.S_vec(:,i),fac_b,'k-'), end
else      % Draw little 3D pyramids/cubes   below the {pinned,roller,fixed} support points
  for i=1:S.p, drawpyramid( ax,S.P(:,i),S.P_vec(:,i),fac_b,'k-'), end 
  for i=1:S.r, drawpyramid( ax,S.R(:,i),S.R_vec(:,i),fac_b,'b-'), end % do the roller one in blue
  for i=1:S.s, drawcube(    ax,S.S(:,i),S.S_vec(:,i),fac_b,'b-'), end 
end

[row,col] = find(S.C'); % This finds the row and col of nonzero entries of C'
member=0;
for i=1:length(row)     % This plots the members of the structure in both 2D and 3D.
  newx=N(1,row(i)); newy=N(2,row(i)); if S.d==3, newz=N(3,row(i)); end 
  if col(i)>member, member=member+1;
  else, if S.d==2, plot(ax, [lastx newx],[lasty newy],sy(member,:),"LineWidth",sw(member));
        else,      plot3(ax,[lastx newx],[lasty newy],[lastz newz],sy(member,:),"LineWidth",sw(member)); end
  end
  lastx=newx; lasty=newy; if S.d==3, lastz=newz; end 
end

if S.d==2               % This handles the rest of the 2D case
  t1=sum(L.U,2);  t2=sum([VP VR VS],2);
  if RR_VERBOSE>0
    fprintf('Sum of all applied  forces in (x,y) = (%+0.5g, %+0.5g)\n',t1(1),t1(2))
    if S.p+S.r+S.s>0, fprintf('Sum of all reaction forces in (x,y) = (%+0.5g, %+0.5g)\n',t2(1),t2(2)), end
  end
  for i=1:S.q
    if L.U_in(i)
      f=quiver(ax,N(1,i)-fac_f*L.U(1,i),N(2,i)-fac_f*L.U(2,i),fac_f*L.U(1,i),fac_f*L.U(2,i),0);
    else
      f=quiver(ax,N(1,i),N(2,i),fac_f*L.U(1,i),fac_f*L.U(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','m');
  end
  for i=1:S.p
    if S.P_in(i)
       f=quiver(ax,S.P(1,i)-fac_f*VP(1,i),S.P(2,i)-fac_f*VP(2,i),fac_f*VP(1,i),fac_f*VP(2,i),0);
    else
       f=quiver(ax,S.P(1,i),S.P(2,i),fac_f*VP(1,i),fac_f*VP(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  for i=1:S.r
    if S.R_in(i)
       f=quiver(ax,S.R(1,i)-fac_f*VR(1,i),S.R(2,i)-fac_f*VR(2,i),fac_f*VR(1,i),fac_f*VR(2,i),0);
    else
       f=quiver(ax,S.R(1,i),S.R(2,i),fac_f*VR(1,i),fac_f*VR(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  for i=1:S.s
    if S.S_in(i)
       f=quiver(ax,S.S(1,i)-fac_f*VS(1,i),S.S(2,i)-fac_f*VS(2,i),fac_f*VS(1,i),fac_f*VS(2,i),0);
    else
       f=quiver(ax,S.S(1,i),S.S(2,i),fac_f*VS(1,i),fac_f*VS(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
    if MS(i)<0
      r=0.4; t=-2*pi*7/8; x=S.S(1,i)+r*cos(t); y=S.S(1,i)+r*sin(t);
      drawcircle(ax,S.S(:,i),0.4,3,'r',0,t)
      plot(ax,[x x-r/2],[y y+r/20],'r','LineWidth',3)
      plot(ax,[x x-r/4],[y y+r/2], 'r','LineWidth',3)
    else 
      r=0.4; t=2*pi*3/8; x=S.S(1,i)+r*cos(t); y=S.S(1,i)+r*sin(t);
      drawcircle(ax,S.S(:,i),0.4,3,'r',-pi,t)
      plot(ax,[x x+r/2],[y y+r/20],'r','LineWidth',3)
      plot(ax,[x x+r/4],[y y+r/2], 'r','LineWidth',3)
    end
  end
else              % this handles the rest of the 3D case
  t1=sum(L.U,2);  t2=sum([VP VR VS],2);
  if RR_VERBOSE>0
    fprintf('Sum of all applied  forces in (x,y,z) = (%+0.5g, %+0.5g, %+0.5g)\n',t1(1),t1(2),t1(3))
    if S.p+S.r+S.s>0, fprintf('Sum of all reaction forces in (x,y,z) = (%+0.5g, %+0.5g, %+0.5g)\n',t2(1),t2(2),t2(3)), end
  end
  fac_b=fac_b*0.07; fac_f=fac_f*2;                   % Tweak the scale factors for 3D
  for i=1:S.q
    if L.U_in(i)
        f=quiver3(ax,S.Q(1,i)-fac_f*L.U(1,i), S.Q(2,i)-fac_f*L.U(2,i), S.Q(3,i)-fac_f*L.U(3,i), ...
                              fac_f*L.U(1,i),          fac_f*L.U(2,i),          fac_f*L.U(3,i),0);
    else
        f=quiver3(ax,S.Q(1,i),       S.Q(2,i),       S.Q(3,i), ...
                     fac_f*L.U(1,i), fac_f*L.U(2,i), fac_f*L.U(3,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','m');
  end
  for i=1:S.p
    if S.P_in(i)
      f=quiver3(ax,S.P(1,i)-fac_f*VP(1,i), S.P(2,i)-fac_f*VP(2,i), S.P(3,i)-fac_f*VP(3,i), ...
                            fac_f*VP(1,i),          fac_f*VP(2,i),          fac_f*VP(3,i),0);
    else
      f=quiver3(ax,S.P(1,i),      S.P(2,i),      S.P(3,i), ...
                   fac_f*VP(1,i), fac_f*VP(2,i), fac_f*VP(3,i),0);
    end      
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  for i=1:S.r
    if S.R_in(i)
      f=quiver3(ax,S.R(1,i)-fac_f*VR(1,i), S.R(2,i)-fac_f*VR(2,i), S.R(3,i)-fac_f*VR(3,i), ...
                            fac_f*VR(1,i),          fac_f*VR(2,i),          fac_f*VR(3,i),0);
    else
      f=quiver3(ax,S.R(1,i),      S.R(2,i),      S.R(3,i), ...
                   fac_f*VR(1,i), fac_f*VR(2,i), fac_f*VR(3,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  for i=1:S.s
    if S.S_in(i)
      f=quiver3(ax,S.S(1,i)-fac_f*VS(1,i), S.S(2,i)-fac_f*VS(2,i), S.S(3,i)-fac_f*VS(3,i), ...
                            fac_f*VS(1,i),          fac_f*VS(2,i),          fac_f*VS(3,i),0);
    else
      f=quiver3(ax,S.S(1,i),      S.S(2,i),      S.S(3,i), ...
                   fac_f*VS(1,i), fac_f*VS(2,i), fac_f*VS(3,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
    if norm(MS(:,i))>1e-8  % plot the vector moment as a double headed arrow
      fac_m=0.75*fac_f*fac_b;
      f=quiver3(ax,S.S(1,i), S.S(2,i), S.S(3,i), ...
                   fac_m*MS(1,i), fac_m*MS(2,i), fac_m*MS(3,i),0);
      set(f,'MaxHeadSize',10000,'linewidth',3,'color','b');
      f=quiver3(ax,S.S(1,i),  S.S(2,i), S.S(3,i), ...
                   fac_m*1.3*MS(1,i), fac_m*1.3*MS(2,i), fac_m*1.3*MS(3,i),0);
      set(f,'MaxHeadSize',10000,'linewidth',3,'color','b');
    end
  end
  view(-75.3,6.05)
end, axis(ax,'equal'), axis(ax,'tight'),
grid(ax,'on')

end % function RR_Structure_Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawcircle(ax,loc,radius,width,col,deg_min,deg_max)
if nargin<5; col=[0 .7 0]; end
if nargin<7; deg_min=0; deg_max=2*pi; end
N=40; THETA=linspace(deg_min,deg_max,N); RHO=ones(1,N)*radius;
[X,Y] = pol2cart(THETA,RHO); X=X+loc(1); Y=Y+loc(2); Z=0*X;
H=line(ax,X,Y,Z); set(H,'LineWidth',width); set(H,'Color',col);
end % function drawcircle

function drawtriangle(ax,p,v,s,col)
n=null(v')*0.035*s; v=v*0.05*s; a=p-v-n; b=p-v+n;
h=fill(ax,[p(1) a(1) b(1)],[p(2) a(2) b(2)],col); h.FaceAlpha=0.25;
end % function drawtriangle

function drawsquare(ax,p,v,s,col)
n=null(v')*0.025*s; v=v*0.05*s; a=p+n; b=p+n-v; c=p-n-v; d=p-n;
h=fill(ax,[a(1) b(1) c(1) d(1)],[a(2) b(2) c(2) d(2)],col); h.FaceAlpha=0.25;
end % function drawsquare

function drawpyramid(ax,p,v,s,col)
N=null(v')*0.025*s; n1=N(:,1); n2=N(:,2); v=v*0.05*s;
P=[n1+n2-v n1-n2-v -n1-n2-v -n1+n2-v [0;0;0]];
ind=[1 2 5];   patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
ind=[2 3 5];   patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
ind=[3 4 5];   patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
ind=[4 1 5];   patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
ind=[1 2 3 4]; patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
alpha(0.2)
end % function drawpyramid

function drawcube(ax,p,v,s,col)
N=null(v')*0.025*s; n1=N(:,1); n2=N(:,2); v=v*0.05*s;
P=[n1+n2 n1-n2 -n1-n2 -n1+n2 n1+n2-v n1-n2-v -n1-n2-v -n1+n2-v];
ind=[1 2 6 5]; patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
ind=[2 3 7 6]; patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
ind=[3 4 8 7]; patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
ind=[4 1 5 8]; patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
ind=[1 2 3 4]; patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
ind=[5 6 7 8]; patch(ax,P(1,ind)+p(1), P(2,ind)+p(2), P(3,ind)+p(3), col)
alpha(0.2)
end % function drawcube