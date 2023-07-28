function F=RR_LPF_second_order(omegac,zeta)
% function F=RR_LPF_second_order(omegac,zeta)
% INPUTS:  omegac=cutoff frequency of filter (OPTIONAL, taken as 1 if omitted)
%          zeta  =damping of filter      (OPTIONAL, taken as 0.707 if omitted)
% OUTPUT:  F=second order low-pass filter of type RR_tf
% EXAMPLE: F=RR_LPF_second_order(10,0.707), close all, bode(F)
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin<1, omegac=1;   end
if nargin<2, zeta=0.707; end
F=RR_tf(omegac^2,[1 2*zeta*omegac omegac^2]);