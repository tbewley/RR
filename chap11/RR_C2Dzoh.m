function [bz,az]=C2Dzoh(bs,as,h)
% function [bz,az]=C2Dzoh(bs,as,h)
% Compute (exactly) the G(z)=bz(z)/az(z) corresponding to a D/A-G(s)-A/D cascade with
% timestep h where G(s)=bs(s)/as(s).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.2.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% See also C2DTustin.  Verify with C2DzohTest.  Depends on Z, PolyDivide, PolyConv.

[bz,az]=Z(bs,[as 0],h); [div,rem]=PolyDiv(az,[1 -1]);
if abs(rem)<1e-8, az=div;         else, bz=PolyConv([1 -1],bz); end
if bz(end)==0,    bz=bz(1:end-1); else, az=[az 0];  end,  [bz,az]=RationalSimplify(bz,az);
end % function C2Dzoh
