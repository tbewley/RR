% script <a href="matlab:RC_CubicSplineTest">RC_CubicSplineTest</a>
% Test <a href="matlab:help RC_CubicSpline">RC_CubicSpline</a> on data from a smooth nonperiodic function.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.3.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

close all, clear, L=4*pi; xmin=0; xmax=L; ep=.0001;
xd=[xmin:L/10:xmax]; fd=sin(xd+ep)./(xd+ep); x=[xmin:L/1000:xmax]; f=sin(x+ep)./(x+ep);
[g1,h]=RC_CubicSplineSetup(xd,fd,'parabolic'); [CS1,CS1x]=RC_CubicSpline(x,xd,fd,g1,h); 
[g2,h]=RC_CubicSplineSetup(xd,fd,'natural');   [CS2,CS2x]=RC_CubicSpline(x,xd,fd,g2,h); 
[g3,h]=RC_CubicSplineSetup(xd,fd,'periodic');  [CS3,CS3x]=RC_CubicSpline(x,xd,fd,g3,h); 
figure(1);
plot(xd,fd,'k+',x,f,'k--',x,CS1,'b-',x,CS2,'r-',x,CS3,'g-'); axis([0 L -.25 1.05])
fx=cos(x+ep)./(x+ep) - sin(x+ep)./(x+ep).^2; figure(2);
plot(x,fx,'k--',x,CS1x,'b-',x,CS2x,'r-',x,CS3x,'g-'); % axis([0 L -.25 1.05])

% end script RC_CubicSplineTest
