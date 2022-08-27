function [g,q,n] = RR_GCF(a,b)
% function [g,q,n] = RR_GCF(a,b)
% Solve for the GCF of a and b via Euclid's algorithm, where a and b are either RR_poly or RR_int class.
% INPUTS:  a,b = input polynomials of type RR_poly, with a.n >= b.n
% OUTPUTS: g   = greatest common factor (GCF) of a,b
%          q   = quotients generated during the running of Euclid's algorithm
%          n   = number of steps taken by Euclid's algorithm
% TEST OVER THE POLYNOMIALS:    
%          b=RR_poly([3.75 4 5],'roots'),  a=RR_poly([2 3.7 6 7],'roots')
%          [g,q,n] = RR_GCF(a,b)  % Apply Euclid's alorithm to find the GCF g (up to an arbitrary constant)
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

if b>a, disp('ERROR: Need a>=b!'), return, end
n=0; rm=a; r=b; while norm(r)>1e-9
  [quo,rem]=rm./r;                    % Reduce (rm,r) to their GCF via Euclid's algorithm,
  n=n+1; q{n}=quo; rm=r; r=rem;       % saving the quotients quo generated along the way.
end; n; g=rm;                         % q comes out with strange scalaing (fixed in Bezout...)
end % function RR_GCF
