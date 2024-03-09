function [g,q,n] = RR_IntGCF(a,b)
% function [g,q,n] = RR_IntGCF(a,b)
% Solve for the GCF of the integers a and b via Euclid's algorithm.
% INPUTS:  a,b = input integers, with |a| >= |b|
% OUTPUTS: g   = greatest common factor (GCF) of a,b
%          q   = quotients generated during the running of Euclid's algorithm
%          n   = number of steps taken by Euclid's algorithm
% TEST:    a=int32(385),  b=int32(357), [g,q,n] = RR_IntGCF(a,b)  % Apply Euclid's alorithm to find the GCF g
%          g_normalized=g/g(1)    % Note that g comes out with arbitrary scaling
% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix B)
% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if abs(b)>abs(a), disp('ERROR: Need |a|>|b|.'); return; end
n=0; rm=a; r=b; while abs(r)>1e-9
  r=r(find(r,1):end); 
  quo=idivide(rm,r); re=rem(rm,r);    % Reduce (rm,r) to their GCF via Euclid's algorithm,
  n=n+1; q{n}=quo; rm=r; r=re;        % saving the quotients quo generated along the way.
end; n; g=rm;                         % Note that g is determined up to an arbitrary multiplicative constant.
end % function RR_IntGCF