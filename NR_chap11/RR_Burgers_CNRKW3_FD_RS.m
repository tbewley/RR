function RC_Burgers_CRCKW3_FD_RS
% function <a href="matlab:RC_Burgers_CRCKW3_FD_RS">RC_Burgers_CRCKW3_FD_RS</a>
% Simulate the 1D Burgers on 0<x<L with homogeneous Dirichlet BCs using CN/RKW3 in time
% (explicit on nonlinear terms, implicit on linear terms) & 2nd-order central FD in space.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 11.2.1.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap11">Chapter 11</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_Burgers_CRCKW3_FD, with 3 registers & 55 flops/timestep (instead of 2 & 57),
% and RC_Burgers_KS_CRCKW3_PS with a pseudospectral implementation.

%%%%%%%%%%%%%%%%%%%% Initialize the simulation paramters (user input) %%%%%%%%%%%%%%%%%%%%
clear all;  L=100;  Tmax=50;  N=100;  dt=0.5; PlotInterval=1;  dx=L/N;
x=(0:N)*dx;  y=-sin(pi*x/L)-sin(2*pi*x/L)+sin(6*pi*x/L);  RC_PlotXY(x,y,0,0,L,-3,3);
%%%%%%%%%%%% Precalculate the time-stepping coefficients used in the simulation %%%%%%%%%%
h_bar = dt*[8/15 2/15  1/3];     d=h_bar/(2*dx^2);          a= -h_bar/(2*dx^2); 
beta_bar = [1    25/8  9/4];     e=beta_bar.*h_bar/(2*dx);  b=1+h_bar/dx^2;
zeta_bar = [0   -17/8 -5/4];     f=zeta_bar.*h_bar/(2*dx);  c= -h_bar/(2*dx^2);
% (... initialization identical to that in RC_Burgers_RKW3CN_FD ...)
for k=1:Tmax/dt                                        
   %%%%%%%%%%%%%%%%%%%%%%%% FIRST RK STEP %%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Compute nonlinear term r(y), and defer scaling until next step %  Leading-order cost:
   z(2:N)=-y(2:N).*(y(3:N+1)-y(1:N-1));                                        % ~ 2N
   % Compute the entire RHS, and apply all the correct scalings
   y(2:N)=y(2:N) + d(1)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) + e(1)*z(2:N);            % ~ 7N
   % Solve for y at end of first RK step
   y(2:N)=RC_ThomasTT(a(1),b(1),c(1),y(2:N)',N-1);                                % ~ 8N
   %%%%%%%%%%%%%%%%%%%%%%%% SECOND RK STEP %%%%%%%%%%%%%%%%%%%%%%%%%%
   % Compute the entire RHS, including r(y).
   z(2:N)=y(2:N) + d(2)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) - ...                     % ~ 11N
          e(2)*y(2:N).*(y(3:N+1)-y(1:N-1)) + f(2)*z(2:N);
   % TRICK: now RECOMPUTE r(y) for use at the final RK step.
   y(2:N)=-y(2:N).*(y(3:N+1)-y(1:N-1));                                        % ~ 2N
   % Solve for y at end of second RK step
   z(2:N)=RC_ThomasTT(a(2),b(2),c(2),z(2:N)',N-1);  z(N+1)=0;                     % ~ 8N
   %%%%%%%%%%%%%%%%%%%%%%%% THIRD RK STEP %%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Compute entire RHS, including the computation of r(y)
   y(2:N)=z(2:N) + d(3)*(z(3:N+1)-2*z(2:N)+z(1:N-1)) - ...                     % ~ 11N
          e(3)*z(2:N).*(z(3:N+1)-z(1:N-1)) + f(3)*y(2:N); 
   % Solve for y at the new timestep
   y(2:N)=RC_ThomasTT(a(3),b(3),c(3),y(2:N)',N-1);                                % ~ 8N
   if (mod(k,PlotInterval)==0) RC_PlotXY(x,y,k*dt,0,L,-3,3); end            
   %%%%%%%%%%%%%%%%%%%%%%%% END OF RK LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%   --------------
end                                                                     % Total: ~ 57N
end % function RC_Burgers_CRCKW3_FD_RS
