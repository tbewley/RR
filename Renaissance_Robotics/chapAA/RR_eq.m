function TF=RR_eq(A,B,tol)
% function TF=RR_eq(a,b,tol)
% Perform element-by-element comparisons between matrices A and B, returning a matrix with
% elements logical 1 (TRUE) where a and b are equal, and logical 0 (FALSE) where they are not.
% A and B can be the same dimensions, or one can be a scalar.  RR_eq is thus something like
% Matlab's built-in eq command (try 'help eq'), but with two very important differences:
%   (a) RR_eq tests for equality of both numeric and symbolic (or, mixed) types, and
%   (b) For numeric elements, RR_eq allows one to set the tol below which entries are considered equal
% Note that, for symbolic elements, an exact match is required to return TRUE. 
% INPUTS:  A,B matrices of the same size (or, one may be a scalar), with symbolic and/or numeric entries
% OUTPUT:  TF  an array of logicals, of the same size as (the larger of) A and B.
% TESTS:
%     syms s1;
%     A=[s1 s1 s1 s1; round(vpa(rand(3,4)),5)]        % This just makes a couple of random matrices,
%     B=[s1 s1 s1 s1; round(vpa(rand(3,4)),5)].'      % with a few symbolic entries
%     RR_eq(A,B,0.3), RR_eq(2*A,B*2,0.3), RR_eq(A,B)  % Test for "equality", both with tol=0.3 and tol=1e-4
%     C=rand, RR_eq(A,C,0.3), RR_eq(C,A,0.3), RR_eq(A,C)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

[A_m,A_n]=size(A); [B_m,B_n]=size(B); if nargin<3, tol=1e-4; end, m=max(A_m,B_m); n=max(A_n,B_n);
if A_m*A_n*B_m*B_n>1             
   if     A_m*A_n==1, A=A*ones(m,n);   % Handle the different compatible sizes of A and B
   elseif B_m*B_n==1, B=B*ones(m,n);
   elseif A_m~=B_m | A_n~=B_n,  error('A and B must be compatible sizes')
   end
end
for i=1:m, for j=1:n
   a=A(i,j); b=B(i,j); flag=0;   % Need to be EXTRA careful here to handle both numeric and symbolic types!
   if isnumeric(a), flag=flag+1; elseif isSymType(a,'constant'), a=eval(a); flag=flag+1; end
   if isnumeric(b), flag=flag+1; elseif isSymType(b,'constant'), b=eval(b); flag=flag+1; end
   if (flag==2 & abs(a-b)<tol) | a==b, TF(i,j)=true; else, TF(i,j)=false; end
end, end
end % function RR_eq
