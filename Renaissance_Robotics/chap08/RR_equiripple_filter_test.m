% script RR_equiripple_filter_test
% Compare the order n Butterworth, Chebyshev, Inverse Chebyshev, and elliptic filters
% NOTE: linear Bode plots are used here, which is nonstandard.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap08
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear all, close all, omegac=10; n=8; epsilon=0.3; delta=0.04; g.omega_max=omegac*2;
% Edit the above quantities (in particular, try n=4 and n=8) to explore

disp(sprintf('Compare the n=%0.2g Butterworth, Chebyshev, Inverse Chebyshev, and elliptic filters.',n))
F1=RR_LPF_butterworth(n,omegac);            close all, RR_bode_linear(F1,g), pause
F2=RR_LPF_chebyshev(n,epsilon,omegac);      figure(2), RR_bode_linear(F2,g), pause
F3=RR_LPF_inv_chebyshev(n,delta,omegac);    figure(3), RR_bode_linear(F3,g), pause
F4=RR_LPF_elliptic(n,epsilon,delta,omegac); figure(4), RR_bode_linear(F4,g)