function F=RR_HPF_second_order(omegac,zeta)
% function F=RR_HPF_second_order(omegac,zeta)
% INPUTS: omegac=cutoff frequency of filter (OPTIONAL, taken as 1 if omitted)
%         zeta  =damping of filter      (OPTIONAL, taken as 0.707 if omitted)
% OUTPUT: F=second order high-pass filter of type RR_tf
% TEST:   F=RR_HPF_second_order(10,0.707), close all, RR_bode(F)
%% Renaissance Robotics codebase, Chapter 8, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin<1, omegac=1;   end
if nargin<2, zeta=sqrt(2)/2; end
F=RR_tf([1 0 0],[1 2*zeta*omegac omegac^2]);