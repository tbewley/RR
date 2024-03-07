function w=RC_SCGrid(c,n,cin,cout,i1,i2,x,steps,z,II,JJ)
% function w=RC_SCGrid(c,n,cin,cout,i1,i2,x,steps,z,II,JJ)
% Optimize the x_i and M of the Schwartz-Christoffel transformation in order to map onto
% the specified corners c_i, then map (conformally) the specified z grid to the w plane.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% [Code was written in ForTran77 by T Bewley in 1990 at the von Karman Institute for Fluid
% Dynamics, and converted to Matlab syntax in 2012 for the Numerical Renaissance Codebase.]
% See also RC_CMGridTest.  Verify with RC_SCGridTest.

d=[c, cout]-[cin, c]; d(:)=-atan2(imag(d(:)),real(d(:))); cg(i1)=c(i1); xn(i1)=x(i1);
for i=1:n, a(i)=d(i+1)-d(i); a(i)=rem(a(i)/pi+3,2)-1; end % (-1<=a(i)<1, alpha(i)=a(i)*pi)
for iteration=1:50    % OPTIMIZE THE x_i (FOR i NOT EQUAL TO i1 OR i2) AND M 
  % step (b): compute M
  dw=0; for i=i1+1:i2, dw=dw+MarchSC(x(i-1),x(i),n,1,x,a,steps); end, M=(c(i2)-c(i1))/dw;
  % step (c): compute the c_guess
  for i=i1+1:n,    cg(i)=cg(i-1)+MarchSC(x(i-1),x(i),n,M,x,a,steps); end
  for i=i1-1:-1:1, cg(i)=cg(i+1)+MarchSC(x(i+1),x(i),n,M,x,a,steps); end
  % step (d): compute the new K
  for i=i1+1:i2,   xn(i)=xn(i-1)+Adjustx(i,1,c,cg,x); end, K=(x(i2)-x(i1))/(xn(i2)-xn(i1));
  % step (e): adjust the x
  for i=i1+1:n,    xn(i)=xn(i-1)+Adjustx(i,K,c,cg,x);   end
  for i=i1-1:-1:1, xn(i)=xn(i+1)-Adjustx(i+1,K,c,cg,x); end, x=xn;
end
for i=1:II % USING THE OPTIMIZED x_i AND M, MAP AN ORTHOGONAL GRID FROM z-PLANE TO w-PLANE
   if i==1, w(i,1)=0.0; else, w(i,1)=w(i-1,1)+MarchSC(z(i-1,1),z(i,1),n,M,x,a,steps); end
   for j=2:JJ, w(i,j)=w(i,j-1)+MarchSC(z(i,j-1),z(i,j),n,M,x,a,steps); end
end
end % function RC_SCGrid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dw=MarchSC(z1,z2,n,M,x,a,N)
dw=0; dz=(z2-z1)/N; for i=1:N, dw=dw+MarchSConestep(z1+dz*(i-1),z1+dz*i,n,M,x,a); end
end % function MarchSC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dw=MarchSConestep(za,zb,n,M,x,a)
dw=M/(zb-za)^(n-1); for i=1:n, dw=dw*((zb-x(i))^(1+a(i))-(za-x(i))^(1+a(i)))/(1+a(i)); end
end % function MarchSConestep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dx=Adjustx(i,K,c,cg,x)
dx=K*abs((c(i)-c(i-1))/(cg(i)-cg(i-1)))*(x(i)-x(i-1));
end % function Adjustx
