function [Q,D,R,r,L,Pi] = RR_QDRmigs_pivoted(A)
% function [Q,D,R,r,L,Pi] = RR_QDRmigs_pivoted(A)
% Compute a pivoted INTEGER QR decomposition, A*Pi=Q*D^(-1)*R, and rank r, of any small
% integer mxn matrix A via Modified Integer Gram-Schmidt.  Note that the integer
% matrices Q and L orthogonally span the column space and left nullspace of A.
% The pivoting pi is selected to make the entries of Q as small as possible.
% Can just as easily apply this same algorithm to A' to generate integer matrices that
% orthogonally span the row space and nullspace of A.
% INPUTS:  A = a small (possibly, rectangular) integer matrix
% OUTPUTS: Q = a integer matrix with orthogonal columns, spans column space of A
%          R = an upper-triangular integer matrix
%          D = a diagonal integer matrix            (note that A=Q*D^(-1)*R)
%          r = the rank of A
%          L = a integer matrix with orthogonal columns, spans left nullspace of A
%          pi = a vector from which the permutation matrix Pi can be generated, via
%               Pi=zeros(n); for i=1:n, Pi(pi(i),i)=1; end
% TEST: A=randi(11,5,4)-6, [Q,D,R,r,L,pi,Pi]=RR_QDRmigs_pivoted(A); Q, norm(A*Pi-Q*inv(D)*R), pause, Q'*Q, L'*L, Q'*L
% NOTE: All internal calculations performed using 64-bit integer arithmetic only.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2026 by Thomas Bewley, published under BSD 3-Clause License. 

[m,n]=size(A); T=int64(A); i=1; % Convert to 64-bit integers, initialize pi, i
% orthogonalize the n columns of Q
while i<=m
  for j=i:n
      T(:,j)=T(:,j)/RR_gcd_vec(T(:,j));   % divide each column of T by gcd of its elements
  end
  for j=1:n
      f(j)=RR_dot_product(T(:,j),T(:,j)); % calculate norm of each column of T
  end
  [f_sorted,index_sorted]=sort(f);
  index_sorted_nonzero=index_sorted(find(f_sorted));
  if sum(index_sorted_nonzero)==0, break, end
  next=index_sorted_nonzero(1);
  Q(:,i)=T(:,next);
  T(:,next)=0; pi(i)=next;
  % In an MGS fashion, now subtract off the projection of Q(j) on each remaining nonzero T(j)
  for j=1:n, if RR_dot_product(T(:,j),T(:,j))>0
     T(:,j)=RR_dot_product(Q(:,i),Q(:,i))*T(:,j)-Q(:,i)*RR_dot_product(Q(:,i),T(:,j));
  end, end
  i=i+1;
end
r=size(Q,2);
for j=1:r, Q(:,j)=Q(:,j)/RR_gcd_vec(Q(:,j));  % divide each column of Q by gcd of its elements
           f(j)=RR_dot_product(Q(:,j),Q(:,j));
end

T=int64(eye(m));  % start out with T = the mxm identity matrix
for i=1:m        % orthogonalize each column of T(:,i) against all columns Q(:,J)
  for j=1:r 
      T(:,i)=f(j)*T(:,i)-Q(:,j)*RR_dot_product(Q(:,j),T(:,i));
  end
end
% Now, find and keep (in L) the m-r columns of T with the smallest nonzero norm
j=1; while j<=m-r
   g=[]; n1=size(T,2);
   for i=1:n1
      a=RR_gcd_vec(T(:,i)); if a>0, T(:,i)=T(:,i)/a; end
      g(i)=RR_dot_product(T(:,i),T(:,i));
      if g(i)>0, for k=i+1:n1, T(:,k)=g(i)*T(:,k)-T(:,i)*RR_dot_product(T(:,i),T(:,k)); end, end
   end
   [g_sorted,index_sorted] = sort(g);
   index_sorted_nonzero=index_sorted(find(g_sorted));
   L(:,j)=T(:,index_sorted_nonzero(1));
   index_sorted_nonzero(2:end);
   T=T(:,index_sorted_nonzero(2:end));
   n1=size(T,2);
   g1=RR_dot_product(L(:,j),L(:,j));
   if g1>0, for i=1:n1-1
     T(:,i)=g1*T(:,i)-L(:,j)*RR_dot_product(L(:,j),T(:,i));
   end, end
   j=j+1;
end
Q=double(Q); if r<m, L=double(L); else, L=[]; end % convert to double (Matlab default)
next=r+1; for i=1:n, if ~ismember(i,pi), pi(next)=i; next=next+1; end, end
Pi=zeros(n,n); for i=1:n, Pi(pi(i),i)=1; end
R=Q'*A*Pi; D=Q'*Q;           % generaxte R and D
end % function RR_QDRmigs_pivoted
