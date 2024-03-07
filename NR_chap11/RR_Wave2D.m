function RC_Wave2D
% This code performs a simulation of a the excitation of surface waves in an
% olypic size swimming pool, by an earthquake which moves its walls, as formulated
% (using the shallow water equations) in the 2023 MAE207 final exam, available here:
%        http://robotics.ucsd.edu/mae207/final_207_22.pdf
% Numerical Robotics codebase, https://github.com/tbewley/RC/NRchap11
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.
T=500; h=0.002; p.Nx=10; p.Ny=50; p.g=9.8; v=true;  % Simulation paramters
p.Lx=50; p.Ly=25; p.b_max=3; p.b_min=3;             % Dimensions and depth of pool 
p.excitation_case='earthquake';                     % Which excitation case to consider
%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p.dx=p.Lx/p.Nx; p.dy=p.Ly/p.Ny; p.Nxp=p.Nx+1; p.Nyp=p.Ny+1; p.dx2=2*p.dx; p.dy2=2*p.dy;
p.x=[0:p.dx:p.Lx]; p.y=[0:p.dy:p.Ly];
p.b=(p.b_max+p.b_min)/2-((p.b_max-p.b_min)/2)*tanh([-5:(10/p.Nx):5]); % Smooth bottom shape
p.bb=p.b'*ones(1,p.Nyp);                       % Bottom of pool as a (convenient) 2D array

switch p.excitation_case                       % Implement excitation from ICs.
  case 'earthquake'
    p.epsilon=0.5; p.omega=1; p.phi=pi/2;
    y(1:p.Nxp,1:p.Nyp,1:2)=0;
    for i=1:p.Nxp, y(i,1:p.Nyp,3)=p.b(i); end
    p.epsilon_c=p.epsilon*cos(p.phi); p.epsilon_s=p.epsilon*sin(p.phi); % (parameters later used in BC forcing.)
  case 'rock'
    y(1:p.Nxp,1:p.Nyp,1:2)=0;
    height=2.0; tightness=2;
    for i=1:p.Nxp, for j=1:p.Nyp
      y(i,j,3)=p.b(i)-height*exp(-tightness*((p.x(i)-p.Lx/3)^2+(p.y(j)-p.Ly/2)^2));
    end, end
  otherwise
    error('Unknown excitation method.')
end
map=colormap('jet'); colormap(map(end:-1:1,:)); SimPlot(y,y,0,0,h,h,v,p,0); pause(1);
t=0; if v, y_old=y; end
for n=1:T/h;                                   % Now do the RK4 simulation
  f1=RHS(y,p,t); f2=RHS(y+h*f1/2,p,t); f3=RHS(y+h*f2/2,p,t); f4=RHS(y+h*f3,p,t);
  y=y+h*(f1/6+(f2+f3)/3+f4/6); t=t+h;
  if v & mod(n,20)==0, SimPlot(y_old,y,t-h,t,h,h,v,p,h); y_old=y; end
end
end % function RC_Wave2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=RHS(y,p,t)
% The RHS of the SWE, with u=y(:,:,1), v=y(:,:,2), h=y(:,:,3), approximated with FD.
% Note: this code takes k=0.
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
      f(i,1,    3)=f(i,2,   3)+p.dy*(p.omega*p.epsilon_s/p.g)*cos(p.omega*t);
      f(i,p.Nyp,3)=f(i,p.Ny,3)-p.dy*(p.omega*p.epsilon_s/p.g)*cos(p.omega*t);
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
  otherwise
    error('Unknown excitation method.')
end
f(1,1,3)        =(f(1,2,3)       +f(2,1,3)       )/2;    % Fix corners
f(1,p.Nyp,3)    =(f(1,p.Ny,3)    +f(2,p.Nyp,3)   )/2;
f(p.Nxp,1,3)    =(f(p.Nxp,2,3)   +f(p.Nx,1,3)    )/2;
f(p.Nxp,p.Nyp,3)=(f(p.Nxp,p.Ny,3)+f(p.Nx,p.Nyp,3))/2;
end % function RHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SimPlot(f,fnew,t,tnew,h,hnew,v,p,TimeStep)
figure(1); clf;
surf([0 p.Ly],p.x,[-p.b(:), -p.b(:)]); hold on;
surf(p.y,     p.x,f(:,:,3) - p.bb);
axis equal; axis([0 p.Ly 0 p.Lx -p.b_max 2]); pause(0.01);
if v==2, fn=['waves/f' num2str(1000000+TimeStep) '.tiff']; % print('-dtiff','-r100',fn);
end
end % function SimPlot

