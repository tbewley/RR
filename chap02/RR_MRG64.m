function x=RR_MRG64(i_max)
% Multiple Recursive Generator (MRG) with period m^7-1~=2^217 where m=2^31-19
% Note: if this routine hasn't been run yet in this Matlab session, it
% initializes the 7 previous states using the RR_LCG64 algorithm.
% Constants due to L’Ecuyer, Blouin and Couture (1993).
% INPUT:  i_max (OPTIONAL) number of random numbers to return.  default=1
% OUTPUT: x
% TEST:   RR_MRG64(7)
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

persistent XOLD, if nargin<1, i_max=1; end
m=uint64(2147483629); a1=uint64(1071064); a7=uint64(2113664);
if isempty(XOLD), XOLD=RR_LCG64(7), end
for i=1:i_max, 
   x(i)=mod(a1*XOLD(1)+a7*XOLD(7),m); XOLD(2:7)=XOLD(1:6); XOLD(1)=x(i); 
end
