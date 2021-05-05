function [out]=sin_73(x)
% function [out]=sin_73(x)
% INPUT:  any real x
% OUTPUT: sin(x), with about 7.3 digits of precision
% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

out=cos_73(x-pi/2)
end