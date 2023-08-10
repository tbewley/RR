function F=RR_LPF_first_order(omegac)
% function F=RR_LPF_first_order(omegac)
% INPUT:   omegac=cutoff frequency of filter [OPTIONAL, taken as 1 if omitted]
% OUTPUT:  F=first order low-pass filter of type RR_tf
% TEST:    F=RR_LPF_first_order(10), close all, RR_bode(F)
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin==0, omegac=1; end, F=RR_tf(omegac,[1 omegac]);