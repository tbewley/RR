function [g,q,n] = RR_gcd(a,b)
% function [g,q,n] = RR_gcd(a,b)
% Solve for the greatest common divisor (GCD) of a and b via Euclid's algorithm,
% where a and b are either RR_int or RR_poly class.
% INPUTS:  a,b = input integers (type RR_int) or polynomials (type RR_poly), with a >= b
% OUTPUTS: g   = greatest common divisor (GCD) of a,b
%          q   = quotients generated during the running of Euclid's algorithm
%          n   = number of steps taken by Euclid's algorithm
% TESTS:   b=RR_int(357),          a=RR_int(385),            [g,q,n] = RR_gcd(a,b)  % Find GCF of two integers
%          b=RR_poly([1 3.7 6],1), a=RR_poly([2 3.7 6 7],1), [g,q,n] = RR_gcd(a,b)  % Find GCF of two polynomials
% NOTE:    For the polynomial case, g and q come out with somewhat strange overall scalaing (fixed in Bezout)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

if b>a, [a,b]=RR_swap(a,b); end
n=0; rm=a; r=b; while RR_norm(r)>1e-7
  [quo,rem]=rm/r;                     % Reduce (rm,r) to their GCF via Euclid's algorithm
  if isa(quo,'RR_poly'), quo=RR_trim(quo); rem=RR_trim(rem); end
  n=n+1; q{n}=quo; rm=r; r=rem;       % saving the quotients quo generated along the way.
end; n; g=rm; 
end % function RR_gcd
