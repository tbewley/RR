function rotated=RR_rotr32(x,k)
% function rotated=RR_rotr32(x,k)
% Rotates the bits of a uint32 inpiut x to the right by k, moving the remaining bits to left
% TEST: c='101100111000111100001111100000'; a=uint32(bin2dec(c));
%       disp(dec2bin(a,32)), for k=1:32, b=RR_rotr32(a,k); disp(dec2bin(b,32)), end
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

rotated=bitor(bitsrl(x,k),bitsll(x,32-k));