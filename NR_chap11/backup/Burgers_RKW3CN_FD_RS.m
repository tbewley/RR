function RC_Burgers_RKW3CN_FD_RS                        % Numerical Renaissance Codebase 1.0
% This function simulates Burgers equation with homogeneous Dirichlet BCs
% RKW3/CN timestepping is used (explicit on nonlinear terms, implicit on
% linear terms) with a 2nd-order central FD method in space.
% ---------- Initialize the simulation paramters (user input)  ----------
clear all;  L=100;  Tmax=50;  N=100;  dt=0.5; PlotInterval=1;  dx=L/N;
x=(0:N)*dx;  y=-sin(pi*x/L)-sin(2*pi*x/L)+sin(6*pi*x/L);  PlotXY(x,y,0,0,L,-3,3);
% --------------------------- end user input ---------------------------- 
% Precalculate the time-stepping coefficients used in the computation. 
h_bar = dt*[8/15 2/15  1/3];     d=h_bar/(2*dx^2);          a= -h_bar/(2*dx^2); 
beta_bar = [1    25/8  9/4];     e=beta_bar.*h_bar/(2*dx);  b=1+h_bar/dx^2;
zeta_bar = [0   -17/8 -5/4];     f=zeta_bar.*h_bar/(2*dx);  c= -h_bar/(2*dx^2);
% function RC_Burgers_RKW3CN_FD_RS                      % Numerical Renaissance Codebase 1.0
% (... first 12 lines are identical to those in RC_Burgers_RKW3CN_FD.m ...)
for k=1:Tmax/dt                                        
   %%%%%%%%%%%%%%%%%%%%%%%% FIRST RK STEP %%%%%%%%%%%%%%%%%%%%%%%%
   % Compute nonlinear term r(y)           
   % (defer scaling by coefficient, result stored in z)             % Leading-order cost:
   z(2:N)=-y(2:N).*(y(3:N+1)-y(1:N-1));                                   % ~ 2N
   % Compute entire RHS (result stored in y)
   y(2:N)=y(2:N) + d(1)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) + e(1)*z(2:N);       % ~ 7N
   % Solve for y at end of first RK step (result stored in y)
   y(2:N)=RC_ThomasTT(a(1),b(1),c(1),y(2:N)',N-1);                           % ~ 8N
   %%%%%%%%%%%%%%%%%%%%%%%% SECOND RK STEP %%%%%%%%%%%%%%%%%%%%%%%%
   % Compute entire RHS, including the computation of r(y)
   % (result stored in z)
   z(2:N)=y(2:N) + d(2)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) - ...                % ~ 11N
          e(2)*y(2:N).*(y(3:N+1)-y(1:N-1)) + f(2)*z(2:N);
   % TRICK: now RECOMPUTE nonlinear term r(y)
   % (defer scaling, result stored in y)
   y(2:N)=-y(2:N).*(y(3:N+1)-y(1:N-1));                                   % ~ 2N
   % Solve for y at end of second RK step (result stored in z)
   z(2:N)=RC_ThomasTT(a(2),b(2),c(2),z(2:N)',N-1);  z(N+1)=0;                % ~ 8N
   %%%%%%%%%%%%%%%%%%%%%%%% THIRD RK STEP %%%%%%%%%%%%%%%%%%%%%%%%
   % Compute entire RHS, including the computation of r(y)
   % (result stored in y)
   y(2:N)=z(2:N) + d(3)*(z(3:N+1)-2*z(2:N)+z(1:N-1)) - ...                % ~ 11N
          e(3)*z(2:N).*(z(3:N+1)-z(1:N-1)) + f(3)*y(2:N); 
   % Solve for y at new timestep (result stored in y)
   y(2:N)=RC_ThomasTT(a(3),b(3),c(3),y(2:N)',N-1);                           % ~ 8N
   if (mod(k,PlotInterval)==0) PlotXY(x,y,k*dt,0,L,-3,3); end
   %%%%%%%%%%%%%%%%%%%%%%%% END OF RK LOOP %%%%%%%%%%%%%%%%%%%%%%%%     --------------
end                                                                     % Total: ~ 57N
end % function RC_Burgers_RKW3CN_FD_RS.m
