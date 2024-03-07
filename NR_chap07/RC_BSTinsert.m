function [D,r]=RC_BSTinsert(D,n,r)
% function [D,r]=RC_BSTinsert(D,n,r)
% Insert record n into a RC_BST in D with root r, balancing the affected ancestors as needed.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_BSTinitialize, RC_BSTrotateLR, RC_BSTrotateL, RC_BSTrotateR, RC_BSTbalance, RC_BSTenumerate,
% RC_BSTsuccessor.  Verify with RC_BSTtest.

flag=1; m=r; while flag, if D(n,1)<D(m,1) % Find appropriate open child slot & place record
  if D(m,end-3)==0, D(m,end-3)=n; D(n,end-2)=-m; flag=0; else, m=D(m,end-3); end
else
  if D(m,end-1)==0, D(m,end-1)=n; D(n,end-2)=+m; flag=0; else, m=D(m,end-1); end
end, end
flag=1; while m>0 & flag                  % Scan through ancestors of inserted record,
  gold=D(m,end); [D,m]=RC_BSTrotateLR(D,m);  % rotate if helpful to keep balanced,
  a=D(m,end-3); if a>0, Dag=D(a,end); else, Dag=-1; end  % and update generation count.
  c=D(m,end-1); if c>0, Dcg=D(c,end); else, Dcg=-1; end, g=max(Dag+1,Dcg+1);
  D(m,end)=g; n=m; m=abs(D(n,end-2));     % Exit loop if generation count at this level
  if g==gold, flag=0; end                 % is unchanged by the insertion.
end                                       
if m==0; r=n; end      % If scanned all the way back to root, the root might have changed.
end % function RC_BSTinsert                                   
