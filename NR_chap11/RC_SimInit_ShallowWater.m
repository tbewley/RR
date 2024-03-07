function [h,T,y,p]=RC_SimInit_ShallowWater(v)  % Numerical Renaissance Codebase 1.0  
T=500; h=0.0001; p.Nx=50; p.Ny=25; p.g=9.8;    % Simulation paramters
p.Lx=50; p.Ly=25; p.b_max=3; p.b_min=2;        % Dimensions and depth of pool 
p.excitation_case='earthquake';                % Which excitation case to consider
p.epsilon=0.1; p.omega; p.phi=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p.dx=p.Lx/p.Nx; p.dy=p.Ly/p.Ny; p.Nxp=p.Nx+1; p.Nyp=p.Ny+1; p.dx2=2*p.dx; p.dy2=2*p.dy;
p.x=[0:p.dx:p.Lx]; p.y=[0:p.dy:p.Ly];
p.b=(p.b_max+p.b_min)/2-(p.b_max-p.b_min)/2*tanh([-5:(10/p.Nx):5]); % Smooth bottom shape
p.bb=p.b'*ones(1,p.Nyp);                       % Bottom of pool as a (convenient) 2D array

switch p.excitation_case          % Implement excitation from ICs.
  case 'earthquake'
    y(1:p.Nxp,1:p.Nyp,1:3)=0;
    p.epsilon_c=p.epsilon*cos(phi); p.epsilon_s=p.epsilon*sin(phi); % (parameters later used in BC forcing.)
  case 'rock'
    y(1:p.Nxp,1:p.Nyp,1:2)=0;
    height=1.0; tightness=1.5;
    for i=1:p.Nxp, for j=1:p.Nyp
      y(i,j,3)=p.b(i)-height*exp(-tightness*((p.x(i)-p.Lx/3)^2+(p.y(j)-p.Ly/2)^2));
    end, end
  otherwise
    error('Unknown excitation method.')
end

map=colormap('jet'); colormap(map(end:-1:1,:)); SimPlot(y,y,0,0,h,h,v,p,0); pause(1);
end % function RC_SimInit_ShallowWater.m
