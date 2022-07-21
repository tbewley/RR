function [g,q,n] = RR_GCF(a,b)
% function [g,q,n] = RR_GCF(a,b)
% Solve for the GCF of polynomials a and b via Euclid's algorithm.
% INPUTS:  a,b = vectors of coefficients of input polynomials, with order(a) >= order(b)
% OUTPUTS: g   = greatest common factor (GCF) of a,b
%          q   = quotients generated during the running of Euclid's algorithm
%          n   = number of steps taken by Euclid's algorithm
% TEST:    b=RR_PolyConv([1 2 3.7],[1 4],[1 5]),  a=RR_PolyConv([1 2 3.7],[1 7],[1 8],[1 9])
%          [g,q,n] = RR_GCF(a,b)  % Apply Euclid's alorithm to find the GCF g (up to an arbitrary constant)
%          g_normalized=g/g(1)    % Note that g comes out with arbitrary scaling
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

if length(b)>length(a), disp('ERROR: Input system must be proper!!'); return; end
n=0; rm=a; r=b; while norm(r,inf)>1e-9
  r=r(find(r,1):end); [quo,rem]=RR_PolyDiv(rm,r);  % Reduce (rm,r) to their GCF via Euclid's algorithm,
  n=n+1; q{n}=quo; rm=r; r=rem;                    % saving the quotients quo generated along the way.
end; n; g=rm;                                      % Note that g is determined up to an arbitrary multiplicative constant.
end % function RR_GCF