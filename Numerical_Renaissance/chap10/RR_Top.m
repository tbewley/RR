function Top(theta0,phidot0,deflection,p,s)
% function Top(theta0,phidot0,deflection,p,s)
% RK4 simulation of a top initially set up in steady precession at initial angle theta0
% and initial spin rate phidot0, then impulsively perturbed in thetadot by an amount
% proportional to deflection (deflection=0 gives steady precession, deflection=1 gives
% cuspidial nutation).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

% Calculate derived physical constants
p.gam=2*p.m*p.g*p.L/p.Ip;
% Calculate derived constants from initial conditions.  We will select the initial
% precession rate psidot0, for the given axis angle theta0 and initial spin rate phidot0,
% to correspond to the slow steady precession rate.
psidotminus=(p.I*phidot0-sqrt(p.I^2*phidot0^2-2*(p.Ip-p.I)*p.Ip*p.gam*cos(theta0)))/ ...
            (2*(p.Ip-p.I)*cos(theta0));
psidotplus =(p.I*phidot0+sqrt(p.I^2*phidot0^2-2*(p.Ip-p.I)*p.Ip*p.gam*cos(theta0)))/ ...
            (2*(p.Ip-p.I)*cos(theta0));
if abs(psidotminus)<abs(psidotplus), psidot0=psidotminus, else, psidot0=psidotplus, end
p.betaphi=p.I*(psidot0*cos(theta0)+phidot0)/p.Ip;
p.betapsi=psidot0*sin(theta0)^2+p.betaphi*cos(theta0);
u0=p.betapsi/p.betaphi;  % Now calculate theta2, which is the min theta when the system
theta2=acos(u0);         % initialized above is deflected into cuspidial motion.
thetainit=theta0+(theta2-theta0)*deflection;
x=[thetainit; 0; 0; 0]; % Initialize x vector with components {theta,thetadot,psi,phi}.
t=0; k=0; while x(3)<2*pi, k=k+1;           % March over the necessary number of timesteps
  % Save a bunch of useful stuff for plotting later.
  t_save(k)=t; x_save(:,k)=x; E_save(k,1)=Energy(x,p);
  psidot_save(k)=(p.betapsi-p.betaphi*cos(x(1)))/sin(x(1))^2; 
  % Now march the system one timestep using the classical RK4 method.
  f1=RHS(x,p); f2=RHS(x+s.h*f1/2,p); f3=RHS(x+s.h*f2/2,p); f4=RHS(x+s.h*f3,p);
  x=x+s.h*(f1/6+(f2+f3)/3+f4/6); t=t+s.h;
end, t
x=sin(x_save(1,:)).*cos(x_save(3,:)); y=sin(x_save(1,:)).*sin(x_save(3,:));
z=cos(x_save(1,:)); x_save=x_save*180/pi; psidot_save=psidot_save*180/pi; N=s.Nplot; 
figure(1); clf, plot3(x,y,z), hold on, 
plot3(0,0,0,'b+'), if theta0<pi/2, plot3(0,0,1,'b.'), else plot3(0,0,-1,'b.'), end
axis square, axis tight, view(-14.5,10)
figure(2); clf, subplot(6,1,1), plot(t_save(1:N),x_save(1,1:N)), ylabel('theta')
subplot(6,1,2), plot(t_save(1:N),x_save(2,1:N)),    ylabel('thetadot')
subplot(6,1,3), plot(t_save(1:N),x_save(3,1:N)),    ylabel('psi')
subplot(6,1,4), plot(t_save(1:N),x_save(4,1:N)),    ylabel('phi')
subplot(6,1,5), plot(t_save(1:N),psidot_save(1:N)), ylabel('psidot')
                hold on, plot(t_save(1:N),0)
subplot(6,1,6), plot(t_save(1:N),E_save(1:N)),      ylabel('E'),
end % function top
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=RHS(x,p)
f(1,1)=x(2);
f(2,1)=-(p.betapsi-p.betaphi*cos(x(1)))*(p.betaphi-p.betapsi*cos(x(1)))/sin(x(1))^3+...
       p.m*p.g*p.L*sin(x(1))/p.Ip;
f(3,1)=(p.betapsi-p.betaphi*cos(x(1)))/sin(x(1))^2;
f(4,1)=(p.betaphi*(p.Ip*sin(x(1))^2+p.I*cos(x(1))^2)-p.betapsi*p.I*cos(x(1)))/...
       (p.I*sin(x(1))^2);
end % function RHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function E=Energy(x,p)
E=p.Ip^2*p.betaphi^2/(2*p.I)+p.m*p.g*p.L*cos(x(1)) + ...
  0.5*p.Ip*x(2)^2+0.5*p.Ip*(p.betapsi-p.betaphi*cos(x(1)))^2/sin(x(1))^2;
end % function Energy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
