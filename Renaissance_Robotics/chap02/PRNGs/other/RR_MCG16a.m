function x=RR_MCG16a(i_max,reverse)
% function x=RR_MCG16a(i_max,reverse)
% Simple PRNG with an MCG with (prime) period m=2^16-15=65521.
% Note: if this routine hasn't been run yet in this Matlab session, it
% initializes the previous state using the fractional seconds of the clock.
% INPUTS: i_max   (OPTIONAL) number of random numbers to return.  default=1
%         reverse (OPTIONAL) set to true to run backward, omit to run forward
% OUTPUT: x
% TESTs:  RR_MCG16a(7), RR_MCG16a(6,true)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

persistent XOLD, if nargin<1, i_max=1; end
m=65521; if nargin<2, a=32236; else, a=17364; end
if isempty(XOLD), t=second(datetime), XOLD=round((t-floor(t))*m), end
x=mod(a*XOLD,m);
for i=2:i_max, x(i)=mod(a*x(i-1),m); end, XOLD=x(end);
