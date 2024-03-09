% script Example_10_12
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap10
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear; bs=[1]; as=[1 6 5]; h=.2; g.T=2;
[bz,az]=C2Dzoh(bs,as,h), m=length(bz)-1, n=length(az)-1

ell=n, s=sum(bz); yz=az/s, xz=PolyAdd([1 zeros(1,ell)],-bz/s)
g.t='Ripple-free deadbeat controller of stable plant';
figure(2), ResponseTFripple(bs,as,yz,xz,h,1,g), print -depsc RippleFreeDeadbeat.eps

numT=PolyConv(bz,yz), denT=PolyAdd(PolyConv(bz,yz),PolyConv(az,xz))
numTroots=roots(numT)
denTroots=roots(denT)
T1=PolyVal(numT,1)/PolyVal(denT,1)

% end script Example_19_12
