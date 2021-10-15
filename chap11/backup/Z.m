function [bz,az]=Z(bs,as,h)
% function [bz,az]=Z(bs,as,h)
% Compute the Z transform Y(z) of the signal y_k given by sampling a signal y(t), with
% Laplace transform Y(s), at regular intervals t_k = h k.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.2.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with <a href="matlab:help NRC">C2DzohTest</a>.
% Depends on <a href="matlab:help PartialFractionExpansion">PartialFractionExpansion</a>, <a href="matlab:help PolylogarithmNegativeInverse">PolylogarithmNegativeInverse</a>, <a href="matlab:help PolyAdd">PolyAdd</a>, <a href="matlab:help PolyConv">PolyConv</a>.

[a,d,k,n]=PartialFractionExpansion(bs,as); c=exp(a*h); bz=[]; az=1; azlast=1;
for i=1:n, if k(i)==1, bze=d(i)*[1 0]; azlast=az;
  else, p=k(i)-1; bze=d(i)*h^p*PolylogarithmNegativeInverse(p,c(i)); end
  bz=PolyAdd(PolyConv(bz,[1 -c(i)]),PolyConv(bze,azlast)); az=PolyConv(az,[1 -c(i)]); end
end % function Z
