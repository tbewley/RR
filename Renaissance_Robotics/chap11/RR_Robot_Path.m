function RR_Robot_Path

%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap11
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

U=.3;                     % U=(U_right+U_left)/2 = target forward velocity (MKS units)
Udiff=0;                  % U_diff=U_right-U_left = steering control variable
                          %   [note that U_right=U+U_diff/2, U_left=U-U_diff/2]
ell=.4;                   % look ahead distance (increase for smoother, "sloppier" response)
p=[0 1 1 2;               % desired trajectory (straight line segments)
   0 1 0 1];
n=size(p,2);              % number of points on desired trajectory
k=2;                      % inital target point on trajectory
x=[0;.2;pi/2];            % initial state  x=[r_1,r_2,alpha] (e_1-coord,e_2-coord,angle)
                          % alpha is positive counter-clockwise (zero to the right)
h=1;   t=0;               % timestep and initial time for time-marching algorithm
close all; global r L; r=.053975; L=.39116; % wheel radius, and distance between wheels
K=2;  % Extra gain on feedback (nominally one!)

xmin=min(p(1,:)); xmax=max(p(1,:)); ymin=min(p(2,:)); ymax=max(p(2,:)); 


plot(p(1,:),p(2,:),'bo-'); axis equal; hold on; axis([xmin-.1 xmax+.1 ymin-.1 ymax+.1]);

for i=1:1000
  s0=p(:,k)-p(:,k-1); s0=s0/norm(s0);     % Unit vector along current trajectory segment
  c0=p(:,k-1)-((p(:,k-1)-x(1:2))'*s0)*s0; % Closest point on current segment to robot
  if (norm(p(:,k)-c0)<ell), check=true, else, check=false; end
  if (check & k<n)
    s1=p(:,k+1)-p(:,k); s1=s1/norm(s1);   % Unit vector along next trajectory segment.
    c1=p(:,k)-((p(:,k)-x(1:2))'*s1)*s1;   % Closest point on next segment to robot.
  end
  if     (check & k<n  & norm(x(1:2)-c0)>norm(x(1:2)-c1)), k=k+1; % Handle c passing p(:,k) for k<n
  elseif (check & k==n & (c0-p(:,n))'*s0>0),               break  % Handle c passing p(:,n)
  else                                   % Handle other cases
    g=c0+ell*s0;                         % Goal point (ell meters ahead on current segment)
    if (check & (g-p(:,k))'*s0>0),       % Handle g passing p(:,k)
      g=p(:,k)+(ell-norm(p(:,k)-c0))*s1; %   [goal point moves over to next segment]
    end
    d=norm(g-x(1:2));       % Distance from robot's current location to goal point.
    delta=(g(1)-x(1))*sin(x(3))-(g(2)-x(2))*cos(x(3)); % Lateral distance to be moved when
                            % advancing from robot's current location to the goal point.
    gamma=-2*delta/d^2;     % 1/gamma = radius of curvature required to intercept goal.
    alphadot=gamma*(U*r); Udiff=K*(L/2)*alphadot/r;  % turn rate required to turn at desired radius
    plot(x(1),x(2),'rx'); plot(g(1),g(2),'gx'); pause(0.01);

    f1=RHS(x,U,Udiff);        f2=RHS(x+h*f1/2,U,Udiff);   % Simulate system with RK4
    f3=RHS(x+h*f2/2,U,Udiff); f4=RHS(x+h*f3,U,Udiff);     % (Replace this code chuck with
    x=x+h*(f1/6+(f2+f3)/3+f4/6); t=t+h;                   % application to actual system.)
  end
end

end % function RobotPath
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rhs=RHS(x,U,Udiff)                      % Auxiliary function used by RK4 routine
global r L; rhs=[r*U*cos(x(3)); r*U*sin(x(3)); r*Udiff/(L/2)];
end % function RHS
