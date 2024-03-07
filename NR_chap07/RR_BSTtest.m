% script <a href="matlab:RC_BSTtest">RC_BSTtest</a>
% Test the Binary Search Tree (RC_BST) routines on a set of random data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_BSTinitialize, RC_BSTinsert, RC_BSTrotateLR, RC_BSTrotateL, RC_BSTrotateR, RC_BSTbalance,
% RC_BSTenumerate, RC_BSTsuccessor.

clear; n=200; c=200; for i=1:n; D(i,1)=i+randn*c; end   % c = "randomness" of initial data
[D,r]=RC_BSTinitialize(D); figure(1), clf, index=RC_BSTenumerate(D,r); plot(D(index,1),'x')

% end script RC_BSTtest                                   
