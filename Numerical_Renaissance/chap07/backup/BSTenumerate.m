function index=RR_BSTenumerate(D,r)
% function index=RR_BSTenumerate(D,r)
% Enumerate the records of a RR_BST from smallest to largest.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTrotateLR, RR_BSTrotateL, RR_BSTrotateR, RR_BSTbalance,
% RR_BSTsuccessor.  Trial: RR_BSTtest.

n=0; m=r; while D(m,end-3)>0, m=D(m,end-3); end
while m>0, n=n+1; index(n)=m; m=RR_BSTsuccessor(D,m); end
end % function RR_BSTenumerate                                   
