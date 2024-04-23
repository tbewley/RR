function [S,C]=RR_sum256(X,Y)
% function [S,C]=RR_sum256(X,Y)
% INPUTS:  X and Y are each RR_uint256
% OUTPUTS: S=X+Y, where S is RR_uint256
%          C=carry bit (RR_uint256, can ignore for wrap on uint256 overflow)
% TEST: X=RR_rand256, Y=RR_rand256, [S,C]=RR_sum256(X,Y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

XH=RR_uint128(X.hi,X.m2); XL=RR_uint128(X.m1,X.lo); % intermediate math done using RR_uint128 
YH=RR_uint128(Y.hi,Y.m2); YL=RR_uint128(Y.m1,Y.lo);

[SH,SL,C1]=RR_sum256s(XH,XL,YL); [SH.h,SH.l,C2]=RR_sum128(SH.h,SH.l,YH.h,YH.l);

S=RR_uint256(SH.h,SH.l,SL.h,SL.l); C=RR_uint256(0,0,C1.h,C1.l)+RR_uint256(C2);
