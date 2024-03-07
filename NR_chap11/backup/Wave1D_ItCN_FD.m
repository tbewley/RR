function RC_Wave1D_ItCN_FD                              % Numerical Renaissance Codebase 1.0
% This script simulates the 1D Wave equation with periodic boundary conditions.
% Iterative CN timestepping is used with a FD method in space.
% ------------------ Initialize the simulation paramters (user input)  -------------------
L=4; Tmax=4; N=128; dt=0.01; dx=L/N; IterSteps=3;
t=0; c=1.0; x=(-N/2:N/2-1)'*dx; q=exp(-x.^2/0.1); v=0;
% --------------------------------- end user input ---------------------------------------
PlotXY(x,q,t,-L/2,L/2,-0.2,1.2); vs=v; a=dt*c^2/(2*dx^2); b=-dt*c^2/dx^2;  % initialize
for n=1:Tmax/dt
  for m=1:IterSteps
    qs=q+dt*(vs+v)/2;  vs=qs+q; vs=v+a*vs([N 1:N-1],1)+b*vs([1:N],1)+a*vs([2:N 1],1);
  end
  t=t+dt; q=qs; v=vs; PlotXY(x,q,t,-L/2,L/2,-0.2,1.2);
end
end % function RC_Wave1D_ItCN_FD