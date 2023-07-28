function F=RR_HPF_first_order(omegac)
% function F=RR_HPF_first_order(omegac)
% INPUT:   omegac=cutoff frequency of filter [OPTIONAL, taken as 1 if omitted]
% OUTPUT:  F=first order high-pass filter of type RR_tf
% EXAMPLE: F=RR_HPF_first_order(0.1), close all, bode(F)
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin==0, omegac=1; end, F=RR_tf([1 0],[1 omegac]);