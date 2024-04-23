function [P,C]=RR_prod256(X,Y)
% function [P,C]=RR_prod256(X,Y)
% This code performs full uint256 by uint256 multiplication.
% INPUTS:  X, Y are each RR_uint256
% OUTPUTS: P=X*Y is RR_uint256
%          C=carry part (RR_uint256, ignore for wrap on overflow)
% TEST:
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

XH=RR_uint128(X.hi,X.m2); XL=RR_uint128(X.m1,X.lo); % intermediate math done using RR_uint128 
YH=RR_uint128(Y.hi,Y.m2); YL=RR_uint128(Y.m1,Y.lo);

[PH,PL,CL]=RR_prod256s(XH,XL,YL);   % {CL PH PL} <- {XH XL} * YL   
[P1,P2,CH]=RR_prod256s(XH,XL,YH);   % {CH P1 P2} <- {XH XL} * YH 
[CL,PH,C1]=RR_sum256(CL,PH,P1,P2);  % {C1 CL PH} <- {CL PH} + {P1 P2}
CH=RR_sum128(CH,C1);                %        CH  <- CH+C1

P=RR_uint256(PH.h,PH.l,PL.h,PL.l);
C=RR_uint256(CH.h,CH.l,CL.h,CL.l);

%             {XH XL}     This graphic summarizes how the above calculations are combined.
%           * {YH YL}     (should be self explanatory)
% -------------------
%          {CL PH PL}
%     + {CH P1 P2}
% -------------------
%       {CH CL PH PL}
