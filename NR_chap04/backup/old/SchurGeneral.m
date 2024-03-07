function [A] = RC_SchurGeneral(A,p)
% Apply the unshifted QR algorithm p times to the square matrix A.
% After a preliminary RC_Hessenberg reduction, a series of p shifted QR steps are taken.  
% The code follows the algorithm in RC_QRGivensHessenberg, following up by applying the
% postmultiplications directly to A (thereby computing R*Q) rather than calculating Q explicitly.
% At the end of each QR step, the code checks the element in the (n,n-1) location to see whether
% or not the eigenvalue in the (n,n) location is converged.  If it is, the matrix is deflated
% and the same code applied to the smaller matrix.
n=size(A,1)
A=RC_Hessenberg(A);
for step=1:p
  mu=0;  for i=1:n; A(i,i)=A(i,i)-mu; end         % Apply the shift.
  for i=1:n-1      
     [A(i:n,i:n),c(i),s(i)] = Rotate(A(i:n,i:n),1,2);  % Calculate R and the c and s that define Q.
  end
  for i=1:n-1                                          % Calculate R*Q efficiently.
     A(:,[i i+1])=[c(i)*A(:,i)-s(i)*A(:,i+1), conj(s(i))*A(:,i)+conj(c(i))*A(:,i+1)];
  end
  for i=1:n; A(i,i)=A(i,i)+mu; end                     % Shift back.
  step, A,  pause;
  if abs(A(n,n-1)) <= 1e-10*( abs(A(n,n)) + abs(A(n-1,n-1)) )         % If (n,n) element
     if n>2; [A(1:n-1,1:n-1)] = RC_SchurGeneral(A(1:n-1,1:n-1),p); end   % converged, deflate.
     break;
  end
end
% end function RC_SchurGeneral.m 