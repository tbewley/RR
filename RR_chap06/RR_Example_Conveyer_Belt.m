function RR_Example_Conveyer_Belt
% function RR_Example_Conveyer_Belt
% Simulates the motion of the elastic conveyer belt system, initially at rest and centered,
% with a unit step input to phi, using an RK4 method with reduced timestep where neceesary.
%% Renaissance Robotics codebase, Chapter 6, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

p.m=1; p.g=9.8; p.r=0.1; p.muk=0.5; p.mus=1.0; p.ko=500; p.L=10; h=0.02; figure(1); clf;
x=[0; 0]; t=0; xs=x; ts=t; while x<0.95*p.L/2
  if x(2)==0, % If mass is stuck, compute the time when the mass becomes unstuck.
    ybar=p.r*t; for i=1:4;  % (Iterate a few times to solve the necessary nonlinear eqn.)     
      tnew=(x(1)+p.mus*p.m*p.g/(p.ko/(p.L/2-ybar)+p.ko/(3*p.L/2+ybar)))/p.r; ybar=p.r*tnew;
    end, xnew=[x(1); eps];
  else        % Otherwise, if mass is unstuck, march the system over one timestep h.
    f1=R(x,t,p); f2=R(x+f1*h/2,t+h/2,p); f3=R(x+f2*h/2,t+h/2,p); f4=R(x+f3*h,t+h,p);
    xnew=x+h*(f1/6+(f2+f3)/3+f4/6); tnew=t+h;
    if xnew(2)<0    % Redo time march over a shorter step h1 if speed of mass has reversed;
      frac=x(2)/(x(2)-xnew(2)); h1=frac*h; % the mass ends the timestep stuck in this case.
      f1=R(x,t,p); f2=R(x+f1*h1/2,t+h1/2,p); f3=R(x+f2*h1/2,t+h1/2,p); f4=R(x+f3*h1,t+h1,p);
      xnew=x+h1*(f1/6+(f2+f3)/3+f4/6); tnew=t+h1; xnew(2)=0;
    end
  end
  ts=[ts t]; xs=[xs x]; x=xnew; t=tnew;
end
subplot(2,1,1), plot(ts,xs(1,:)), axis tight, subplot(2,1,2); plot(ts,xs(2,:)), axis tight
end % function Example_17_3 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=R(x,t,p)
ybar=p.r*t; ypert=x(1)-ybar; l1=p.L/2-x(1); l2=3*p.L/2+x(1);
fbelt=-ypert*(p.ko/l1+p.ko/l2); ffriction=-p.muk*p.m*p.g; f=[x(2); fbelt+ffriction];
end % function R
