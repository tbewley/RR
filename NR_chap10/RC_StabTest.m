% script <a href="matlab:StabContours">StabTest</a>
% Plot stability contours of several ODE marching methods in the complex plane lambda*h.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.2.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear; Np=201; V=[1 1.0000000001]; close all; n=[1/24 1/50 1/53 1/54 1/55 1/56 1/60];
B=[ -7; 1; -4; 4]; % region in the sigma plane to plot the stability boundary

for k=1:length(n); clear sig
    LR(:,1)=[B(1):(B(2)-B(1))/(Np-1):B(2)]'; LI(:,1)=[B(3):(B(4)-B(3))/(Np-1):B(4)]';
  for j=1:Np, for i=1:Np,  L=LR(j)+sqrt(-1)*LI(i);
    sig(i,j)=abs(1+L+L^2/2+L^3/6+n(k)*L^4);
  end, end
  figure(k), contourf(LR,LI,1./sig,V,'k-'), colormap autumn, axis('square'), hold on
  plot([B(1) B(2)],[0,0],'k-'), plot([0,0],[B(3) B(4)],'k-')
  z=-7:.01:0; sig=(1+z+z.^2/2+z.^3/6+n(k)*z.^4);
  figure(10), if n(k)<1/54, s='k--'; elseif n(k)>1/54, s='k-.'; else, s='k-'; end
  plot(z,sig,s); hold on;
end
figure(10), plot([-7 0],[1 1],'k--',[-7 0],[-1 -1],'k--'); axis([-7 0 -2 2]); 


% end script StabTest
