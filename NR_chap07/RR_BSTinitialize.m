function [D,r]=RR_BSTinitialize(D)
% function [D,r]=RR_BSTinitialize(D)
% Initialize a RR_BST based on a list of records D with markers in the first column.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_BSTinsert, RR_BSTrotateLR, RR_BSTrotateL, RR_BSTrotateR, RR_BSTbalance, RR_BSTenumerate,
% RR_BSTsuccessor.  Trial: RR_BSTtest.

[n,m]=size(D); D=[D zeros(n,5)]; r=1;
for i=2:n, [D,r]=RR_BSTinsert(D,i,r); if mod(i,1)==0, RR_BSTplot(D,r), pause(.01), end, end
disp('Press any key to do final balancing.  If balancing during insertion was adequate,')
disp('this step will not do that much...'); pause; [D,r]=RR_BSTbalance(D,r); RR_BSTplot(D,r)
end % function RR_BSTinitialize                                   
