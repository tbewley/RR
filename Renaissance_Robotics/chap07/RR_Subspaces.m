function [C,L,R,N,Ap,r,n,m]=RR_Subspaces(A,verbose)
% function [C,L,R,N,Ap,r,n,m]=RR_Subspaces(A,verbose)
% Generates some interesting information about matrices
% The results that this script produces are helpful for understanding the Strang plot.
% INPUT:  A = a small (square or rectangular) matrix, with integer elements, to test
%         verbose = optional argument, suppress screen output if false
% OUTPUT: C,L,R,N = orthogonal bases for the 4 fundamental subspaces of A
%         Ap = the inverse of A (if it exists), or the pseudoinverse of A (if not)
%         r = the rank of A
%         m,n = the number of rows and columns of A
% TEST:   see RR_Subspaces_Test to test this code.  Also try, e.g., this:
%         A=[2 2 2 -3;6 1 1 -4;1 6 1 -4;1 1 6 -4]; RR_Subspaces(A)
% NOTES:  This code uses the QR decompositions of A and A' to generate C,L,R,N.
%         This code scales Ap, and the individual columns (one at a time) of C,L,R,N,
%         so that their entries are integers, which makes them easier to look at.
%         Note that an alternative method to generate orthogonal bases of {C,L,R,N}
%         is to calculate [U,S,V] = svd(A), as described in the notes.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 7)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<2 | verbose
   disp('Let us test the following matrix:'), A
   disp('Here are the number of rows, m, and columns, n, of A:')   
   [m,n]=size(A)
   if m==n
      disp('A is square, calculating determinant:')
      d=det(A)
   else
      disp('A is not square, determinant not defined.')
   end 
   disp('Here is the rank of A:'), r=rank(A), pause, disp(' ')

   if ((m==n) & (n==r))
      disp('The inverse of A exists, here it is:'), Ap=inv(A)
      disp('Here is the inverse of A with the denominator fac conveniently pulled out:') 
      [Ap_num,fac]=RR_rat(Ap)
      disp('Here is A times the inverse of A, which should give the identity matrix:')
      test=A*Ap, pause, disp(' ')
      disp('Here are some orthogonal vectors spanning the Column Space and the Left Nullspace:')
      C=eye(r), L=[]
      disp('Here are some orthogonal vectors spanning the Row Space and the Nullspace:')
      R=eye(r), N=[], pause, disp(' ')
   else
      disp('The inverse of A does not exist!')
      disp('Instead, here is the pseudoinverse of A, denoted A^+'), Ap=pinv(A)
      disp('Here is A^+ with the denominator fac conveniently pulled out:') 
      [Ap_num,fac]=RR_rat(Ap), pause, disp(' ')

      disp('Here are some orthogonal vectors spanning the Column Space and the Left Nullspace:')
      [C,L]=QRcheck(A,r)
      disp('Here are some orthogonal vectors spanning the Row Space and the Nullspace:')
      [R,N]=QRcheck(A',r), pause, disp(' ')

      disp('here is how A and A^+ transform a randomly-generated xR')
      disp('from the row space to the column space and back');
      xR=0; for i=1:r, xR=xR+ran*R(:,i); end, xR   % First, build up a random xR
      yC=A*xR, Ap_yC=Ap*yC                         % Map from xR to yC and then back to xR
      disp('Note: xR and Ap_yC should be the same.'), pause, disp(' ') 

      if n>r
         disp('there is junk in the nullspace.  here is a randomly generated xN:')
         xN=0; for i=1:n-r, xN=xN+ran*N(:,i); end, xN 
         disp('here is how A transforms a randomly-generated xN')
         A_times_xN=A*xN, disp('Note: A should map xN to close to zero.')
      else
         disp('the nullspace only contains the zero element')
      end, pause, disp(' ')

      if m>r
         disp('there is junk in the left nullspace.  here is a randomly generated yL:')
         yL=0; for i=1:m-r, yL=yL+ran*L(:,i); end, yL
         disp('here is how Ap transforms a randomly-generated yL')
         Ap_times_yL=Ap*yL, disp('Note: Ap should map yL to close to zero.')
      else
         disp('the nullspace only contains the zero element')
      end, pause, disp(' ')
   end
else
   [m,n]=size(A); r=rank(A);
   if ((m==n) & (n==r))
      Ap=inv(A);   C=eye(r); L=[];     R=eye(r); N=[];
   else
      Ap=pinv(A); [C,L]=QRcheck(A,r); [R,N]=QRcheck(A',r);
   end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Below are some auxiliary functions that are convenient in the above code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C,L]=QRcheck(A,r)
% compute the QR decomposition of A, and rescale/rename the columns of Q
[Q,R]=qr(A); C=[]; L=[];
if sign(Q(1,1)) ~= sign(A(1,1)), Q=-Q; end  % select a natural sign for Q(1,1)
for i=1:r
   C(:,i)=RR_rat(Q(:,i));    % rescale/rename first r columns of Q
end  
for i=1:size(Q,2)-r
   L(:,i)=RR_rat(Q(:,r+i));  % rescale/rename remaining columns of Q
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function num=ran
% This routine is kinda stupid.  It just finds a random nonzero integer.
num=0; while num==0, num=randi([-10 10]); end
end