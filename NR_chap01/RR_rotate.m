function [X] = RR_rotate(X,c,s,i,k,p,q,which)
% function [X] = RR_rotate(X,c,s,i,k,p,q,which)
% Apply a Givens rotation G(c,s), embedded in elements (i,i) (i,k) (k,i) and (k,k)
% of an identiy matrix, to the matrix X, with {c,s} as given by RR_Rotate_Compute.  
% INPUT:  X     = matrix to which reflection is to be applied
%         [c,s] = parameters defining the rotation, as determined by RR_Reflect_Compute
%         [i,k] = (i,i) (i,k) (k,i) and (k,k) are the 4 elements of G that are different than the identity matrix
%         [p:q] = range outside of which the columns (if premultiplying), and/or
%                 the rows (if postmultiplying), of X are assumed to be zero, and are
%                 thus left untouched by this Reflection algorithm.
%         which = logical flag, implemented as follows:
%                 use which='L' to premultiply by G^H (that is, to compute G^H * X)
%                 use which='R' to postmultiply by G  (that is, to compute X * G)
%                 use which='B' to do both            (that is, to compute G^H * X * G)
% OUTPUT: X     = the modified X, as specified by which (see above)
% See also RR_rotate_compute. Trial: RR_rotate_test.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap01
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

if or(which=='L',which=='B')
  X([i k],p:q)=[conj(c)*X(i,p:q)-conj(s)*X(k,p:q); s*X(i,p:q)+c*X(k,p:q)];
end, if or(which=='R',which=='B')                        
  X(p:q,[i k])=[c*X(p:q,i)-s*X(p:q,k), conj(s)*X(p:q,i)+conj(c)*X(p:q,k)];
end
end
