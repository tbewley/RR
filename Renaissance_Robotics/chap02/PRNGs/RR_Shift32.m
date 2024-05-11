function s1=RR_shift32(r)
% function s1=RR_shift32(r)
% A simple intermediate (bitwise) algorithm in the xoshiro128_rev calculations
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

s1=r;
s1=bitxor(s1,bitsll(bitand(r, 0x1FFu32),   9));
s1=bitxor(s1,bitsll(bitand(s1,0x3FE00u32), 9));
s1=bitxor(s1,bitsll(bitand(s1,0x7C0000u32),9));
