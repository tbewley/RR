function [Q,R]=RR_div64(B,A)
% function [Q,R]=RR_div64(B,A)          
% This code performs full uint64  by uint64  division using the nonrestoring division algorithm,
% and forms a streamlined template for RR_div128, RR_div256, RR_div512, RR_div1024.
% INPUTS:  B, A are each uint64 (or uint8,uint16,uint32,single,double) B=dividend, A=divisor
% OUTPUTS: Q and R are uint64, with Q=quotient, R=remainder, such that B=Q*A+R with 0<=R<A.
% TEST:
%   clear, clc, B=RR_randi64().v, A=RR_randi64(50).v, disp('Calculating [Q,R]=B/A')
%   [Q,R]=RR_div64(B,A), fprintf('Check: Q*A+R = %u, which should equal B\n',Q*A+R)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

Q=uint64(B);  A=uint64(A); Abar=bitcmp(A)+1; R=uint64(0);
if A>Q,       R=Q;   Q=uint64(0); return  % skip algorithm below 
elseif A>Q-A, R=Q-A; Q=uint64(1); return  % for the trivial cases
else
  for N=64:-1:1
    s=bitget(R,64); R=bitsll(R,1); R=bitset(R,1,bitget(Q,64)); Q=bitsll(Q,1);  
    if s, R=RR_sum64(R,A); else, R=RR_sum64(R,Abar); end
    if bitget(R,64), Q=bitset(Q,1,0); else, Q=bitset(Q,1,1); end
  end
  if bitget(R,64), R=RR_sum64(R,A); end
end