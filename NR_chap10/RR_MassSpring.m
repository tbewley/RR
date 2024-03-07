function [qs,es,ts]=RC_MassSpring(method,Tmax,max_iterations)
% function [qs,energy]=RC_MassSpring(method,Tmax,max_iterations)
% Simulate the evolution of an undamped mass-spring oscillator using method=SI4 or method=RK4.
% SIMPLE TEST: clear; global m k, m=1; k=1; Tmax=(2*pi)*20; [qs,es,ts]=RC_MassSpring('RK4',Tmax,Tmax*1);
%              figure(1), plot(ts,qs,'k*-'), hold on, figure(2), plot(ts,es,'k*-'), hold on
%              [qs,es,ts]=RC_MassSpring('SI4',Tmax,Tmax*1);
%              figure(1), plot(ts,qs,'ro-'),          figure(2), plot(ts,es,'ro-.')
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.6.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

global m k
h=Tmax/max_iterations; q=1; p=0; t=0; m, k
qs(1)=q; es(1)=CheckEnergy(p,q); ts(1)=t;
% Initialize constants for SI4 time marching method of Ruth
f=2^(1/3); c(1)=1/(2*(2-f)); c(4)=c(1); c(2)=(1-f)/(2*(2-f)); c(3)=c(2);
           d(1)=1/(2-f);     d(3)=d(1); d(2)=-f/(2-f);        d(4)=0; 
for i=1:max_iterations, t=i*h;                    % Now perform time march using SI4 or RK4
  if method=='SI4'
    for ss=1:4, q=q+c(ss)*h*dqdt(p);  if ss<4, p=p+d(ss)*h*dpdt(q); end, end % SI4
    % Note: the SI4 implementation above may be accelerated by combining the last substep
    % of each timestep with the first substep of the next, as suggested in the text.
  elseif method=='RK4'
    k1q=dqdt(p);                     k1p=dpdt(q);                           % RK4
    k2q=dqdt(p+(h/2)*k1p);           k2p=dpdt(q+(h/2)*k1q);
    k3q=dqdt(p+(h/2)*k2p);           k3p=dpdt(q+(h/2)*k2q);
    k4q=dqdt(p+h*k3p);               k4p=dpdt(q+h*k3q);
    q=q+h*(k1q/6+(k2q+k3q)/3+k4q/6); p=p+h*(k1p/6+(k2p+k3p)/3+k4p/6); 
  end
  qs(i+1)=q; es(i+1)=CheckEnergy(p,q); ts(i+1)=t;
end
end % function RC_MassSpringSimulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out] = dqdt(p);  % dq/dt=dT/dp
global m k
out=p/m;
end % function dqdt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out] = dpdt(q); % dp/dt=-dV/dq
global m k
out=-k*q;
end % function dpdt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function H=CheckEnergy(p,q);
global m k
T=p^2/(2*m); V=k*q^2/2; H=T+V;
end % function CheckEnergy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%