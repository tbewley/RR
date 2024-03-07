function RR_BSTplot(D,r,x,y)
% function RR_BSTplot(D,r,x,y)
% Plot a RR_BST so that the user can understand its structure and watch it evolve.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTrotateLR, RR_BSTrotateL, RR_BSTrotateR, RR_BSTbalance,
% RR_BSTenumerate, RR_BSTsuccessor.  Verify with RR_BSTtest.

if nargin==2;
  x=0; y=0; figure(2); clf; axis([-4.09 4.09 -10.21 0.5]); axis off; hold on;
end
s=D(r,end-3); if s>0; xn=x-1/2^(y-1); plot([x xn],[-y -y-1]); RR_BSTplot(D,s,xn,y+1), end
s=D(r,end-1); if s>0; xn=x+1/2^(y-1); plot([x xn],[-y -y-1]); RR_BSTplot(D,s,xn,y+1), end
fill([-.1 .1 .1 -.1]+x,[.2 .2 -.2 -.2]-y,'y'), text(x-0.04,-y,sprintf('%2d',D(r,end)))
end % function RR_BSTplot                                   
