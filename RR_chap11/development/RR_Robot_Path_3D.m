function RobotPath3D
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap12
% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License. 

U=2;                  % target forward velocity (MKS units)
ell=.1;               % look ahead distance (increase for smoother, sloppier response)
p=[0 1 1 0;           % desired trajectory  (straight segments: columns are {x,y,z}  )
   0 1 0 1;
   0 1 0 0];
n=size(p,2);          % number of points on desired trajectory
k=2;                  % inital target point on trajectory
x=[0;.2;0;0;1;0];     % initial state x=[r_1,r_2,r_3,v_1,v_2,v_3] (r=position, v=velocity)
h=.1;  t=0;           % timestep and initial time for time-marching algorithm

close all; plot3(p(1,:),p(2,:),p(3,:),'bo-'); hold on; axis([-.1 1.1 -.1 1.1 -.1 1.1]);

for i=1:1000
  r=x(1:3); v=x(4:6);
  s0=p(:,k)-p(:,k-1); s0=s0/norm(s0);   % Unit vector along current trajectory segment
  c0=p(:,k-1)-((p(:,k-1)-r)'*s0)*s0;    % Closest point on current segment to robot
  if (norm(p(:,k)-c0)<ell), check=true, else, check=false; end
  if (check & k<n)
    s1=p(:,k+1)-p(:,k); s1=s1/norm(s1); % Unit vector along next trajectory segment.
    c1=p(:,k)-((p(:,k)-r)'*s1)*s1;      % Closest point on next segment to robot.
  end
  if     (check & k<n  & norm(r-c0)>norm(r-c1)), k=k+1; % Handle c0 passing p(:,k) for k<n
  elseif (check & k==n & (c0-p(:,n))'*s0>0),     break  % Handle c0 passing p(:,n)
  else                                                  % Handle other cases
    g=c0+ell*s0;                         % Goal point (ell meters ahead on current segment)
    if (check & (g-p(:,k))'*s0>0),       % Handle g passing p(:,k)
      g=p(:,k)+(ell-norm(p(:,k)-c0))*s1; %   [goal point moves over to next segment]
    end
    om=cross(r,g-x);
    if (norm(om)>1e-6)
      d=norm(g-x(1:3));       % Distance from robot's current location to goal point.
      delta1=(g(1)-x(1))*sin(x(3))-(g(2)-x(2))*cos(x(3)); % Lateral distance to be moved when
                               % advancing from robot's current location to the goal point,
                               % in the plane of projection to the local trajectory
        

      gamma1=2*delta1/d^2;     % 1/gamma1 = radius of curvature required to intercept goal in plane 1
      om=gamma1/U;             % turn rate required to turn at desired radius
    end
    
    plot3(x(1),x(2),x(3),'rx'); plot3(g(1),g(2),g(3),'gx'); pause(0.01);

    f1=RHS(x,U,om);        f2=RHS(x+h*f1/2,U,om);         % Simulate system with RK4
    f3=RHS(x+h*f2/2,U,om); f4=RHS(x+h*f3,U,om);
    x=x+h*(f1/6+(f2+f3)/3+f4/6); t=t+h;
  end
end

end % function RobotPath
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rhs=RHS(x,U,om)      % Auxiliary function used by RK4 routine
v=x(4:6); v=v*U/norm(v);      % The scalar U is the speed, vector om is the rotation rate
rhs=[v(1);v(2);v(3); om(2)*v(3)-om(3)*v(2); om(3)*v(1)-om(1)*v(3); om(1)*v(2)-om(2)*v(1)];
end % function RHS
