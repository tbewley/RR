% script RC_reflect_test
% Tests RC_reflect_compute and RC_reflect on random real and complex matrices.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap01
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

disp('Now testing RC_Reflect_Compute & RC_Reflect on a couple of random matrices.')

A_real=randn(4)
[sig,w]=RC_reflect_compute(A_real(:,1))
[X_from_reflect]=RC_reflect(A_real,sig,w,1,4,1,4,'L'), disp(' ')

A_complex=randn(4)+sqrt(-1)*randn(4)
[sig,w]=RC_reflect_compute(A_complex(:,1))
[X_from_reflect]=RC_reflect(A_complex,sig,w,1,4,1,4,'L'), disp(' ')