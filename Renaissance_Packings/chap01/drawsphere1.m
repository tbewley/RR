function drawsphere1(loc,c,r)

[X,Y,Z]=sphere(100); 
surf(loc(1)+r*X,loc(2)+r*Y,loc(3)+r*Z,ones(size(X))*c);

