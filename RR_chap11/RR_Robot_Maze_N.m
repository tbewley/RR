function RR_Robot_Maze_N(RR,v,x0)                                                 % Version 1.1
% Goal: traverse every path of a maze with RR robots, build a map, and exit.
% [v]=verbosity: 0=silent, 1=print info, 2=make a movie, 3=pause each timestep
% [x0]: initial condition
% Notes: 1=true, 0=false. As p is built as we go; its ordering is different from truth.
% MKS units used throughout, all angles in radians.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap11
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

global ver; if nargin==1, ver=0; else, ver=v; end        % ver=verbosity (how much output)
if ver==2, system('mkdir temp'); end   % if ver==2, we make a movie in directory 'temp'
if nargin<3,                           % set initial state x(:,R) for each of up to 8 bots
  x=[0 -.4 -.2 -.2 -.1 -.1 -.3 -.3;    % x(:,R)=[r_1,r_2,alpha]
     0  0   .2 -.2  .1 -.1  .1 -.1;    % alpha is positive counter-clockwise
     0  0 -pi/2 pi/2 0  0 -pi/4 pi/4]; % (zero to the right)
else, x=x0; end

% SUBFUNCTION GLOSSARY. The following subfunctions are defined further down in this code:
%
%   [p,dist,via,j]=SetPoint(Tx,C,p,dist,via)   Store point info in p, update dist & via.
%   [dist,via]=LoopCheck(dist,via,p,A,B,vA,vB) Correct dist & via when a loop is detected.
%   [tr,D]=InitTruthModel            Define coordinates and connectivity of actual maze.
%   D=GetVisiblePaths(tr,Cx,viz)     Find coordinates of points along all connecting paths.
%   [Tx,confirmed,T]=UpdateTargetPoint(tr,Cx,Tx,c1,d) Recalculate target when driving path.
%   PlotMaze(p)                      Print maze (can call with either tr or p).
%   show(string,varargin)            Print some stuff to the terminal.
%   rhs=RHS(x,U,Udiff)               Auxiliary function used by RK4 routine.
%   a=Angle(v1,v2)                   The angle between v1 and v2, with 0 <= a <= pi.
%   a=SignedAngle(v1,v2)             The angle from v1 to v2, with -pi <= a <= pi.
%
% DATA STRUCTURE GLOSSARY. The remainder of the variables in the code are data structures.
% The most important are summarized below:
%
% p is an elastic (i.e., growing) data structure containing all points known so far, and
%   their known connectivities, using the following data structure for each known point:
% p(i).x       [x1-coordinate,x2-coordinate] of point p(i)            [vec of 2 reals]
% p(i).n       Number of TAKEN branches extending from p(i)           [int]
% p(i).m       Number of TOTAL branches extending from p(i)           [int]
% p(i).ID      ID of points to which taken paths extend        [elastic vec of p(i).n ints]
% p(i).taken   Of all the paths returned in D by GetVisiblePaths,
%              flags those that have already been taken.              [vec of p(i).m bools]
% p(i).started Of all the paths returned in D by GetVisiblePaths,
%              flags those that have at least been started.           [vec of p(i).m bools]
% p(i).done    Have all branches from here been travelled?            [bool]
%
% dist(i,j)    An (elastic) symmetric array of minimum known distances between
%              points i and j in the array p.      [elastic array of len(p) x len(p) reals]
% via(i,j)     An (elastic) array of the best node to head towards in order to travel from
%              point i to point j in the array p.  [elastic array of len(p) x len(p) ints]
%
% P(R)          ID of point (in p) of PREVIOUS point of bot R          [vec of RR ints]
% C(R)          ID of point (in p) of CURRENT  point of bot R          [vec of RR ints]
% N(R)          ID of point (in p) of NEXT     point of bot R          [vec of RR ints]
% Tx(:,R)       target point down next path that bot R will take.      [array of 2xRR reals]
%   Whenever we InitNewSegment, we are near enough to C(R) with bot R to figure out which
%   direction bot R will turn next [towards a new target point Tx(:,R)], but only discover
%   N(R) once we are close enough to see it.
% S0(:,R)       Unit vector from P(R) to C(R)                          [array of 2xRR reals]
% S1(:,R)       Unit vector from C(R) to Tx, or to N(R) if known       [array of 2xRR reals]
% CHECK(R)      Pay attention to P(R)->C(R) segment (for cornering)    [vec of RR bools]
%
% symb(R)       Symbol used to plot position of bot R          [cell of 2 chars]
% symb1, symb2, symb3   Lists of symbols used to make symb(R)  [array of 9 cells of 2 chars]
%
% InitNewSegment(R) Flag used to trigger initialization of next segment    [vec of RR bools]
% confirmed(R)      Flag used to indicate if target is a node of the maze  [vec of RR bools]
% do180(R)          Flag used to trigger a 180 degree turn at target       [vec of RR bools]
%
% Local variables used in InitNewSegment calculation:
%   preferred  IDs of unstarted directions                            [elastic vec of ints]
%   possible   IDs of untaken directions                              [elastic vec of ints]
%   redo       IDs of useful points in p we could backtrack to        [elastic vec of ints]
%   t1         temporary vector used in min angle computation         [elastic vec of reals]
% Local variables used in steering calculation:
%   c0(:)      Closest point on S0 line to current point                    [vec of 2 reals]
%   c1(:)      Closest point on S1 line to current point                    [vec of 2 reals]
%   g(:)       Goal point towards which we will plan a constant-radius turn [vec of 2 reals]
% Local variable used in the detection of reaching the path end
%   stop(:)    Point beyond which this segment will be declared finished    [vec of 2 reals]

global r L;   % PARAMETERS OF PATH FOLLOWER
U=2;          % Target forward velocity.  U=(U_right+U_left)/2
ell=.15;      % Lookahead distance (increase for smoother, sloppier response).
h=.4; t=0;    % The timestep and initial time for the time-marching algorithm.
r=.035; L=.1; % The wheel radius and distance between wheels.
K=2;          % Extra gain on feedback.
viz=.5;       % The distance ahead that one can see clearly

[tr,D]=InitTruthModel;          % INITIALIZE TRUTH and IDENTIFY FIRST POINT OF MAZE.
[p,dist,via]=SetPoint(D(1).x);  % INITIALIZE p, dist, via.
text(p(1).x(1),p(1).x(2),'1','FontSize',35)
symb1={'r+' 'rx' 'ro' 'rs' 'rd' 'rv' 'r^' 'r<' 'r>'};
symb2={'k+' 'kx' 'ko' 'ks' 'kd' 'kv' 'k^' 'k<' 'k>'};
symb3={'b+' 'bx' 'bo' 'bs' 'bd' 'bv' 'b^' 'b<' 'b>'};
for R=1:RR; plot(x(1,R),x(2,R),char(symb1(R)),'MarkerSize',15), end, axis off;
rectangle('Position',[-0.5 -2 6.2 4],'FaceColor',[.8 .8 .82],'LineWidth',1)
pause(0.01)

P(1:RR)=0; C(1:RR)=1; done=0; finished(1:RR)=0; InitNewSegment(1:RR)=1; timestep=0;

while sum(finished)<RR;
 for R=1:RR; if ~finished(R)
  if InitNewSegment(R), symb(R)=symb1(R); % LOGIC FOR INITIALIZING EACH NEW PATH FROM C->N

    %%%%% NOTE: when parallelizing, the following section needs to use %%%%%
    %%%%% a semaphore to protect the p(C(R)) record, which it updates. %%%%%
    D=GetVisiblePaths(tr,p(C(R)).x,viz); p(C(R)).m=length(D);  % GET PATHS CONNECTING TO C
    if length(p(C(R)).started)==0, p(C(R)).started=zeros(p(C(R)).m,1); end
    if length(p(C(R)).taken)  ==0, p(C(R)).taken  =zeros(p(C(R)).m,1); end
    FoundNewPath=0; paths=0; if ~p(C(R)).done  % Find untaken (preferably, unstarted) path
      preferred=[]; possible=[]; for i=1:p(C(R)).m, started=0; t1=[];
        for j=1:p(C(R)).n; t1(j)=Angle(D(i).x-p(C(R)).x,p(p(C(R)).ID(j)).x-p(C(R)).x); end
        j=find(t1<1e-2,1); if length(j)>0, p(C(R)).taken(i)=1; p(C(R)).started(i)=1; end
        if ~p(C(R)).taken(i), text(D(i).x(1),D(i).x(2),'?');
          paths=paths+1; possible=[possible i];
          plot([p(C(R)).x(1) D(i).x(1)],[p(C(R)).x(2) D(i).x(2)],'b--')
          if (~FoundNewPath & ~p(C(R)).started(i)); preferred=[preferred i]; end
        end
      end
      Lpr=length(preferred); Lpo=length(possible); if Lpr>0,
        if Lpr==1, i=1;
        else, ang=[]; for i=1:Lpr
          ang(i)=Angle(D(preferred(i)).x-p(C(R)).x,p(C(R)).x-p(P(R)).x); end
        [Y,i]=min(ang); end
        j=preferred(i); Tx(:,R)=D(j).x; p(C(R)).started(j)=1; FoundNewPath=1;
      elseif Lpo>0, i=possible(mod(R,Lpo)+1); Tx(:,R)=D(i).x; FoundNewPath=1;
      end
    end
    if FoundNewPath, show('Found %d untaken path(s) at node %d',paths,C(R)), confirmed(R)=0;
    else                                           % No more untaken paths from C.
      confirmed(R)=1; if ~p(C(R)).done, p(C(R)).done=1; show('NODE %d DONE!!!!',C(R)), end
      if ~done, done=1; redo=[];
        for i=1:length(p), if ~p(i).done, done=0; redo=[redo i]; end, end
        if done, show('ALL NODES DONE!!!!!!!!!!!!!!!!!!!!'), end, end
      if done                                      % Head home if done or backtrack
         N(R)=via(C(R),1); symb(R)=(symb2(R));     % to nearest point with untaken paths.
         if N(R)==1, show('BOT %d GOING HOME FROM NODE %d',R,C(R))
         else,       show('BOT %d GOING HOME FROM NODE %d VIA NODE %d',R,C(R),N(R)), end
      else, s=inf; symb(R)=(symb3(R));
        for i=1:length(redo), t=dist(C(R),redo(i)); if t<s, s=t; N(R)=via(C(R),redo(i));
          ii=i; end, end
        if redo(ii)==N(R), show('BOT %d BACKTRACKING FROM %d TO %d',R,C(R),redo(ii))
        else,    show('BOT %d BACKTRACKING FROM %d TO %d VIA %d',R,C(R),redo(ii),N(R)), end
      end, Tx(:,R)=p(N(R)).x; confirmed(R)=1;
    end
    %%%%% End of section needing semaphore protection for updating p(C(R)) record. %%%%%

    do180(R)=0;                % See if a 180 is going to be needed once we finish segment.
    if (P(R)~=0 & (length(D)==1 | Angle(Tx(:,R)-p(C(R)).x,p(C(R)).x-p(P(R)).x)>3))
      do180(R)=1; Tx(:,R)=p(C(R)).x; C(R)=P(R); P(R)=0; end
    if P(R)~=0, CHECK(R)=1;    % Precalculate the S0(:,R) [if needed] and S1(:,R) vectors.
      S0(:,R)=p(C(R)).x-p(P(R)).x; S0(:,R)=S0(:,R)/norm(S0(:,R)); % Unit vector from P to C
    else, CHECK(R)=0; end
    S1(:,R)=Tx(:,R)-p(C(R)).x; S1(:,R)=S1(:,R)/norm(S1(:,R));     % Unit vector from C to Tx
    InitNewSegment(R)=0;
  end

  if (CHECK(R))                    % STEER TO FOLLOW PATH SEGMENT UNTIL AT (OR NEAR) TARGET.
    c0=p(P(R)).x-((p(P(R)).x-x(1:2,R))'*S0(:,R))*S0(:,R);      % Closest point on P->C leg.
  end
  c1=p(C(R)).x-((p(C(R)).x-x(1:2,R))'*S1(:,R))*S1(:,R);        % Closest point on C->Tx leg.
  if (CHECK(R) & norm(x(1:2,R)-c0)>norm(x(1:2,R)-c1)), CHECK(R)=0; end % Handle x passing C
  if (~CHECK(R)), g=p(C(R)).x+(norm(c1-p(C(R)).x)+ell)*S1(:,R); % Goal is ell units ahead.
  else, g=p(C(R)).x+(ell-norm(p(C(R)).x-c0))*S1(:,R); end       % Goal is around the corner.
  d=norm(g-x(1:2,R));                % Distance from robot's current location to goal point.
  % Lateral distance to be moved when advancing from robot's current location to goal point.
  delta=(g(1)-x(1,R))*sin(x(3,R))-(g(2)-x(2,R))*cos(x(3,R));
  gamma=-2*delta/d^2;            % 1/gamma = radius of curvature required to intercept goal.
  alphadot=gamma*(U*r); Udiff=K*(L/2)*alphadot/r; % Turn rate to turn at desired radius.
  
  f1=RHS(x(:,R),U,Udiff);        f2=RHS(x(:,R)+h*f1/2,U,Udiff);  % SIMULATE SYSTEM WITH RK4
  f3=RHS(x(:,R)+h*f2/2,U,Udiff); f4=RHS(x(:,R)+h*f3,U,Udiff);    % (Replace this code with
  x(:,R)=x(:,R)+h*(f1/6+(f2+f3)/3+f4/6); t=t+h;                  % application to system.)
  plot(x(1,R),x(2,R),char(symb(R)),'MarkerSize',6);
  
  if (~confirmed(R) & norm(c1-Tx(:,R))<ell), CHECK(R)=0;         % UPDATE TARGET POINT
     show('Updating target point of bot %d',R);
     [Tx(:,R),confirmed(R)]=UpdateTargetPoint(tr,p(C(R)).x,Tx(:,R),c1,viz); Tx(:,R);
     if confirmed(R), [p,dist,via,N(R)]=SetPoint(Tx(:,R),C(R),p,dist,via);
        text(p(N(R)).x(1),p(N(R)).x(2),sprintf('%d',N(R)),'FontSize',35);
     else, text(Tx(1,R),Tx(2,R),'?'), end
  end
  
  if (confirmed(R))                                              % DETERMINE WHETHER OR NOT
    if (do180(R)|(done & N(R)==1)), stop=Tx(:,R);                % THIS SEGMENT IS FINISHED
    else, stop=p(C(R)).x+S1(:,R)*(norm(Tx(:,R)-p(C(R)).x)-ell); end
    if ((p(C(R)).x-((p(C(R)).x-x(1:2,R))'*S1(:,R))*S1(:,R)) -stop)'*S1(:,R)>=0,
      if sum(p(C(R)).started)>=length(p(C(R)).started) & ~p(C(R)).done, p(C(R)).done=1;
         show('NODE %d DONE!!!!',C(R)), end
      InitNewSegment(R)=1; if (done & N(R)==1), finished(R)=1; show('BOT %d HOME',R), end
      if do180(R)
        if x(3,R)>0, x(3,R)=x(3,R)-pi; else, x(3,R)=x(3,R)+pi; end
        P(R)=0; [p,dist,via,C(R)]=SetPoint(Tx(:,R),C(R),p,dist,via);
        show('BOT %d TURNING A 180 IN PLACE AT NODE %d',R,C(R))
      else
        P(R)=C(R); C(R)=N(R);
      end
    end
  end
  % for i=1:length(p), show('p(%d)',i), p(i), end, dist, via, pause, % DEBUG CODE
 end, end
 if v==2, fn=['temp/f' num2str(1000000+timestep) '.tiff']; print('-dtiff','-r100',fn), end
 timestep=timestep+1; if v==3, pause, else, pause(0.001), end
end, show('ALL BOTS HOME!!!!!!!!!!!!')
end % function RR_Robot_Maze_N
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p,dist,via,j]=SetPoint(Tx,C,p,dist,via)
% If nargin==1, initialize array p with point Tx.
% Otherwise, add neighbor Tx of point C to array p, update ID field, and dist & via arrays.
%%%%% NOTE: when parallelizing, this subroutine needs to use a semaphore %%%%%
%%%%% to protect the p(C) and p(j) records, which it updates.            %%%%%
if nargin==1, p(1).x=Tx; p(1).n=0; p(1).ID=[]; dist=[0]; via=[0]; j=1; p(1).done=0;
  p(1).started=[]; p(1).taken=[];
else
  for j=1:length(p); t1(j)=norm(p(j).x-Tx); end, j=find(t1<1e-6,1);
  if j, show('Updating point %d',j);
      for k=1:p(j).n; t2(k)=p(j).ID(k); end, k=find(t2==C,1);
      if length(k)==0, show('****** LOOP DETECTED WHEN CONNECTING NODES %d AND %d ****',C,j)
        p(j).ID=[p(j).ID C]; p(j).n=p(j).n+1;
        p(C).ID=[p(C).ID j]; p(C).n=p(C).n+1;
        t=norm(p(j).x-p(C).x); dist(j,C)=t; dist(C,j)=t; via(j,C)=C; via(C,j)=j;
        [dist,via]=LoopCheck(dist,via,p,j,C);
      end
  else, j=length(p)+1; show('Creating point %d',j);
      p(j).x=Tx;       p(j).done=0;          p(j).started=[];
      p(j).ID=[        C]; p(j).n=       1;
      p(C).ID=[p(C).ID j]; p(C).n=p(C).n+1;
      t=norm(p(j).x-p(C).x); dist(j,C)=t; dist(C,j)=t; via(j,C)=C; via(C,j)=j;
      for k=1:j-1, if k~=C, t=dist(j,C)+dist(C,k);
         dist(j,k)=t; dist(k,j)=t; via(j,k)=C; via(k,j)=via(k,C);
      end, end
  end
end
%%%%% End of section needing semaphore protection for updating p(C) and p(j) records. %%%%%
end % function SetPoint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dist,via]=LoopCheck(dist,via,p,A,B,vA,vB)
% The recursive logic that corrects the dist and via arrays when a loop is detected.
show('Route checking from %d to %d',A,B)
if nargin==7, t=dist(A,vA)+dist(vA,vB)+dist(vB,B); else, t=dist(A,B); vA=B; vB=A; end
if ((nargin==5 & t<=dist(A,B))|(t<dist(A,B)))
  dist(A,B)=t; dist(B,A)=t; via(A,B)=vA; via(B,A)=vB;
  for k=1:p(A).n; if p(A).ID(k)~=vA,  % loop over all over neighbors of A not including vA
    [dist,via]=LoopCheck(dist,via,p,p(A).ID(k),B,A,vB); end, end
  for k=1:p(B).n; if p(B).ID(k)~=vB,  % loop over all over neighbors of B not including vB
    [dist,via]=LoopCheck(dist,via,p,A,p(B).ID(k),vA,B); end, end
end
end % function LoopCheck
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tr,D]=InitTruthModel     % Define coordinates and connectivity of actual maze.
tr(1 ).x=[ 0 ;  0 ]; tr(1 ).ID=[2];         D(1).x=tr(1).x;  % Also returns first point.
tr(2 ).x=[ 1 ;  0 ]; tr(2 ).ID=[1 3 5];     D(1).m=length(tr(1).ID);
tr(3 ).x=[ 2 ;  1 ]; tr(3 ).ID=[2 4 6 7];
tr(4 ).x=[ 3 ;  0 ]; tr(4 ).ID=[3 5 6];
tr(5 ).x=[ 1 ; -.5]; tr(5 ).ID=[4 2 9];
tr(6 ).x=[ 4 ;  0 ]; tr(6 ).ID=[4 7 8 9 3];
tr(7 ).x=[4.5;  1 ]; tr(7 ).ID=[6 3];
tr(8 ).x=[ 5 ;  0 ]; tr(8 ).ID=[6];
tr(9 ).x=[ 4 ; -1 ]; tr(9 ).ID=[6 10 5];
tr(10).x=[ 5 ; -1 ]; tr(10).ID=[9];        clf, hold on; axis equal; PlotMaze(tr)
end % function InitTruthModel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D=GetVisiblePaths(tr,Cx,viz)
% Input:  truth map, coordinates of current node, and visibility distance.
% Output: coordinates of points along all connecting paths (many limited by viz)
for i=1:length(tr); t(i)=norm(tr(i).x-Cx); end, i=find(t<1e-6,1);
for j=1:length(tr(i).ID), n=norm(tr(tr(i).ID(j)).x-Cx);
  if n<viz, D(j).x=tr(tr(i).ID(j)).x;
  else,     s=tr(tr(i).ID(j)).x-Cx; s=s/norm(s); D(j).x=Cx+s*viz; end
end
end % function GetVisiblePaths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Tx,confirmed,T]=UpdateTargetPoint(tr,Cx,Tx,c1,d)             % Recalculate target
for i=1:length(tr);       t1(i)=norm(tr(i).x-Cx);                  end, i=find(t1<1e-6,1);
for j=1:length(tr(i).ID); t2(j)=Angle(tr(tr(i).ID(j)).x-Cx,Tx-Cx); end, j=find(t2<1e-2,1);
n=norm(tr(tr(i).ID(j)).x-c1);
if n<d, Tx=tr(tr(i).ID(j)).x;                           confirmed=1;
else,   s=tr(tr(i).ID(j)).x-Cx; s=s/norm(s); Tx=Cx+s*(norm(c1-Cx)+d); confirmed=0; end
end % function UpdateTargetPoint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PlotMaze(p)
figure(1); clf; hold on; axis equal; axis([-0.6 5.8 -2.1 2.1]);
for i=1:length(p), for j=1:length(p(i).ID), if p(i).ID(j)>i
  plot([p(i).x(1) p(p(i).ID(j)).x(1)],[p(i).x(2) p(p(i).ID(j)).x(2)],'w:')
end, end, end
end % function PlotMaze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function show(string,varargin)
global ver; if ver>0, disp(sprintf(string,varargin{:})), end
end % function show
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rhs=RHS(x,U,Udiff)                        % Auxiliary function used by RK4 routine
global r L; rhs=[r*U*cos(x(3)); r*U*sin(x(3)); r*Udiff/(L/2)];
end % function RHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a=Angle(v1,v2)         % Calculate the angle between v1 and v2, with 0 <= a <= pi.
a=acos(dot(v1,v2)/(norm(v1)*norm(v2)));          % Note: this is faster than SignedAngle.
end % function Angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a=SignedAngle(v1,v2)   % Calculate the angle from v1 to v2, with -pi <= a <= pi.
a=atan2(v2(2),v2(1))-atan2(v1(2),v1(1)); if a>pi, a=a-2*pi; elseif a<-pi, a=a+2*pi; end
end % function SignedAngle