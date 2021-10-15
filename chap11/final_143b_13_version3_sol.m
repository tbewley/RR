% The Mobile Inverted Pendulum (MIP) Control Problem, solved in the Successive Loop Closure
% (SLC) framework using classical control techniques in the preferred SLC formulation
% (with theta closed on inner loop, and phi closed on outer loop), with simplified
% constants as suggested in the UCSD MAE143b S2 2013 final exam (version 1)

clear; k1=100, k2=1, z1=10
p(1)=-10; p(2)=-1; p(3)=10; p,  disp('den_G1=[s-p(1)][s-p(2)][s-p(3)]; note signs!')

% Set up plant
numG1=[k1 0]; denG1=PolyConv([1 -p(1)],[1 -p(2)],[1 -p(3)]);

h=.02; % Now transform to discrete time
[numG1z,denG1z]=C2Dzoh(numG1,denG1,h)

numG1z=numG1z(2:end)

des=[1];

[x0,y0,r,s]=Diophantine(numG1z,denG1z,des)
residual=norm(PolyAdd(PolyConv(numG1z,x0),PolyConv(denG1z,y0),-des))


% The general solution is numDz=x0+r*t, denDz=y0+s*t.  Select t to minimize order of numD:]
t=-PolyDiv(x0,r);
numDz=PolyAdd(x0,PolyConv(r,t)); numDz=numDz(find(abs(numDz)>1e-12,1):end);
denDz=PolyAdd(y0,PolyConv(s,t)); denDz=denDz(find(abs(denDz)>1e-12,1):end);
residual=norm(PolyAdd(PolyConv(numG1z,numDz),PolyConv(denG1z,denDz),-des))
