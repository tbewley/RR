function [D,b]=RR_BSTrotateR(D,d)
% function [D,b]=RR_BSTrotateR(D,d)
% Apply a right rotation to a RR_BST at record d (see Figure 7.7).  (RR_BSTrotateL is similar.)
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTrotateLR, RR_BSTrotateL, RR_BSTbalance, RR_BSTenumerate,
% RR_BSTsuccessor.  Trial: RR_BSTtest.

b=D(d,end-3); a=D(b,end-3); c=D(b,end-1); e=D(d,end-1); p=D(d,end-2);
if a>0, Dag=D(a,end);                else, Dag=-1; end 
if c>0, Dcg=D(c,end); D(c,end-2)=-d; else, Dcg=-1; end 
if e>0, Deg=D(e,end);                else, Deg=-1; end 
D(d,end-3)=c; D(d,end-2)=+b; D(d,end)=max(Dcg+1,Deg+1);
D(b,end-1)=d; D(b,end-2)=p;  D(b,end)=max(Dag+1,D(d,end)+1);
s=sign(p); p=abs(p); if p>0, D(p,end-2+s)=b; end
while p>0, a=D(p,end-3); if a>0, Dag=D(a,end); else, Dag=-1; end
           c=D(p,end-1); if c>0, Dcg=D(c,end); else, Dcg=-1; end, g=max(Dag+1,Dcg+1);
           if g<D(p,end), D(p,end)=g; p=abs(D(p,end-2)); else, p=0; end, end
end % function RR_BSTrotateR                               
