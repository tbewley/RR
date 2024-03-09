function index=RR_BSTenumerate(D,r)
% function index=RR_BSTenumerate(D,r)
% Enumerate the records of a RR_BST from smallest to largest.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTrotateLR, RR_BSTrotateL, RR_BSTrotateR, RR_BSTbalance,
% RR_BSTsuccessor.  Trial: RR_BSTtest.

n=0; m=r; while D(m,end-3)>0, m=D(m,end-3); end
while m>0, n=n+1; index(n)=m; m=RR_BSTsuccessor(D,m); end
end % function RR_BSTenumerate                                   
