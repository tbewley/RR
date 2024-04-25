function [SH,SL,C]=RR_HL_plus_L(XH,XL,YL)
% function [SH,SL,C]=RR_HL_plus_L(XH,XL,YL)
% INPUTS:  X={XH,XL}, YL where {XH,XL,YL} are each RR_uintN (N could be 256, 512, ...)
% OUTPUTS: S=X+YL where S={SH,SL} and {SH,SL} are RR_uintN
%          C=carry bit (RR_uint128, can ignore for wrap on 2*N bit overflow)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[SL,C] = XL+YL; [SH,C] = XH+C;
