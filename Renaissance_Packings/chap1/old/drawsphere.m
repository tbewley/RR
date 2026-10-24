function drawsphere(loc,c)
[X,Y,Z]=sphere(20);  r=.5;
surf(loc(1)+r*X,loc(2)+r*Y,loc(3)+r*Z,ones(size(X))*c);
