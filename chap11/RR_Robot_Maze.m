function RR_Robot_Maze  % Goal: traverse every path of a maze, build a map, exit once finished.
%% Renaissance Robotics codebase, Chapter 11, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

% We build up in p a model of all points known so far, and their connectivity,
% using the following data structure for each known point:
% p(i).x         [x1-coordinate,x2-coordinate]                     [vector of 2 reals]
% p(i).n         number of branches from this point                [int]
% p(i).ID        ID of points to which we have travelled from here [vector of p(i).n ints]
% p(i).done      have all branches from here been travelled?       [bool]
% Notes: 1=true, 0=false. As p is built as we go; its ordering is different from truth.

global r L;            % INITIALIZE PARAMETERS OF PATH FOLLOWER (MKS units)
U=2;                   % U=(U_right+U_left)/2 = target forward velocity
ell=.15;               % look ahead distance (increase for smoother, sloppier response)
h=.4; t=0;             % timestep and initial time for time-marching algorithm
r=.035; L=.1;          % wheel radius, and distance between wheels
K=2;                   % Extra gain on feedback (nominally one!)
x=[0;.05;pi/4];        % initial state  x=[r_1,r_2,alpha] (e_1-coord,e_2-coord,angle)
                       % note: angle is positive counter-clockwise (zero to the right)
viz=.5;                % distance ahead that one can see clearly

[truth,D]=InitTruthModel; P=0;       % INITIALIZE TRUTH and IDENTIFY FIRST POINT OF MAZE.
[p,dist,via,C]=SetPoint(D(1).x); text(p(1).x(1),p(1).x(2),'1') % INITIALIZE p, dist, via.
plot(x(1),x(2),'ko'); pause(0.01);

done=0; while (~done | C~=1)
  if P~=0, Px=p(P).x; end, Cx=p(C).x; c='rx';
  D=GetCoordinatesOfPointsAlongVisiblePaths(truth,Cx,viz); % GET PATHS CONNECTING TO C.
  lenD=length(D); lenp=length(p(C).ID); % Number of paths that connect to C, in D and in p.
  if lenD>lenp+1; p(C).done=0; else, p(C).done=1; end % (status AFTER driving next path)
  if lenD>lenp                                        % There are unexplored paths from C.
    for i=lenD:-1:1, explored=0;
      for j=1:lenp, if Angle(D(i).x-Cx,p(p(C).ID(j)).x-Cx)<1e-2; explored=1; break;end,end
      if ~explored, text(D(i).x(1),D(i).x(2),'?'), Tx=D(i).x;  % ASSIGN NEW TARGET POINT
        plot([Cx(1) D(i).x(1)],[Cx(2) D(i).x(2)],'b--') % Draw lines along unexplored paths
      end
    end, confirmed=0; disp(sprintf('There is(are) %d unexplored path(s)',lenD-lenp))
  else,                                              % No more unexplored paths from C.
    done=1; redo=[]; for i=1:length(p), if p(i).done==0, done=0; redo=[redo i]; end, end
    if done, disp('GOING HOME'), T=via(C,1); c='kx'; % Head to home if done or backtrack to
    else, disp('BACKTRACKING'), s=inf; c='bx';       % nearest point with unexplored paths.
      for i=1:length(redo), t=dist(C,redo(i)); if t<s, s=t; T=via(C,redo(i)); end, end
    end, Tx=p(T).x; confirmed=1;
  end
  do180=0; if (P~=0 & (length(D)==1 | Angle(Tx-Cx,Cx-Px)>3))
    do180=1; P=0; Tx=Cx; Cx=Px; confirmed=1;
  end
  if P~=0, check=1; else, check=0; end

  while(1)                          % FOLLOW PATH UNTIL AT (OR NEAR) TARGET.
    if (check)
      s0=Cx-Px; s0=s0/norm(s0);     % Unit vector along trajectory segment from P to C.
      c0=Px-((Px-x(1:2))'*s0)*s0;   % Closest point on segment from P to C to robot.
    end
    s1=Tx-Cx; s1=s1/norm(s1);       % Unit vector along trajectory segment from C to Tx.
    c1=Cx-((Cx-x(1:2))'*s1)*s1;     % Closest point on segment from C to Tx to robot.
    if (confirmed)
      if (do180|(done & T==1)), stoppoint=Tx; else, stoppoint=Cx+s1*(norm(Tx-Cx)-ell); end
      if (c1-stoppoint)'*s1>=0, break, end
    end
    if (check & norm(x(1:2)-c0)>norm(x(1:2)-c1)), check=0; end     % Handle x passing C
    if (~check), g=c1+ell*s1;             % Goal is ell units ahead on segment from Cx->Nx
    else, g=Cx+(ell-norm(Cx-c0))*s1; end  % Goal goes around corner from Px->Cx to Cx->Nx
    d=norm(g-x(1:2));            % Distance from robot's current location to goal point.
    delta=(g(1)-x(1))*sin(x(3))-(g(2)-x(2))*cos(x(3)); % Lateral distance to be moved when
                               % advancing from robot's current location to goal point.
    gamma=-2*delta/d^2;        % 1/gamma = radius of curvature required to intercept goal.
    alphadot=gamma*(U*r); Udiff=K*(L/2)*alphadot/r; % turn rate to turn at desired radius.
    
    f1=RHS(x,U,Udiff);        f2=RHS(x+h*f1/2,U,Udiff);   % SIMULATE SYSTEM WITH RK4
    f3=RHS(x+h*f2/2,U,Udiff); f4=RHS(x+h*f3,U,Udiff);     % (Replace this code chunk with
    x=x+h*(f1/6+(f2+f3)/3+f4/6); t=t+h;                   % application to actual system.)
    plot(x(1),x(2),c); pause(0.01);
    if (~confirmed & norm(c1-Tx)<ell)
       % disp('Updating target point now');
       [Tx,confirmed]=UpdateTargetPoint(truth,Cx,Tx,c1,viz);
       if confirmed, [p,dist,via,T]=SetPoint(Tx,C,p,dist,via);
                     text(p(T).x(1),p(T).x(2),sprintf('%d',T));
       else,         text(Tx(1),Tx(2),'?'), end
    end
  end
  if do180, disp('TURNING A 180 IN PLACE'),
    if x(3)>0, x(3)=x(3)-pi; else, x(3)=x(3)+pi; end, P=0; pause(0.5)
  else, P=C; C=T; end                                     % UPDATE P & C AND REPEAT
  % for i=1:length(p), disp(sprintf('p(%d)',i)), p(i), end, dist, via, pause, % DEBUG CODE
end
end % function RR_Robot_Maze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p,dist,via,j]=SetPoint(Tx,C,p,dist,via)
% If nargin==1, initialize array p with point Tx.
% Otherwise, add neighbor Tx of point C to array p, update ID field, and dist & via arrays.
if nargin==1, p(1).x=Tx; p(1).n=0; p(1).ID=[]; dist=[0]; via=[0]; j=1;
else
  found=0; for j=1:length(p), if p(j).x==Tx, found=1; break, end, end
  if found, disp(sprintf('Updating point %d',j));
      connected=0; for k=1:p(j).n, if p(j).ID(k)==C, connected=1; break, end, end
      if ~connected, disp('************** LOOP DETECTED ************** ')
        p(j).ID=[p(j).ID C]; p(j).n=p(j).n+1;
        p(C).ID=[p(C).ID j]; p(C).n=p(C).n+1;
        t=norm(p(j).x-p(C).x); dist(j,C)=t; dist(C,j)=t; via(j,C)=C; via(C,j)=j;
        [dist,via]=LoopCheck(dist,via,p,j,C);
      end
  else, j=length(p)+1; disp(sprintf('Creating point %d',j));
      p(j).x=Tx;       p(j).done=0;
      p(j).ID=[        C]; p(j).n=       1;
      p(C).ID=[p(C).ID j]; p(C).n=p(C).n+1;
      t=norm(p(j).x-p(C).x); dist(j,C)=t; dist(C,j)=t; via(j,C)=C; via(C,j)=j;
      for k=1:j-1, if k~=C, t=dist(j,C)+dist(C,k);
         dist(j,k)=t; dist(k,j)=t; via(j,k)=C; via(k,j)=via(k,C);
      end, end
  end
end
end % function SetPoint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dist,via]=LoopCheck(dist,via,p,A,B,vA,vB)
% The recursive logic that corrects the dist and via arrays when a loop is detected.
if nargin==7, t=dist(A,vA)+dist(vA,vB)+dist(vB,B); else, t=dist(A,B); vA=B; vB=A; end
if t<=dist(A,B), dist(A,B)=t; dist(B,A)=t; via(A,B)=vA; via(B,A)=vB;
  for k=1:p(A).n; if p(A).ID(k)~=vA,  % loop over all over neighbors of A not including vA
    [dist,via]=LoopCheck(dist,via,p,p(A).ID(k),B,A,vB); end, end
  for k=1:p(B).n; if p(B).ID(k)~=vB,  % loop over all over neighbors of B not including vB
    [dist,via]=LoopCheck(dist,via,p,A,p(B).ID(k),vA,B); end, end
end
end % function LoopCheck
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a=Angle(v1,v2)         % Calculate the angle between v1 and v2, with 0 <= a <= pi.
a=acos(dot(v1,v2)/(norm(v1)*norm(v2)));            % Note: this is faster than SignedAngle.
end % function Angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a=SignedAngle(v1,v2)   % Calculate the angle from v1 to v2, with -pi <= a <= pi.
a=atan2(v2(2),v2(1))-atan2(v1(2),v1(1)); if a>pi, a=a-2*pi; elseif a<-pi, a=a+2*pi; end
end % function SignedAngle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [t,D]=InitTruthModel     % Define coordinates and connectivity of actual maze.
t(1 ).x=[ 0 ;  0 ]; t(1 ).ID=[2];       D(1).x=t(1).x;
t(2 ).x=[ 1 ;  0 ]; t(2 ).ID=[1 3 5];
t(3 ).x=[ 2 ;  1 ]; t(3 ).ID=[2 4 6 7];
t(4 ).x=[ 3 ;  0 ]; t(4 ).ID=[3 5 6];
t(5 ).x=[ 1 ; -.5]; t(5 ).ID=[4 2 9];
t(6 ).x=[ 4 ;  0 ]; t(6 ).ID=[4 7 8 9 3];
t(7 ).x=[4.5;  1 ]; t(7 ).ID=[6 3];
t(8 ).x=[ 5 ;  0 ]; t(8 ).ID=[6];
t(9 ).x=[ 4 ; -1 ]; t(9 ).ID=[6 10 5];
t(10).x=[ 5 ; -1 ]; t(10).ID=[9];       clf, hold on; axis equal;PlotMaze(t)
end % function InitTruthModel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D=GetCoordinatesOfPointsAlongVisiblePaths(truth,Cx,d)
% Input:  truth map and coordinates of current node and visibility distance.
% Output: coordinates of first node or (in nargin==2) coordinates of all connecting nodes.
found=0; for i=1:length(truth), if norm(truth(i).x-Cx)<1e-6, found=1; break, end, end
if ~found, disp('CURRENT POINT NOT FOUND!  PROBLEM!'), pause, end
for j=1:length(truth(i).ID), n=norm(truth(truth(i).ID(j)).x-Cx);
  if n<d, D(j).x=truth(truth(i).ID(j)).x;
  else,   s=truth(truth(i).ID(j)).x-Cx; s=s/norm(s); D(j).x=Cx+s*d; end
end
end % function GetCoordinatesOfPointsAlongVisiblePaths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Tx,confirmed,T]=UpdateTargetPoint(truth,Cx,Tx,c1,d) % Recalculate target
for i=1:length(truth),       if norm(truth(i).x-Cx)<1e-6,                     break,end,end
for j=1:length(truth(i).ID), if Angle(truth(truth(i).ID(j)).x-Cx,Tx-Cx)<1e-2; break,end,end
n=norm(truth(truth(i).ID(j)).x-c1);
if n<d, Tx=truth(truth(i).ID(j)).x;                           confirmed=1;
else,   s=truth(truth(i).ID(j)).x-Cx; s=s/norm(s); Tx=c1+s*d; confirmed=0; end
end % function UpdateTargetPoint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PlotMaze(p)
figure(1); clf; hold on; axis equal; axis([-0.2 5.2 -2 2]);
for i=1:length(p), for j=1:length(p(i).ID), if p(i).ID(j)>i
  plot([p(i).x(1) p(p(i).ID(j)).x(1)],[p(i).x(2) p(p(i).ID(j)).x(2)],'w:')
end, end, end
end % function PlotMaze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rhs=RHS(x,U,Udiff)                      % Auxiliary function used by RK4 routine
global r L; rhs=[r*U*cos(x(3)); r*U*sin(x(3)); r*Udiff/(L/2)];
end % function RHS