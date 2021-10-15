function [x0,y0,r,s] = Diophantine(a,b,c)
% Solve the polynomial Diophantine eqn a*x+b*y=c via the Euclidean algorithm.
% General solution is x=x0+r*t, y=y0+s*t for any polynomial t (t=0 is minimal case).

alfa=a; beta=b; rem=a;
% search for the greatest common divisor:
i=0;
n=abs(length(a)-length(b))+1;
if n == 1
n=n+1;
end
% test of zero remainder:
while norm(rem,inf) > 100*eps
i=i+1;
% elimination the zero leading coefficients:
ind=find(beta);
beta=beta(ind(1):length(beta));
% quotient and remainder:
[quot,rem]=deconv(alfa,beta);
i0=1+n-length(quot);
% storing of quotients:
qq(i,i0:n)=quot;
% shift of polynomials:
alfa=beta; beta=rem;
end
% recurrent computation of the coefficients
d=alfa; p=0; q=1; m=i-1
for i=m:-1:1
r=p; p=q
% formal rearrangement for polynomial sum executing:
rr=zeros(1,length(qq(i,:))+length(p)-1);
rr(length(rr)-length(r)+1:length(rr))=r;
% computation of further element of the sequence:
q=rr-conv(qq(i,:),p);
end
% normalization of polynomial:
ind=find(q); q=q(ind(1):length(q));
% general solution of the reduced equation:
r=-deconv(b,d); s=deconv(a,d);
x0=PolyDiv(PolyConv(p,c),d); y0=PolyDiv(PolyConv(q,c),d);  % Compute solution
