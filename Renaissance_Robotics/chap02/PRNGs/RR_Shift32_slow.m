function s1=RR_Shift32_slow(r)
% function s=RR_Shift32_slow(r)
% A simple intermediate (bitwise) algorithm in the xoshiro128_rev calculations
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

disp('slow')
s1=r; for i=10:32
  s1=bitset(s1,i,xor(bitget(r,i),bitget(s1,i-9)));
end