function [PH,PL,C]=RR_prod256s(XH,XL,YL)
% function [PH,PL,C]=RR_prod256s(XH,XL,YL)
% Note: this is a SIMPLIFIED version RR_prod256, assuming Y is zero in its upper 128 bits.
% INPUTS:  x={xh,xl}, y where {xh,xl,y} are each uint64 (or single,double)
% OUTPUTS: p=x*y where p={ph,pl} and {ph,pl} are uint64
%          c=carry part (c is uint64, ignore for wrap on uint128 overflow)
% TEST: xh=2, xl=intmax('uint64'), y=3, [ph,pl,c]=RR_prod128s(xh,xl,y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[PL,CL]=XL*YL; [PH,CH]=XH*YL; [PH,CS]=PH+CL; C=CH+CS;
