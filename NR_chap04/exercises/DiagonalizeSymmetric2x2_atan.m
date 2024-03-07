function [B,G] = DiagonalizeSymmetric2x2_atan(A)
theta = 0.5*atan2(-A(1,2),0.5*(A(1,1)-A(2,2)));
G = [cos(theta) sin(theta); -sin(theta) cos(theta)]; B = G'*A*G;
end % function DiagonalizeSymmetric2x2_atan