function b=RR_gray2bin(g)
% function b=RR_gray2bin(g)
% Converts from Gray code to binary
% INPUT:  g=Gray code number
% OUTPUT: b=corresponding binary number
% EXAMPLE CALL: d=87, b=dec2bin(d), g=RR_bin2gray(b), b1=RR_gray2bin(g)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 3)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

b(1)=g(1);
for j=1:length(g)-1
    b(j+1)=num2str(xor(str2num(b(j)),str2num(g(j+1))));
end