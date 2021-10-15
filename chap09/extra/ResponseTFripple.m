function ResponseTFripple(bs,as,yz,xz,h,r,g)
% function ResponseTFripple(bs,as,yz,xz,h,r,g)
% Plot the intersample ripple of a step response resulting when a CT plant G(s)=bs(s)/as(s)
% is controlled by DT controller D(z)=yz(z)/xz(z).

% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.?
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help ResponseTFrippleTest">ResponseTFrippleTest</a>.

[A,B,C,D]=TF2SS(bs,as,'Observer'); S=40; H=h/S; N=length(A); M=size(B,2); x=zeros(N,1);
AA=[A B; zeros(M,N+M)]; MM=expm(AA*H); F=MM(1:N,1:N), G=MM(1:N,N+1:N+M)

n=length(xz); m=length(yz); yz=[zeros(1,n-m) yz]/xz(1); xz=xz/xz(1);
e_taps=zeros(n,1); u_taps=zeros(n,1); i=1; K=g.T/h;
for k=1:K
  e_taps(2:n,1)=e_taps(1:n-1,1); u_taps(2:n,1)=u_taps(1:n-1,1);  % shift tap delays
  e_taps(1,1)=r-x(1,i);                                % update e taps
  u_taps(1,1)=-xz(2:n)*u_taps(2:n,1)+yz*e_taps;        % update u taps (the difference eqn)
  u(:,i:i+S)=u_taps(1,1);                             % Hold control constant
  for k=1:S, x(:,i+1)=F*x(:,i)+G*u(:,i);  i=i+1; end  % March x
end
subplot(2,1,1); plot(h*[0:K],x(1,1:S:end),'bx'), hold on, plot(H*[0:S*K],x(1,:),'b-')
subplot(2,1,2); plot(h*[0:K],u(1,1:S:end),'rx'), hold on, plot(H*[0:S*K],u(1,:),'r-')

end % function ResponseTFripple
