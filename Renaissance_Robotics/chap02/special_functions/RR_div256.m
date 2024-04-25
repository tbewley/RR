function [Q,R]=RR_div256(B,A)
% function [Q,R]=RR_div256(B,A)                      
% This code performs full uint256 by uint256 division using the nonrestoring division algorithm;
% look at RR_div8 first to understand how it works.
% INPUTS:  {B,A} are RR_uint256, with B=dividend, A=divisor
% OUTPUTS: {Q,R} are RR_uint256, with B=Q*A+R
% TEST:
%    clear, clc, B=RR_randi256, A=RR_randi256(200), disp('Calculating [Q,R]=B/A')
%    [Q,R]=RR_div256(B,A), disp('Check: C=Q*A+R, res=C-B.'), C=Q*A+R, res=C-B
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

Q=B; Abar=-A; R=RR_uint256(0);
if A>B,       R=Q;   Q=RR_uint256(0); return  % skip this algorithm for the trivial cases 
elseif A>B-A, R=Q-A; Q=RR_uint256(1); return
else
  for N=256:-1:1
    s=bitget(R.hi,64); R=RR_bitsll(R,1); R.lo=bitset(R.lo,1,bitget(Q.hi,64)); Q=RR_bitsll(Q,1);  
    if s, R=R+A; else, R=R+Abar; end
    if bitget(R.hi,64), Q.lo=bitset(Q.lo,1,0); else, Q.lo=bitset(Q.lo,1,1);  end
  end
  if bitget(R.hi,64), R=R+A; end
end
