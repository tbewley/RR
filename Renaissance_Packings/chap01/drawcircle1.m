function drawcircle1(loc,r,w)

N=40;
THETA=linspace(0,2*pi,N);
RHO=ones(1,N)*r/2;
[X,Y] = pol2cart(THETA,RHO);
X=X+loc(1);
Y=Y+loc(2);
Z=0*X;
H=patch(X,Y,Z);
set(H,'LineWidth',w);
