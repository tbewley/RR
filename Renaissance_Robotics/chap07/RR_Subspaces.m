function [C,L,R,N,Ap,r,n,m]=RR_Subspaces(A,verbose)
% function [C,L,R,N,Ap,r,n,m]=RR_Subspaces(A,verbose)
% Generates some interesting information about matrices
% The results that this script produces are helpful for understanding the Strang plot.
% INPUT:  A = a small (square or rectangular) matrix, with integer elements, to test
%         verbose = optional argument, suppress screen output if false
% OUTPUT: C,L,R,N = integer orthogonal bases for the 4 fundamental subspaces of A
%         Ap = the inverse of A (if it exists), or the pseudoinverse of A (if not)
%         r = the rank of A
%         m,n = the number of rows and columns of A
% TEST:   see RR_Subspaces_Test to test this code.  Also try, e.g., this:
%         A=[2 2 2 -3;6 1 1 -4;1 6 1 -4;1 1 6 -4]; RR_Subspaces(A);
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
      [Ap_num,fac]=rat1(Ap)
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
      [Ap_num,fac]=rat1(Ap), pause, disp(' ')

      disp('Here are some orthogonal vectors spanning the Column Space and the Left Nullspace:')
      [C,L] = QL(A)
      disp('Here are some orthogonal vectors spanning the Row Space and the Nullspace:')
      [R,N] = QL(A'), pause, disp(' ')

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
      Ap=inv(A);  C=eye(r); L=[];     R=eye(r); N=[];
   else
      Ap=pinv(A); [C,L] = QL(A);  [R,N] = QL(A');
   end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Below are some auxiliary functions used by the above code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function num=ran
% This routine is kinda stupid.  It just finds a random nonzero integer.
num=0; while num==0, num=randi([-10 10]); end
end % ran
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A,den]=rat1(A)
% function [A,den]=rat1(A)
% INPUT:  A = a matrix with real elements
% OUTPUT: A,den = A matrix with integer elements, and a positive integer, such that A/den
%                 is the same as the input matrix.

[m,n]=size(A); den=1;
for i=1:m, for j=1:n, if abs(A(i,j))>1e-10, a=A(i,j);
  [num,d]=rat(a); check=norm(a-num/d); A=A*d; den=den*d;
end, end, end
A=round(A); [g]=gcd_vec(A); A=A/g; den=den/g;
end % rat1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Q,L] = QL(A)
% Initialize Q=A, then orthogonalize its columns.
% Then, initialize L=I, and orthogonalizes its columns (against both Q and itself).
% For full version of this code, see RR/Numerical_Renaissance/chap02/RR_QDRmigs
% NOTE: All internal calculations performed using 64-bit integer arithmetic only.
% Copyright 2025 by Thomas Bewley, published under BSD 3-Clause License. 

[m,n]=size(A); Q=int64(A); % Convert to integers (all math below done on integers!)
for i=1:n                  % orthogonalize the columns of Q
  Q(:,i)=Q(:,i)/gcd_vec(Q(:,i)); f(i)=dot_product(Q(:,i),Q(:,i));
  if f(i)>0, for j=i+1:n;
    Q(:,j)=f(i)*Q(:,j)-Q(:,i)*dot_product(Q(:,i),Q(:,j));
  end, end
end
index=[1:n]; for i=1:n     % strip out the zero columns of Q
  if f(i)==0, l=length(index);
    for j=1:l, if index(j)==i
      index=index([1:j-1,j+1:l]); break
    end, end
  end  
end, Q=Q(:,index); f=f(index); r=length(index);
L=int64(eye(m)); for j=1:r % orthogonalize columns of L against Q
  for i=1:m
    L(:,i)=f(j)*L(:,i)-Q(:,j)*dot_product(Q(:,j),L(:,i));
    L(:,i)=L(:,i)/gcd_vec(L(:,i));
  end
end
for j=1:m                  % orthogonalize the columns of L
  h(j)=dot_product(L(:,j),L(:,j));
  for i=j+1:m
    L(:,i)=h(j)*L(:,i)-L(:,j)*dot_product(L(:,j),L(:,i));
    L(:,i)=L(:,i)/gcd_vec(L(:,i));
  end
end
index=[1:m]; for i=1:m     % strip out the zero columns of L
  if dot_product(L(:,i),L(:,i))==0, l=length(index);
    for j=1:l, if index(j)==i
      index=index([1:j-1,j+1:l]); break
    end, end
  end  
end, L=L(:,index);
Q=double(Q); L=double(L); % convert back to double (Matlab default)
end % function QL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p]=dot_product(u,v)
p=0; for i=1:length(u), p=p+u(i)*v(i); end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [g]=gcd_vec(u)
g=gcd(u(1),u(2)); for i=3:length(u), g=gcd(g,u(i)); end
end


