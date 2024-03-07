% script RR_reflect_test
% Tests RR_reflect_compute and RR_reflect on random real and complex matrices.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap01
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

disp('Now testing RR_Reflect_Compute & RR_Reflect on a couple of random matrices.')

A_real=randn(4)
[sig,w]=RR_reflect_compute(A_real(:,1))
[X_from_reflect]=RR_reflect(A_real,sig,w,1,4,1,4,'L'), disp(' ')

A_complex=randn(4)+sqrt(-1)*randn(4)
[sig,w]=RR_reflect_compute(A_complex(:,1))
[X_from_reflect]=RR_reflect(A_complex,sig,w,1,4,1,4,'L'), disp(' ')