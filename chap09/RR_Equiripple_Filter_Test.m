% script RR_Equiripple_Filter_Test
% NOTE: linear Bode plots are used here, which is nonstandard.
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

clear all, close all, omegac=10; n=8; epsilon=0.3; delta=0.04; g.omega_max=omegac*2;
% Edit the above quantities (in particular, try n=4 and n=8) to explore

disp(sprintf('Compare the n=%0.2g Butterworth, Chebyshev, Inverse Chebyshev, and elliptic filters.',n))
F1=RR_LPF_Butterworth(n,omegac);            close all, bode_linear(F1,g), pause
F2=RR_LPF_Chebyshev(n,epsilon,omegac);      figure(2), bode_linear(F2,g), pause
F3=RR_LPF_Inv_Chebyshev(n,delta,omegac);    figure(3), bode_linear(F3,g), pause
F4=RR_LPF_Elliptic(n,epsilon,delta,omegac); figure(4), bode_linear(F4,g)