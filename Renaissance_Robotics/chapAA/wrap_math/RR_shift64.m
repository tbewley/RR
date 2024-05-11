function s1=RR_shift64(r)
% function s1=RR_shift64(r)
% A simple intermediate (bitwise) algorithm in the xoshiro128_rev calculations
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

s1=r;
s1=bitxor(s1,bitsll(bitand(r,0x1FFFFu64),         17));
s1=bitxor(s1,bitsll(bitand(s1,0x3FFFE0000u64),    17));
s1=bitxor(s1,bitsll(bitand(s1,0x7FFFC00000000u64),17));
