% script <a href="matlab:RC_PODtest">RC_PODtest</a>
% Test the POD algorithm on a random set of periodic training data with a given spectra.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

L=2*pi; m=200; n1=30; n2=3; n=n1+n2; kmax=100; x=[0:L/(m-1):L]'; p=6; A=zeros(m,n);  
for j=1:n, for k=1:kmax      % Initialize n vectors (n1 for training, n2 for testing)
  c=rand-0.5; d=rand-0.5;    % of length m with 1/k^2 spectra and periodic BCs .
  for i=1:m,  A(i,j)=A(i,j)+(1/k^2)*c*sin(k*x(i))+(1/k^2)*d*cos(k*x(i));  end
end, end
[U,S,V]=SVD(A(:,1:n1));      % Calculate the POD (note: the POD is simply an SVD)
figure(1), for j=1:n1, plot(x,A(:,j)), axis([0 L -0.8 0.8]), hold on, end   % Plot data
figure(2), for k=1:p, subplot(p,1,k), plot(x,U(:,k)), axis([0 L -0.2 0.2]), end 
figure(3), semilogy(diag(S).^2,'*') % Plot p leading POD modes and compare POD eigenvalues
% Now, reconstruct the n2 new "test" vectors with an increasing number of POD modes.
% Observe the improved representation of these vectors as additional modes are included.
for j=1:n2;
   figure(3+j), clf,  plot(x,A(:,j),'r+'), hold on, r=zeros(m,1); for k=1:p
     r=r+U(:,k)*S(k,k)*V(j,k); if k==1, plot(x,r,'k--'); else, plot(x,r,'-.'), end
   end, plot(x,r,'k-'), axis([0 L -0.8 0.8])
end
% end script RC_PODtest
