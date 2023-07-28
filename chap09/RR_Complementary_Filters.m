function [LPF,HPF]=RR_Complementary_Filters(omegac,n)
% function [LPF,HPF]=RR_Complementary_Filters(order)
% INPUTS:  omegac=breakpoint of filters         [optional, default=1]
%          n     =the order of the filters uses [optional, default=1]
% OUTPUT:  [LPF,HPF]=two filters that sum to one, of the prescribed order
% EXAMPLE: [LPF,HPF]=RR_Complementary_Filters(1,2), close all
%          figure(1), bode(LPF), figure(2), bode(HPF), LPF+HPF
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin<1, omegac=1, end, if nargin<2, n =1, end
t=RR_poly([1 omegac])^(2*n-1); LPF=RR_tf(t.poly(n+1:2*n),t.poly); HPF=1-LPF;