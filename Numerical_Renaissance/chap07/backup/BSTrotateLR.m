function [D,q]=RR_BSTrotateLR(D,q)
% function [D,q]=RR_BSTrotateLR(D,q)
% Apply a left or right rotation at record q if such a rotation helps to balance the RR_BST.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTrotateL, RR_BSTrotateR, RR_BSTbalance, RR_BSTenumerate,
% RR_BSTsuccessor.  Trial: RR_BSTtest.

p=D(q,end-3); r=D(q,end-1);
if p>0, Dpg=D(p,end); pp=D(p,end-3); if pp>0, Dppg=D(pp,end); else, Dppg=-1; end
else, Dpg=-1; Dppg=-2; end
if r>0, Drg=D(r,end); rr=D(r,end-1); if rr>0, Drrg=D(rr,end); else, Drrg=-1; end
else, Drg=-1; Drrg=-2; end
if Dppg>Drg, [D,q]=RR_BSTrotateR(D,q); elseif Drrg>Dpg, [D,q]=RR_BSTrotateL(D,q); end
end % function RR_BSTrotateLR                               
