function [X]=RC_fast_givens_apply(X,a,b,gamma,donothing,i,k,p,q,which)
% function [X] = RC_fast_givens_apply(X,a,b,gamma,donothing,i,k,p,q,which)
% Apply a fast Givens transform F(gamma;a,b), embedded in elements (i,k) and (k,i) of
% an identiy matrix, to the matrix X, with {gamma,a,b} as given by RC_Fast_Givens_Compute.  
% INPUT:  X     = matrix to which reflection is to be applied
%         [gamma,a,b] = parameters defining the rotation, as determined by RC_Fast_Givens_Compute
%         donothing = flag to, umm, just return X with doing nothing.
%         [i,k] = (i,k) and (k,i) are the 2 elements of F that are different than the identity matrix
%         [p:q] = range outside of which the columns (if premultiplying), and/or
%                 the rows (if postmultiplying), of X are assumed to be zero, and are
%                 thus left untouched by this Reflection algorithm.
%         which = logical flag, implemented as follows:
%                 use which='L' to premultiply by F^H (that is, to compute F^H * X)
%                 use which='R' to postmultiply by F  (that is, to compute X * F)
%                 use which='B' to do both            (that is, to compute F^H * X * F)
% OUTPUT: X     = the modified X, as specified by which (see above)
% See also RC_fast_givens_compute. Verify with RC_fast_givens_test.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap01
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

if ~donothing, if or(which=='L',which=='B')
    if gamma<=1
      X([i k],p:q)=[conj(b)*X(i,p:q)+X(k,p:q); X(i,p:q)+a*X(k,p:q)]; % (1.12a), modified
    else 
      X([i k],p:q)=[X(i,p:q)+conj(b)*X(k,p:q); a*X(i,p:q)+X(k,p:q)]; % (1.12a), modified
    end
  end, if or(which=='R',which=='B')
    if gamma<=1
      X(p:q,[i k])=[b*X(p:q,i)+X(p:q,k), X(p:q,i)+conj(a)*X(p:q,k)]; % (1.12b), modified
    else 
      X(p:q,[i k])=[X(p:q,i)+b*X(p:q,k), conj(a)*X(p:q,i)+X(p:q,k)]; % (1.12b), modified
    end
end, end
end
