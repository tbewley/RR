function f=RR_RHS_ShallowWater_FD(y,p,t)          % Numerical Renaissance Codebase 1.0
% The RHS of the SWE, with u=y(:,:,1), v=y(:,:,2), h=y(:,:,3), approximated with FD.
% Note: this code takes k=nu=0.
for i=2:p.Nx, for j=2:p.Ny       % Interior
  f(i,j,1)=-y(i,j,1)*(y(i+1,j,1)-y(i-1,j,1))/p.dx2 ...
           -y(i,j,2)*(y(i,j+1,1)-y(i,j-1,1))/p.dy2 ...
           - p.g*((y(i+1,j,3)-p.b(i+1))-(y(i-1,j,3)-p.b(i-1)))/p.dx2;
  f(i,j,2)=-y(i,j,1)*(y(i+1,j,2)-y(i-1,j,2))/p.dx2 ...
           -y(i,j,2)*(y(i,j+1,2)-y(i,j-1,2))/p.dy2 ...
           - p.g*( y(i,j+1,3)          - y(i,j-1,3)          )/p.dy2;
  f(i,j,3)=-(y(i+1,j,3)*y(i+1,j,1)-y(i-1,j,3)*y(i-1,j,1))/p.dx2 ...
           -(y(i,j+1,3)*y(i,j+1,2)-y(i,j-1,3)*y(i,j-1,2))/p.dy2;
end, end

switch p.excitation_case          % Implement excitation from BCs.
  case 'earthquake'
    for j=1:p.Nyp                 % Boundaries in x
      f(1,    j,1)=p.epsilon_c*sin(p.omega*t);   f(1,    j,2)=p.epsilon_s*sin(p.omega*t);
      f(p.Nxp,j,1)=p.epsilon_c*sin(p.omega*t);   f(p.Nxp,j,2)=p.epsilon_s*sin(p.omega*t);
      f(1,    j,3)=f(2,   j,3)+p.dx*(p.omega*p.epsilon_c/p.g)*cos(p.omega*t);
      f(p.Nxp,j,3)=f(p.Nx,j,3)-p.dx*(p.omega*p.epsilon_c/p.g)*cos(p.omega*t);
    end
    for i=2:p.Nx                   % Boundaries in y
      f(i,1,    1)=p.epsilon_c*sin(p.omega*t);   f(i,1,    2)=p.epsilon_s*sin(p.omega*t);
      f(i,p.Nyp,1)=p.epsilon_c*sin(p.omega*t);   f(i,p.Nyp,2)=p.epsilon_s*sin(p.omega*t);
      f(i,1,    3)=f(i,2,    3)+p.dy*(p.omega*p.epsilon_s/p.g)*cos(p.omega*t);
      f(i,p.Nyp,3)=f(i,p.Nyp,3)-p.dy*(p.omega*p.epsilon_s/p.g)*cos(p.omega*t);
    end
  case 'rock'
    for j=2:p.Ny                   % Boundaries in x
      f(1,j,1)=0; f(p.Nxp,j,1)=0; f(1,j,3)=f(2,j,3); f(p.Nxp,j,3)=f(p.Nx,j,3);
      f(1,    j,2)=-y(1,    j,2)*(y(1,    j+1,2)-y(1,    j-1,2))/p.dy2-p.g*(y(1,    j+1,3)-y(1,    j-1,3))/p.dy2;
      f(p.Nxp,j,2)=-y(p.Nxp,j,2)*(y(p.Nxp,j+1,2)-y(p.Nxp,j-1,2))/p.dy2-p.g*(y(p.Nxp,j+1,3)-y(p.Nxp,j-1,3))/p.dy2;
    end
    for i=2:p.Nx                   % Boundaries in y
      f(i,1,2)=0; f(i,p.Nyp,2)=0; f(i,1,3)=f(i,2,3); f(i,p.Nyp,3)=f(i,p.Ny,3);
      f(i,1,  1)  =-y(i,1    ,1)*(y(i+1,1,    1)-y(i-1,1,    1))/p.dx2-p.g*((y(i+1,1,    3)-p.b(i+1))-(y(i-1,1,    3)-p.b(i-1)))/p.dx2;
      f(i,p.Nyp,1)=-y(i,p.Nyp,1)*(y(i+1,p.Nyp,1)-y(i-1,p.Nyp,1))/p.dx2-p.g*((y(i+1,p.Nyp,3)-p.b(i+1))-(y(i-1,p.Nyp,3)-p.b(i-1)))/p.dx2;
    end
    f(1,1,1)=0; f(1,p.Nyp,1)=0; f(p.Nxp,1,1)=0; f(p.Nxp,p.Nyp,1)=0; % Corners
    f(1,1,2)=0; f(1,p.Nyp,2)=0; f(p.Nxp,1,2)=0; f(p.Nxp,p.Nyp,2)=0;
    f(1,1,3)=f(2,2,3); f(1,p.Nyp,3)=f(2,p.Ny,3); f(p.Nxp,1,3)=f(p.Nx,2,3); f(p.Nxp,p.Nyp,3)=f(p.Nx,p.Ny,3);
  otherwise
    error('Unknown excitation method.')
end

end % function RR_RHS_ShallowWater_FD