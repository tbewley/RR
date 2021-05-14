function b=RR_gray2bin(g)
% function b=RR_gray2bin(g)
% Converts from Gray code to binary
% INPUT:  g=Gray code number
% OUTPUT: b=corresponding binary number
% EXAMPLE CALL: d=87, b=dec2bin(d), g=RR_bin2gray(b), b1=RR_gray2bin(g)
% Renaissance Robotics codebase, Chapter 6, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD-3-Clause license.

b(1)=g(1);
for j=2:length(g)
    b(j)=num2str(xor(str2num(b(j-1)),str2num(g(j))));
end