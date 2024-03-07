function [X] = RC_reflect(X,sig,w,i,k,p,q,which)
% function [X] = RC_reflect(X,sig,w,i,k,p,q,which)
% Apply a Householder reflection H(sig,w), embedded in rows i:k and columns i:k of an
% identiy matrix, to the matrix X, with {sig,w} as computed by RC_Reflect_Compute.m  
% INPUT:  X       = matrix to which reflection is to be applied
%         [sig,w] = parameters defining the rotation, as determined by RC_Reflect_Compute
%         [i:k]   = range of rows, and columns, of an identity matrix in which we will embed H
%         [p:q]   = range outside of which the columns (if premultiplying), and/or
%                   the rows (if postmultiplying), of X are assumed to be zero, and are
%                   thus left untouched by this Reflection algorithm.
%         which   = logical flag, implemented as follows:
%                   use which='L' to premultiply by H^H (that is, to compute H^H * X)
%                   use which='R' to postmultiply by H  (that is, to compute X * H)
%                   use which='B' to do both            (that is, to compute H^H * X * H)
% OUTPUT: X       = the modified X, as specified by which (see above)
% See also RC_reflect_compute. Verify with RC_reflect_test.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap01
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

if or(which=='L',which=='B')
  X(i:k,p:q)=X(i:k,p:q)-(conj(sig)*w)*(w'*X(i:k,p:q));  % (1.10a)
end, if or(which=='R',which=='B')                      
  X(p:q,i:k)=X(p:q,i:k)-(X(p:q,i:k)*w)*(sig*w');        % (1.10b)
end
end
