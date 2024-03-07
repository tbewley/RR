% script <a href="matlab:RR_BSTtest">RR_BSTtest</a>
% Test the Binary Search Tree (RR_BST) routines on a set of random data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTrotateLR, RR_BSTrotateL, RR_BSTrotateR, RR_BSTbalance,
% RR_BSTenumerate, RR_BSTsuccessor.

clear; n=200; c=200; for i=1:n; D(i,1)=i+randn*c; end   % c = "randomness" of initial data
[D,r]=RR_BSTinitialize(D); figure(1), clf, index=RR_BSTenumerate(D,r); plot(D(index,1),'x')

% end script RR_BSTtest                                   
