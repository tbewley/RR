function [r,y,t]=ResponseTFdt(gz,fz,type,g)
% function [r,y,t]=ResponseTFdt(gz,fz,type,g)
% Using its partial fraction expansion, compute the response Y(z)=T(z)*R(z) of a
% DT SISO linear system T(z)=gz(z)/fz(z) to an impulse (type=0), step (type=1),
% or quadratic (type=2) input.  The derived type g groups together convenient
% plotting parameters: g.T is the interval over which response is plotted,
% g.h is the timestep, and {g.styler,g.styley} are the linestyles used.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.4.3.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Depends on <a href="matlab:help PartialFractionExpansion">PartialFractionExpansion</a>, <a href="matlab:help Fac">Fac</a>, <a href="matlab:help PolylogarithmNegativeInverse">PolylogarithmNegativeInverse</a>.
% Verify with: <a href="matlab:help ResponseTFdtTest">ResponseTFdtTest</a>.

switch type, case 0, numR=1; denR=1; case 1, numR=[1 0]; denR=[1 -1]; 
             otherwise, [numR,denR]=PolylogarithmNegativeInverse(type-1,1); end
[ra,rd,rpp,rn]=PartialFractionExpansion(numR,denR);
[ya,yd,ypp,yn]=PartialFractionExpansion(PolyConv(numR,gz),PolyConv(denR,fz));
k=[0:g.T/g.h]; t=k*g.h; y=zeros(size(k)); r=zeros(size(k));
for i=1:yn, a=yd(i)/(Fac(ypp(i)-1)*ya(i)^ypp(i));
  b=a*ones(size(k)); for j=1:ypp(i)-1, b=b.*(k-j); end
  if ypp(i)>0, y(2:end)=y(2:end)+b(2:end).*ya(i).^k(2:end); else, y(1)=y(1)+yd(i); end
end, y=real(y); plot(t,y,g.styley)
for i=1:rn, a=rd(i)/(Fac(rpp(i)-1)*ra(i)^rpp(i));
  b=a*ones(size(k)); for j=1:rpp(i)-1, b=b.*(k-j); end
  if rpp(i)>0, r(2:end)=r(2:end)+b(2:end).*ra(i).^k(2:end); else, r(1)=r(1)+rd(i); end
end, r=real(r); if type>0, hold on; plot(t,r,g.styler), hold off; end
end % function ResponseTFdt
