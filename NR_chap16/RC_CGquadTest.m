% script CGquadTest                                  % Numerical Renaissance Codebase 1.0
n=2; A=randn(n); A=A'*A; b=randn(n,1); 
[x,SDres,SDxs]=SDquad(A,b); SDerr=norm(A*x-b)
[x,CGres,CGxs]=CGquad(A,b); CGerr=norm(A*x-b)
figure(1); semilogy(SDres,'b-'); hold on; semilogy(CGres,'r-'); hold off;
if n==2
  figure(2); plot(SDxs(1,:),SDxs(2,:),'b-x'); hold on; plot(CGxs(1,:),CGxs(2,:),'r-x');
  z=A\b; plot(z(1),z(2),'bo'); axis equal;
  a=axis; ah=(a(2)-a(1))/10; av=(a(4)-a(3))/10; a=[a(1)-ah a(2)+ah a(3)-av a(4)+av];
  axis(a); [X,Y] = meshgrid(a(1):(a(2)-a(1))/100:a(2), a(3):(a(4)-a(3))/100:a(4));
  J=(1/2)*(X.^2*A(1,1)+X.*Y*(A(1,2)+A(2,1))+Y.^2*A(2,2))-(b(1)*X+b(2)*Y);
  contour(X,Y,J,30); hold off;
end
