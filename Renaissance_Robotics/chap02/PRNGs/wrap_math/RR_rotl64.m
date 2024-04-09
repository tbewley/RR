function rotated=RR_rotl64(x,k)
% function rotated=RR_rotl64(x,k)
% Rotates the bits of a uint64 inpiut x to the left by k, moving the remaining bits to right
% TEST: c='10110011100011110000111110000011111100000011111110101'; a=uint64(bin2dec(c));
%       disp(dec2bin(a,64)), for k=1:64, b=RR_rotl64(a,k); disp(dec2bin(b,64)), end
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

rotated=bitor(bitsll(x,k),bitsra(x,64-k));