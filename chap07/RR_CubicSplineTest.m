% script <a href="matlab:RR_CubicSplineTest">RR_CubicSplineTest</a>
% Test <a href="matlab:help RR_CubicSpline">RR_CubicSpline</a> on data from a smooth nonperiodic function.
%% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

close all, clear, L=4*pi; xmin=0; xmax=L; ep=.0001;
xd=[xmin:L/10:xmax]; fd=sin(xd+ep)./(xd+ep); x=[xmin:L/1000:xmax]; f=sin(x+ep)./(x+ep);
[g1,h]=RR_CubicSplineSetup(xd,fd,'parabolic'); [CS1,CS1x]=RR_CubicSpline(x,xd,fd,g1,h); 
[g2,h]=RR_CubicSplineSetup(xd,fd,'natural');   [CS2,CS2x]=RR_CubicSpline(x,xd,fd,g2,h); 
[g3,h]=RR_CubicSplineSetup(xd,fd,'periodic');  [CS3,CS3x]=RR_CubicSpline(x,xd,fd,g3,h); 
figure(1);
plot(xd,fd,'k+',x,f,'k--',x,CS1,'b-',x,CS2,'r-',x,CS3,'g-'); axis([0 L -.25 1.05])
fx=cos(x+ep)./(x+ep) - sin(x+ep)./(x+ep).^2; figure(2);
plot(x,fx,'k--',x,CS1x,'b-',x,CS2x,'r-',x,CS3x,'g-'); % axis([0 L -.25 1.05])

% end script RR_CubicSplineTest
