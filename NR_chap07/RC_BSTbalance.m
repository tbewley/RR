function [D,q]=RC_BSTbalance(D,q)
% function [D,q]=RC_BSTbalance(D,q)
% Scan once through all records of a RC_BST that are at least grandparents, and apply a left
% or right rotation to each such record only if such a rotation shortens that subtree.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_BSTinitialize, RC_BSTinsert, RC_BSTrotateLR, RC_BSTrotateL, RC_BSTrotateR, RC_BSTenumerate,
% RC_BSTsuccessor.  Verify with RC_BSTtest.

[D,q]=RC_BSTrotateLR(D,q);
p=D(q,end-3); if p>0 & D(p,end)>1, [D,p]=RC_BSTbalance(D,p); end  
r=D(q,end-1); if r>0 & D(r,end)>1, [D,r]=RC_BSTbalance(D,r); end
end % function RC_BSTbalance                                 
