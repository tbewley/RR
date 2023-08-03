function [LPF,HPF]=RR_Complementary_Filters(omegac,n)
% function [LPF,HPF]=RR_Complementary_Filters(order)
% This code generates a low-pass filter (LPF) and high-pass filter (HPF) pair that each
% roll off at a prescribed rate n in the stopband, add to 1 over all frequencies, and have
% symmetric Bode plots (that is, the HPF has a Bode plot which is a Left <-> Right
% reflection of the LPF).
% The simple n=1 case does not have does not have a resonant peak; the n=2 case seems
% useable, but the n>2 cases have increasingly large resonant peaks.  :(  It should be
% possible to develop better LPF/HPF pairs that (a) roll off in the stopband at a rate n>=2,
% (b) add to 1 over all frequencies, (c) are Left <-> Right symmetric, and
% (d) do not have resonant peaks.  (Please contact me if you have any ideas on
% how to construct them - surprisingly, the literature seems pretty sparse...)
% INPUTS:  omegac=breakpoint of filters    [optional, default=1]
%          n     =the order of the filters [optional, default=1]
% OUTPUTS: [LPF,HPF]=a matched pair of filters that sum to one and roll off at order n
% EXAMPLE: [LPF,HPF]=RR_Complementary_Filters(10,2), close all
%          figure(1), RR_bode(LPF), figure(2), RR_bode(HPF), LPF+HPF
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin<1, omegac=1, end, if nargin<2, n =1, end
t=RR_poly([1 omegac])^(2*n-1); LPF=RR_tf(t.poly(n+1:2*n),t.poly); HPF=1-LPF;
% Note: the filters constructed are of order (2*n-1), and in the stop band roll off at rate n.