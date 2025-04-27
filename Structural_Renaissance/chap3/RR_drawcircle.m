function drawcircle(loc,r,w,c)

if nargin<4; c=[0 .7 0], end

N=40;
THETA=linspace(0,2*pi,N);
RHO=ones(1,N)*r;
[X,Y] = pol2cart(THETA,RHO);
X=X+loc(1);
Y=Y+loc(2);
Z=0*X;
H=line(X,Y,Z);
set(H,'LineWidth',w);
set(H,'Color',c);