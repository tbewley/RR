function [SH,SL,C]=RR_sum256s(XH,XL,YL)
% function [SH,SL,C]=RR_sum256s(XH,XL,YL)
% INPUTS:  X={XH,XL}, YL where {XH,XL,YL} are each RR_uint128
% OUTPUTS: S=X+YL where S={SH,SL} and {SH,SL} are RR_uint128
%          C=carry bit (RR_uint128, can ignore for wrap on uint256 overflow)
% TEST: xh=3, xl=intmax('uint64'), y=intmax('uint64'), [SH,SL,C]=RR_sum256(XH,XL,Y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[SL,C] = XL+YL; [SH,C] = XH+C;
