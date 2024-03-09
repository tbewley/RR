function [B,G] = DiagonalizeSymmetric2x2_sqrt(A)
h = 4*A(1,2)^2+(A(1,1)-A(2,2))^2;
g = sqrt(h^2-4*h*A(1,2)^2)/(2*h);
c = [sqrt(0.5+g); sqrt(0.5+g);-sqrt(0.5+g);-sqrt(0.5+g); ...
     sqrt(0.5-g); sqrt(0.5-g);-sqrt(0.5-g);-sqrt(0.5-g)];
s = [sqrt(0.5-g);-sqrt(0.5-g); sqrt(0.5-g);-sqrt(0.5-g); ...
     sqrt(0.5+g);-sqrt(0.5+g); sqrt(0.5+g);-sqrt(0.5+g)];
for i = 1:8
    G = [c(i) s(i); -s(i) c(i)]; B = G'*A*G;
    if abs(B(2,1)) <= 1e-10, break, end
end
end % function DiagonalizeSymmetric2x2_sqrt