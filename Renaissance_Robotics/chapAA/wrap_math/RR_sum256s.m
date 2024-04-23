function [SH,SL,C]=RR_sum256s(XH,XL,Y)
% function [SH,SL,C]=RR_sum256s(XH,XL,Y)
% INPUTS:  X={XH,XL}, Y where {XH,XL,Y} are each RR_uint128
% OUTPUTS: S=X+Y where S={SH,SL} and {SH,SL} are RR_uint128
%          C=carry bit (RR_uint128, can ignore for wrap on uint256 overflow)
% TEST: xh=3, xl=intmax('uint64'), y=intmax('uint64'), [SH,SL,C]=RR_sum256(XH,XL,Y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[SL,C] = XL+Y; [SH,C] = XH+C;
