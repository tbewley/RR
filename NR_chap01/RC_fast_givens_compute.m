function [a,b,gamma,donothing,dnew]=RC_fast_givens_compute(f,g,di,dk)
% function [a,b,gamma,donothing,dnew]=RC_fast_givens_compute(f,g,di,dk)
% Compute the parameters {a,b,gamma,donothing} of a Fast Givens transformation matrix designed to transform
% the (possibly complex) vector (f;g) to (*;0).
% INPUT:  (f;g) =vector to be rotated
% OUTPUT: (c,s) =parameters of the rotation matrix sought
% NOTE:   This code works for both real and complex (f,g).
%         In the fast Givens formulation, the scaling is applied at the very end of a series of Fast Givens
%         transforms, thus saving some flops.
% See also RC_fast_givens. Verify with RC_fast_givens_test.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap01
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

if g==0, donothing=1; else                                  % see sentence before (1.16)
  a=-f/g; b=-a*dk/di; gamma=-(real(a)*real(b)+imag(a)*imag(b)); donothing=0;
  if gamma<=1, dnew=(1+gamma)*[dk di]; else dnew=(1+1/gamma)*[di dk]; a=1/a; b=1/b; end
end
end