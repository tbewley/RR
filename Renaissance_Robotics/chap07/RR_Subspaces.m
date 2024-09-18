function [C,L,R,N,Ap,r,n,m]=RR_Subspaces(A)
% Generates some interesting information about matrices
% The results that this script produces are helpful for understanding the Strang plot.
% INPUT:  A=some small (square or rectangular) matrix to test
% OUTPUT: C,L,R,N=orthogonal bases for the 4 fundamental subspaces of A
%         Ap=the inverse of A (if it exists), or the pseudoinverse of A (if not)
%         r=the rank of A
%         n,m = the number of rows and columns of A
% TEST:   Run RR_Subspaces_Test to test this code
% NOTES:  This code uses the QR decompositions of A and A' to generate C,L,R,N.
%         Also, this code scales the individual columns of C,L,R,N in a convenient way, so
%         their entries are simple integers (or, pretty close to it).  That is, their
%         columns are not normalized, which makes them easier to look at.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 7)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

disp('Let us test the following matrix:'), A
disp('Here are the number of rows, n, and number of columns, m, of A:')   
[n,m]=size(A)
if n==m
   disp('A is square, calculating determinant:')
   d=det(A)
else
   disp('A is not square, determinant not defined.')
end 
disp('Here is the rank of A:'), r=rank(A), pause, disp(' ')

disp('Here are some orthogonal vectors spanning the Column Space and the Left Nullspace:')
[C,L]=QRcheck(A,r)
disp('Here are some orthogonal vectors spanning the Row Space and the Nullspace:')
[R,N]=QRcheck(A',r), pause, disp(' ')
% Note that an alternative method to generate orthogonal bases of {C,L,R,N}
% is to calculate [U,S,V] = svd(A), as described in the notes.

if ((n==m) & (n==r))
   disp('The inverse of A exists, here it is:'), Ap=inv(A)
   disp('Here is the inverse of A with the scale factor fac conveniently pulled out:') 
   fac=scale_factor(Ap),  Ap_times_fac=Ap*fac
   disp('Here is A times the inverse of A, which should give the identity matrix:')
   test=A*Ap, pause, disp(' ')
else
   disp('The inverse of A does not exist!')
   disp('Instead, here is the pseudoinverse of A, denoted A^+'), Ap=pinv(A)
   disp('Here is A^+ with the scale factor fac conveniently pulled out:') 
   fac=scale_factor(Ap), Ap_times_fac=Ap*fac, pause, disp(' ')

   disp('here is how A and A^+ transform a randomly-generated xR')
   disp('from the row space to the column space and back');
   xR=0; for i=1:r, xR=xR+ran*R(:,i); end, xR   % First, build up a random xR
   yC=A*xR, Ap_yC=Ap*yC                         % Map from xR to yC and then back to xR
   disp('Note: xR and Ap_yC should be the same.'), pause, disp(' ') 

   if m>r
      disp('there is junk in the nullspace.  here is a randomly generated xN:')
      xN=0; for i=1:m-r, xN=xN+ran*N(:,i); end, xN 
      disp('here is how A transforms a randomly-generated xN')
      A_times_xN=A*xN, disp('Note: A should map xN to close to zero.')
   else
      disp('the nullspace only contains the zero element')
   end, pause, disp(' ')

   if n>r
      disp('there is junk in the left nullspace.  here is a randomly generated yL:')
      yL=0; for i=1:n-r, yL=yL+ran*L(:,i); end, yL
      disp('here is how Ap transforms a randomly-generated yL')
      Ap_times_yL=Ap*yL, disp('Note: Ap should map yL to close to zero.')
   else
      disp('the nullspace only contains the zero element')
   end, pause, disp(' ')
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Below are some auxiliary functions that are convenient in the above code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C,L]=QRcheck(A,r)
% compute the QR decomposition of A, and rescale/rename the columns of Q
[Q,R]=qr(A); L=[];
if sign(Q(1,1)) ~= sign(A(1,1)), Q=-Q; end  % select a natural sign for Q(1,1)
for i=1:r           % rescale/rename first r columns of Q
   C(:,i)=Q(:,i);   fac=scale_factor(C(:,i)); C(:,i)=C(:,i)*fac;
end
for i=1:size(Q,2)-r % rescale/rename last r columns of Q
   L(:,i)=Q(:,r+i); fac=scale_factor(L(:,i)); L(:,i)=L(:,i)*fac;                
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function num=ran
% This routine is kinda stupid.  It just finds a random nonzero integer.
num=0; while num==0, num=randi([-10 10]); end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fac=scale_factor(X)
% This routine is kinda stupid.  It just finds a convenient scale factor.
AX=abs(X); AX=AX+100*(~(abs(X)>0.0001)); fac=1/min(AX,[],"all");
end