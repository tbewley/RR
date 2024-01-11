function [out]=RR_sin_73(x)
% function [out]=RR_sin_73(x)
% INPUT:  any real x
% OUTPUT: sin(x), with about 7.3 digits of precision
% TEST:   x=randn, a=sin(x), b=RR_sin_73(x), residual=norm(a-b)
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

out=RR_cos_73(x-pi/2)
end