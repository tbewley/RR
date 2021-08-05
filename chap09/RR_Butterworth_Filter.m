function [num,den]=RR_Butterworth_Filter(n)
% function [num,den]=RR_Butterworth_Filter(n)
% Computes the n'th order Butterworth filter with cutoff frequency omega_c=1.
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD 3-Clause License.

p=exp(i*pi*(2*[1:n]-1+n)/(2*n)); num=1; den=Poly(p);