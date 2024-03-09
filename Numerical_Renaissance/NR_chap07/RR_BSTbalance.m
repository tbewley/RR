function [D,q]=RR_BSTbalance(D,q)
% function [D,q]=RR_BSTbalance(D,q)
% Scan once through all records of a RR_BST that are at least grandparents, and apply a left
% or right rotation to each such record only if such a rotation shortens that subtree.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTrotateLR, RR_BSTrotateL, RR_BSTrotateR, RR_BSTenumerate,
% RR_BSTsuccessor.  Trial: RR_BSTtest.

[D,q]=RR_BSTrotateLR(D,q);
p=D(q,end-3); if p>0 & D(p,end)>1, [D,p]=RR_BSTbalance(D,p); end  
r=D(q,end-1); if r>0 & D(r,end)>1, [D,r]=RR_BSTbalance(D,r); end
end % function RR_BSTbalance                                 
