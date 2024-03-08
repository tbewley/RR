% script RR_fast_givens_test
% Tests RR_fast_givens_compute and RR_fast_givens on a random matrix.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap01
%% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

RR_rotate_test
disp('Now testing RR_fast_givens_compute & RR_fast_givens_apply on the same matrix.'),  d=ones(4,1);
[a,b,gamma,donothing,d([2 3])]=RR_fast_givens_compute(A(2,1),A(3,1),d(2),d(3));
[X_from_fast_givens]=RR_fast_givens_apply(A,a,b,gamma,donothing,2,3,1,4,'B'); scaling=diag(1./sqrt(d));
X_from_fast_givens_Scaled=scaling*X_from_fast_givens*scaling, disp(' ')