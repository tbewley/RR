function Response(A,B,C,D,type,g)                    % Numerical Renaissance Codebase 1.0
% Using the CN method, compute the response of a single-input multiple-ouput system to a
% simple scalar input: type=0 is an impulse input, type=1 is a step, type=2 is a ramp, etc.
% If D is omitted, it is assumed to be 0.  If C is also omitted, it is assumed to be I.
n=size(A,1);  x(:,1)=zeros(n,1);  kmax=1000;  h=g.T/kmax;  t=[0:kmax]*h;
if nargin<5, C=eye(n); m=n; else, m=size(C,1); end;  if nargin<6, D=zeros(m,1); end 
switch type, case 0, u=[2/h, zeros(1,kmax)];
             case 1, u=ones(1,kmax+1);
			 otherwise, u=t.^w;  end
Ap=eye(n)+A*h/2;  Am=eye(n)-A*h/2;  B=B*h;
[x(:,2),Am] = Gauss(Am,Ap*x(:,1)+B*(u(2)+u(1))/2,n);
for k=3:kmax+1, [x(:,k)]=GaussLU(Am,Ap*x(:,k-1)+B*(u(k)+u(k-1))/2,n); end
for j=1:m,      subplot(m,1,j), plot(t,C(j,:)*x(:,[0:kmax]+1)+D(j)*u,g.linestyle), end
end % function Response.m