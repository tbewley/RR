function [bz,az]=C2DTustin(bs,as,h,omegac)
% function [bz,az]=C2DTustin(bs,as,h,omegac)
% Convert D(s)=bs(s)/as(s) to D(z)=bz(z)/as(z) using Tustin's method.  If omegac is
% specified, prewarping is applied such that this critical frequency is mapped correctly.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.4.4.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

if nargin==3, f=1; else, f=2*(1-cos(omegac*h))/(omegac*h*sin(omegac*h)); end
c=2/(f*h); m=length(bs)-1; n=length(as)-1; bz=zeros(1,n+1); az=bz;
for j=0:m; bz=bz+bs(m+1-j)*c^j*PolyConv(PolyPower([1 1],n-j),PolyPower([1 -1],j)); end
for j=0:n; az=az+as(n+1-j)*c^j*PolyConv(PolyPower([1 1],n-j),PolyPower([1 -1],j)); end
bz=bz/az(1); az=az/az(1);
end % function C2DTustin