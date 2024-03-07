function index=RC_BSTenumerate(D,r)
% function index=RC_BSTenumerate(D,r)
% Enumerate the records of a RC_BST from smallest to largest.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_BSTinitialize, RC_BSTinsert, RC_BSTrotateLR, RC_BSTrotateL, RC_BSTrotateR, RC_BSTbalance,
% RC_BSTsuccessor.  Verify with RC_BSTtest.

n=0; m=r; while D(m,end-3)>0, m=D(m,end-3); end
while m>0, n=n+1; index(n)=m; m=RC_BSTsuccessor(D,m); end
end % function RC_BSTenumerate                                   
