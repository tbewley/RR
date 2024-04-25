function [D,R]=RR_div512(Q,M)
% function [D,R]=RR_div512(Q,M)                      
% This code performs full uint512 by uint512 division using the nonrestoring division algorithm;
% look at RR_div64 first for a more streamlined template, and RR_div8 to understand how it works.
% INPUTS:  {Q,M} are RR_uint512, with Q=dividend, M=divisor
% OUTPUTS: {D,R} are RR_uint512, with Q=D*M+R
% TEST:
%   clear, clc, Q=RR_randi512, M=RR_randi512(400)
%   [D,R]=RR_div512(Q,M), disp('Check: Y=D*M+R, res=Y-Q.  Looking for res=0, R<M.')
%   Y=D*M+R, res=Y-Q
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

D=Q; Mbar=-M; R=RR_uint512(0);
if M>D,       R=D;   D=RR_uint512(0); return  % skip this algorithm for the trivial cases 
elseif M>D-M, R=D-M; D=RR_uint512(1); return
else
  for N=512:-1:1
    s=bitget(R.hi,64); R=RR_bitsll(R,1); R.lo=bitset(R.lo,1,bitget(D.hi,64)); D=RR_bitsll(D,1);  
    if s, R=R+M;
    else, R=R+Mbar; end
    if bitget(R.hi,64), D.lo=bitset(D.lo,1,0); else, D.lo=bitset(D.lo,1,1); end
  end
  if bitget(R.hi,64), R=R+M; end
end