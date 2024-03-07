function [D,q]=RR_BSTbalance(D,q)
% function [D,q]=RR_BSTbalance(D,q)
% Scan once through all records of a RR_BST that are at least grandparents, and apply a left
% or right rotation to each such record only if such a rotation shortens that subtree.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTrotateLR, RR_BSTrotateL, RR_BSTrotateR, RR_BSTenumerate,
% RR_BSTsuccessor.  Verify with RR_BSTtest.

[D,q]=RR_BSTrotateLR(D,q);
p=D(q,end-3); if p>0 & D(p,end)>1, [D,p]=RR_BSTbalance(D,p); end  
r=D(q,end-1); if r>0 & D(r,end)>1, [D,r]=RR_BSTbalance(D,r); end
end % function RR_BSTbalance                                 
