function [p]=RR_BSTpredecessor(D,r)
% function [p]=RR_BSTpredecessor(D,r)
% ???
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTdelete, RR_BSTenumerate. Trial: RR_BSTtest.

p=D(r,end-3); if p>0, while D(p,end-1)>0, p=D(p,end-1); end
else, p=r; while D(p,end-2)<0, p=abs(D(p,end-2)); end
end % function RR_BSTpredecessor                               
