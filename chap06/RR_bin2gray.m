function g=RR_bin2gray(b)
% function g=RR_bin2gray(b)
% Converts from binry to Gray code
% INPUT:  in=binary number [generate, e.g., via dec2bin(int)]
% OUTPUT: g=corresponding Gray form
% EXAMPLE CALL: for d=0:15, b=dec2bin(d); g=RR_bin2gray(b); disp({d b g}), end
% Renaissance Robotics codebase, Chapter 6, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD-3-Clause license.

g(1)=b(1);
for j=2:length(b);
    g(j)=num2str(xor(str2num(b(j-1)),str2num(b(j))));
end