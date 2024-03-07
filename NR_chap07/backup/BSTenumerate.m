function index=RC_BSTenumerate(D,r)
% function index=RC_BSTenumerate(D,r)
% Enumerate the records of a RC_BST from smallest to largest.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_BSTinitialize, RC_BSTinsert, RC_BSTrotateLR, RC_BSTrotateL, RC_BSTrotateR, RC_BSTbalance,
% RC_BSTsuccessor.  Verify with RC_BSTtest.

n=0; m=r; while D(m,end-3)>0, m=D(m,end-3); end
while m>0, n=n+1; index(n)=m; m=RC_BSTsuccessor(D,m); end
end % function RC_BSTenumerate                                   
