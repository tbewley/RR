function s1=RR_shift64_slow(r)
% function s1=RR_shift64_slow(r)
% Equivalent to RR_shift64, but slower/simpler.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

s1=r; for i=18:64
  s1=bitset(s1,i,xor(bitget(r,i),bitget(s1,i-17)));
end