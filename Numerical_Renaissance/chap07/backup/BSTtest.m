% script <a href="matlab:RR_BSTtest">RR_BSTtest</a>
% Test the Binary Search Tree (RR_BST) routines on a set of random data.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_BSTinitialize, RR_BSTinsert, RR_BSTrotateLR, RR_BSTrotateL, RR_BSTrotateR, RR_BSTbalance,
% RR_BSTenumerate, RR_BSTsuccessor.

clear; n=200; c=2; for i=1:n; D(i,1)=i+randn*c; end   % c = "randomness" of initial data
[D,r]=RR_BSTinitialize(D); figure(1), clf, index=RR_BSTenumerate(D,r); plot(D(index,1),'x')

% end script RR_BSTtest                                   
