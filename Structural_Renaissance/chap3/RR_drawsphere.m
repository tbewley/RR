function drawsphere(loc,c,r,n,alpha)
if nargin<1; loc=[0 0 0]; end
if nargin<2; c=0;         end
if nargin<3; r=1;         end
if nargin<4; n=20;        end
if nargin<5, alpha=1;     end
[X,Y,Z]=sphere(n); 
surf(loc(1)+r*X,loc(2)+r*Y,loc(3)+r*Z,ones(size(X))*c,'FaceAlpha',alpha);
