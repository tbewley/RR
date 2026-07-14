function RR_drawsphere_octant(radius,center,quadrant)
% function RR_drawsphere_octant(radius,center,quadrant)
% INPUTS: radius = radius of sphere
%         center = vector of the (x,y,z) center of the sphere
%         quadrant = vector of signs (each of 3 entries is + or -) indicating quadrant
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 2)
%% Copyright 2026 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
N=52; [X,Y,Z]=sphere(N);
sec1 = ceil((N+1)/2);
sec2 = ceil(3*size(X,1)/4)
X_oct = quadrant(1)*radius*X(sec1:end, sec1:sec2)+center(1);
Y_oct = quadrant(2)*radius*Y(sec1:end, sec1:sec2)+center(2);
Z_oct = quadrant(3)*radius*Z(sec1:end, sec1:sec2)+center(3);
surf(X_oct, Y_oct, Z_oct,ones(size(X_oct))*0,'FaceAlpha',1);

phi = linspace(0, pi/2, N/4);
x = quadrant(1)*[0 radius * cos(phi)] + center(1);
y = quadrant(2)*[0 radius * sin(phi)] + center(2);
z = quadrant(3)*[0 0*phi]+center(3)
fill3(x,y,z,'g')

phi = linspace(0, pi/2, N/4);
x = quadrant(1)*[0 radius * cos(phi)] + center(1);
y = quadrant(2)*[0 0*phi] + center(2);
z = quadrant(3)*[0 radius * sin(phi)] + center(3)
fill3(x,y,z,'g')

phi = linspace(0, pi/2, N/4);
x = quadrant(1)*[0 0*phi] + center(1);
y = quadrant(2)*[0 radius * cos(phi)] + center(2);
z = quadrant(3)*[0 radius * sin(phi)] + center(3)
fill3(x,y,z,'g')