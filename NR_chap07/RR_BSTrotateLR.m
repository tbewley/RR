function [D,q]=RC_BSTrotateLR(D,q)
% function [D,q]=RC_BSTrotateLR(D,q)
% Apply a left or right rotation at record q if such a rotation helps to balance the RC_BST.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_BSTinitialize, RC_BSTinsert, RC_BSTrotateL, RC_BSTrotateR, RC_BSTbalance, RC_BSTenumerate,
% RC_BSTsuccessor.  Verify with RC_BSTtest.

p=D(q,end-3); r=D(q,end-1);
if p>0, Dpg=D(p,end); pp=D(p,end-3); if pp>0, Dppg=D(pp,end); else, Dppg=-1; end
else, Dpg=-1; Dppg=-2; end
if r>0, Drg=D(r,end); rr=D(r,end-1); if rr>0, Drrg=D(rr,end); else, Drrg=-1; end
else, Drg=-1; Drrg=-2; end
if Dppg>Drg, [D,q]=RC_BSTrotateR(D,q); elseif Drrg>Dpg, [D,q]=RC_BSTrotateL(D,q); end
end % function RC_BSTrotateLR                               
