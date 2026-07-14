function RR_drawsphere_half(radius,center,face,direction)
% function RR_drawsphere_octant(radius,center,direction)
% INPUTS: radius = radius of sphere
%         center = vector of the (x,y,z) center of the sphere
%         direction
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 2)
%% Copyright 2026 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
N=52; [X,Y,Z]=sphere(N);
sec1 = ceil((N+1)/2); phi = linspace(0, 2*pi, N);

if face==1
  X_half = direction*radius*Z(sec1:end, :)+center(1);
  Y_half = radius*Y(sec1:end, :)+center(2);
  Z_half = radius*X(sec1:end, :)+center(3);
  x = [0*phi] + center(1);
  y = [radius * sin(phi)] + center(2);
  z = [radius * cos(phi)] + center(3)
elseif face==2
  X_half = radius*X(sec1:end, :)+center(1);
  Y_half = direction*radius*Z(sec1:end, :)+center(2);
  Z_half = radius*Y(sec1:end, :)+center(3);
  x = [radius * cos(phi)] + center(1);
  y = [0*phi] + center(2);
  z = [radius * sin(phi)] + center(3)
else
  X_half = radius*X(sec1:end, :)+center(1);
  Y_half = radius*Y(sec1:end, :)+center(2);
  Z_half = direction*radius*Z(sec1:end, :)+center(3);
  x = [radius * cos(phi)] + center(1);
  y = [radius * sin(phi)] + center(2);
  z = [0*phi]+center(3)
end
surf(X_half, Y_half, Z_half,ones(size(X_half))*0,'FaceAlpha',1);
fill3(x,y,z,'g')
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(24,10); axis off
