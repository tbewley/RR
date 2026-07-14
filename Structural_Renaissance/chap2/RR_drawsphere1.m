function drawsphere1(loc,c,r,n,alpha)
h=sqrt(8/3); s=sind(60); e=1e-8;
if nargin<1; loc=[0 0 0]; end
if nargin<2; c=0;         end
if nargin<3; r=1;         end
if nargin<4; n=20;        end
if nargin<5, alpha=1;     end
[X,Y,Z]=sphere(n); 
X=loc(1)+r*X,Y=loc(2)+r*Y,Z=loc(3)+r*Z
X1 = X; Y1 = Y; Z1 = Z;
X1(Z < 0) = NaN;
Y1(Z < 0) = NaN;
Z1(Z < 0) = NaN;
X1(Z > h) = NaN;
Y1(Z > h) = NaN;
Z1(Z > h) = NaN;
X1(Y < 0) = NaN;
Y1(Y < 0) = NaN;
Z1(Y < 0) = NaN;
X1(Y > s) = NaN;
Y1(Y > s) = NaN;
Z1(Y > s) = NaN;
X1(X/.5-Y/s < -e) = NaN;
Y1(X/.5-Y/s < -e) = NaN;
Z1(X/.5-Y/s < -e) = NaN;
X1(X/.5-Y/s > 2+e) = NaN;
Y1(X/.5-Y/s > 2+e) = NaN;
Z1(X/.5-Y/s > 2+e) = NaN;
surf(X1,Y1,Z1,ones(size(X))*c,'FaceAlpha',alpha);
