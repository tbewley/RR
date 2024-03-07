% script Example_10_13
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap10
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

clear; bs=[1]; as=[1 -6 5]; h=.2; g.T=2;
[bz,az]=C2Dzoh(bs,as,h), m=length(bz)-1, n=length(az)-1

% ?  set up new Diophantine algorithm properly here.

ell=2*n-1, [xz,yz]=Diophantine(az,bz,[1 zeros(1,ell)]), gz=sum(PolyConv(bz,yz))
g.t='Ripple-free deadbeat controller of unstable plant';
figure(3), ResponseTFripple(bs,as,yz,xz,h,1/gz,g), print -depsc GeneralDeadbeat.eps

numT=PolyConv(bz,yz), denT=PolyAdd(PolyConv(bz,yz),PolyConv(az,xz))
numTroots=roots(numT)
denTroots=roots(denT)
T1=PolyVal(numT,1)/PolyVal(denT,1)

% end script Example_19_13
