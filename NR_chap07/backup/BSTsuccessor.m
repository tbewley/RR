function [s]=RC_BSTsuccessor(D,r)
% function [s]=RC_BSTsuccessor(D,r)
% Find the in-order successor record, s, of a given record r of a RC_BST.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_BSTinitialize, RC_BSTinsert, RC_BSTrotateLR, RC_BSTrotateL, RC_BSTrotateR, RC_BSTbalance,
% RC_BSTenumerate.  Verify with RC_BSTtest.

s=D(r,end-1); if s>0, while D(s,end-3)>0, s=D(s,end-3); end
else, s=D(r,end-2); while s>0, s=D(s,end-2); end, s=abs(s);
end % function RC_BSTsuccessor                                 
