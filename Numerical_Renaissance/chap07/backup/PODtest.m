% script POD.m                                       % Numerical Renaissance Codebase 1.0
L=2*pi; m=200; n1=30; n2=3; kmax=100; x=[0:L/(m-1):L]'; p=6; % Initialize constants
A=zeros(m,n);      % Initialize n1+n2 random vectors of length m with 1/k^2 spectra
for j=1:n1+n2      % and periodic b.c.'s.  
   for k=1:kmax    % n1 is the training set and n2 the testing set.
      c=rand-0.5; d=rand-0.5;
      for i=1:m,  A(i,j)=A(i,j)+(1/k^2)*c*sin(k*x(i))+(1/k^2)*d*cos(k*x(i));  end
   end
end
[U,S,V]=svd(A(:,1:n1));    % Calculate the POD
figure(1);  clf;   % Plot the data
for j=1:n,  plot(x,A(:,j));   axis([0 L -0.8 0.8]);   hold on;  end;  hold off;
figure(2);  clf;   % Plot the p leading POD modes
for k=1:p,  subplot(p,1,k);   plot(x,U(:,k));   axis([0 L -0.2 0.2]);  end;
figure(3);  clf;   % Compare the POD eigenvalues
semilogy(diag(S).^2,'*');
% Reconstruct some new "test" vectors with an increasing number of POD modes.
% Observe the improved representation of these vectors as more modes are included.
for which=1:n2;
   figure(3+j);  clf;   plot(x,A(:,j),'r+');  hold on;  r=zeros(m,1);
   for k=1:p;
      r=r+U(:,k)*S(k,k)*V(j,k);
      if k==1, plot(x,r,'k--');  else  plot(x,r,'-.');  end; 
   end
   plot(x,r,'k-');  axis([0 L -0.8 0.8]); 
end
% end script POD.m
