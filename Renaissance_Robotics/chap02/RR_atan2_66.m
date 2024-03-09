function [out]=RR_atan2_66(b,a)
% function [out]=RR_atan2_66(b,a)
% INPUT:  any real a and b
% OUTPUT: atan(b/a), in the correct quadrants based on the signs of a and b,
% with about 6.6 digits of precision
% TEST:   a=randn, b=randn, x=atan2(b,a), y=RR_atan2_66(b,a), residual=norm(x-y)
%         (also try changing a and/or b to zero and rerunning the test!)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if     (b~=0 & a>0 ), out=sign(b)*RR_atan_66(abs(b/a));
elseif (b~=0 & a==0), out=sign(b)*pi/2;
elseif (b~=0 & a<0 ), out=sign(b)*(pi-RR_atan_66(abs(b/a)));
elseif (b==0 & a>=0), out=0;
elseif (b==0 & a<0 ), out=pi;
end