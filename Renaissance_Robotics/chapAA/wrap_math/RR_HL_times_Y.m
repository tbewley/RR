function [PH,PL,C]=RR_HL_times_Y(XH,XL,Y)
% function [PH,PL,C]=RR_HL_times_Y(XH,XL,Y)
% INPUTS:  X={XH,XL}, Y where {XH,XL,Y} are each RR_uintN (N could be 256, 512, ...)
% OUTPUTS: P=X*Y where P={PH,PL} and {PH,PL} are RR_uintN
%          C=carry part (C is RR_uintN, ignore for wrap on 2*N bit overflow)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[PL,CL]=XL*Y; [PH,CH]=XH*Y; [PH,CS]=PH+CL; C=CH+CS;
