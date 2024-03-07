% script RC_fast_givens_test
% Tests RC_fast_givens_compute and RC_fast_givens on a random matrix.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap01
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

RC_rotate_test
disp('Now testing RC_fast_givens_compute & RC_fast_givens_apply on the same matrix.'),  d=ones(4,1);
[a,b,gamma,donothing,d([2 3])]=RC_fast_givens_compute(A(2,1),A(3,1),d(2),d(3));
[X_from_fast_givens]=RC_fast_givens_apply(A,a,b,gamma,donothing,2,3,1,4,'B'); scaling=diag(1./sqrt(d));
X_from_fast_givens_Scaled=scaling*X_from_fast_givens*scaling, disp(' ')