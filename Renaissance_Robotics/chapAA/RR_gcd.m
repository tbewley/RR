function [g,q,n] = RR_gcd(a,b)
% function [g,q,n] = RR_gcd(a,b)
% Solve for the greatest common divisor (GCD) of a and b via Euclid's algorithm,
% where a and b are either RR_int or RR_poly class.
% INPUTS:  a,b = input positive integers (type RR_int) or polynomials (type RR_poly), with a >= b
% OUTPUTS: g   = greatest common divisor (GCD) of a,b
%          q   = quotients generated during the running of Euclid's algorithm
%          n   = number of steps taken by Euclid's algorithm
% TESTS:   b=RR_int16(357),        a=RR_int16(385),          [g,q,n] = RR_gcd(a,b)  % Find GCF of two integers
%          b=RR_poly([1 3.7 6],1), a=RR_poly([2 3.7 6 7],1), [g,q,n] = RR_gcd(a,b)  % Find GCF of two polynomials
% NOTE 1:  We need a>=b; if this isn't true, we swap a and b.
% NOTE 2:  The conditional a>=b compares magnitudes for integers, and order for polynomials.
% NOTE 3:  For the polynomial case, g and q come out with somewhat strange overall scalaing (fixed in Bezout)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if b>a & (isa(a,'RR_poly') | a~=0), [a,b]=RR_swap(a,b); end
n=0; rm=a; r=b;

if ~isa(a,'RR_poly') & a==0, % This special case corresponds to taking a=2^N (1 greater than intmax of RR_uintN)
  rm=-b;                                        % in this special case, we compute the first step
  [quo,rem]=rm/r; n=1; q{n}=quo+1; rm=r; r=rem; % manually, with a=2^N-b (so it fits as a RR_uintN)
end
while norm(r)>1e-7
  [quo,rem]=rm/r;                     % Reduce (rm,r) to their GCF via Euclid's algorithm
  if isa(quo,'RR_poly'), quo=trim(quo); rem=trim(rem); end
  n=n+1; q{n}=quo; rm=r; r=rem;       % saving the quotients quo generated along the way.
end; n; g=rm; 
end % function RR_gcd
