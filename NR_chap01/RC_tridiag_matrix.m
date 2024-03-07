function [A]=RC_tridiag_matrix(a,b,c)
% function [A]=RC_tridiag_matrix(a,b,c)
% Construct a tridiagonal circulant matrix from the vectors {a,b,c}.
% This function is inefficient with memory, and is meant for demonstration purposes only.
% INPUTS: {a,b,c} =vectors defining the extended first subdiagonal, the main diagonal, and
%                  the extended first superdiagonal.
% OUTPUT: A       =tridiagonal circulant matrix sought.
% NOTE: If the first element of a is zero and the last element of c is set to zero,
%       the matrix generated will be tridiagonal
% TEST: n=7; a=randn(n,1); b=randn(n,1); c=randn(n,1);   % Define three random vectors
%       A_tridiagonal_circulant=RC_tridiag_matrix(a,b,c), disp(' ')
%       A_tridiagonal=RC_tridiag_matrix([0; a(2:n)], b, [c(1:n-1); 0])
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap01
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

n=length(b); A=diag(a(2:n),-1)+diag(b,0)+diag(c(1:n-1),1); A(1,n)=a(1); A(n,1)=c(n);
end
