function [x,xR]=RR_sphere_gen_orthant(N,omega,z,A,B,C,D)
% Generate and plot a quadrilateral or triangular orthant of a spherical grid.
% This routine, and its several subroutines, do all the heavy lifting for
% all of the RR_sphere_grid_* codes.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
switch z
   case 0, m1='k*'; m2='k*';
   case 1, m1='r*'; m2='k*';
   case 2, m1='k*'; m2='r*';
end   	
if nargin==7 % quadrilateral case
    x(:,1,1)=A; x(:,N+1,1)=B; x(:,N+1,N+1)=C; x(:,1,N+1)=D;
    [x,xR]=quad_orthant_compute(x,N,omega);
    quad_orthant_plot(x,xR,N,m1,m2)
    draw_quad(A,B,C,D)
else         % triangular case (nargin==6)
    x(:,1,1)=A; x(:,N+1,1)=B; x(:,1,N+1)=C; 
    [x,xR,xB]=tri_orthant_compute(x,N,omega);
    tri_orthant_plot(x,xR,xB,N,m1,m2)
    draw_tri(A,B,C)
end
end % function RR_sphere_gen_orthant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,xR,xB]=quad_orthant_compute(x,N,omega)
% Computes the gridpoints, on a unit sphere, of a quadrilateral orthant
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
if omega>0   % calculate stretching function for each side of quadrilateral
  s1=chord_division_for_uniform_arc_length(x(:,  1,  1),x(:,N+1,  1),N,omega);
  s2=chord_division_for_uniform_arc_length(x(:,  1,  1),x(:,  1,N+1),N,omega);
  s3=chord_division_for_uniform_arc_length(x(:,N+1,  1),x(:,N+1,N+1),N,omega);
  s4=chord_division_for_uniform_arc_length(x(:,  1,N+1),x(:,N+1,N+1),N,omega);  
else
  s1=[1:(N-1)]/N; s2=s1; s3=s1; s4=s1;
end
for i=2:N    % calculate points on edges of each quadrilateral
   x(:,i,1)    =s1(i-1)*x(:,N+1,  1)+(1-s1(i-1))*x(:,  1,  1);  % edge from (2,1)   to (N,1)
   x(:,1,i)    =s2(i-1)*x(:,  1,N+1)+(1-s2(i-1))*x(:,  1,  1);  % edge from (1,2)   to (1,N)
   x(:,i,N+1)  =s3(i-1)*x(:,N+1,N+1)+(1-s3(i-1))*x(:,  1,N+1);  % edge from (2,N+1) to (N,N+1)
   x(:,N+1,i)  =s4(i-1)*x(:,N+1,N+1)+(1-s4(i-1))*x(:,N+1,  1);  % edge from (N+1,2) to (N+1,N)
end
for i=2:N, for j=2:N               % calculate points on interior of quadrilateral, between edges
   x(:,i,j)=RR_line_intersection(x(:,i,1),x(:,i,N+1),x(:,1,j),x(:,N+1,j)); 
end, end
global RR_VERBOSE, if RR_VERBOSE>0,
  figure(1), clf, hold on, axis equal, axis tight             % Plot cells BEFORE the projection
  for i=1:N, for j=1:N+1
    if mod(j,2)==1, lw=3; else lw=1; end
    plot3([x(1,i,j) x(1,i+1,j)],[x(2,i,j) x(2,i+1,j)],[x(3,i,j) x(3,i+1,j)],"k-","LineWidth",lw);
  end, end
  for i=1:N+1, for j=1:N
    if mod(i,2)==1, lw=3; else lw=1; end
    plot3([x(1,i,j) x(1,i,j+1)],[x(2,i,j) x(2,i,j+1)],[x(3,i,j) x(3,i,j+1)],"k-","LineWidth",lw);
  end, end
end
for i=1:N, for j=1:N                                          % define xR 
  xR(:,i,j)=(x(:,i,j)+x(:,i+1,j)+x(:,i,j+1)+x(:,i+1,j+1))/4;  % (red if i+j=even, black if i+j=odd)
  lat=atan2d(xR(3,i,j),sqrt(xR(1,i,j)^2+xR(2,i,j)^2));        % project xR to sphere
  lon=atan2d(xR(2,i,j),xR(1,i,j));
  xR(1,i,j)=cosd(lat)*cosd(lon);
  xR(2,i,j)=cosd(lat)*sind(lon);
  xR(3,i,j)=sind(lat);
end, end
for i=1:N+1; for j=1:N+1                     
  lat=atan2d(x(3,i,j),sqrt(x(1,i,j)^2+x(2,i,j)^2));     % project x (corners of cells) to sphere
  lon=atan2d(x(2,i,j),x(1,i,j));
  x(1,i,j)=cosd(lat)*cosd(lon);
  x(2,i,j)=cosd(lat)*sind(lon);
  x(3,i,j)=sind(lat);
end, end
end % function quad_orthant_compute
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,xR,xB]=tri_orthant_compute(x,N,omega,v)
% Computes the gridpoints, on a unit sphere, of a triangular orthant
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
if omega>0 % calculate stretching function for each side of triangle
  s1=chord_division_for_uniform_arc_length(x(:,1,  1),x(:,N+1,1),N,omega);
  s2=chord_division_for_uniform_arc_length(x(:,1,  1),x(:,1,N+1),N,omega);
  s3=chord_division_for_uniform_arc_length(x(:,1,N+1),x(:,N+1,1),N,omega);
else
  s1=[1:(N-1)]/N; s2=s1; s3=s1;
end
for i=2:N  % calculate points on edges of each triangle
   x(:,i,1)    =s1(i-1)*x(:,N+1,1)+(1-s1(i-1))*x(:,1,  1);     % edge from (2,1) to (N,1)
   x(:,1,i)    =s2(i-1)*x(:,1,N+1)+(1-s2(i-1))*x(:,1,  1);     % edge from (1,2) to (1,N)
   x(:,i,N+2-i)=s3(i-1)*x(:,N+1,1)+(1-s3(i-1))*x(:,1,N+1);     % edge from (2,N) to (N,2)
end
for i=2:N, for j=2:N+2-i  % calculate points on interior of triangle, between edges
   x(:,i,j)=RR_line_intersection(x(:,i,1),x(:,i,N+2-i),x(:,1,j),x(:,N+2-j,j),x(:,i+j-1,1),x(:,1,i+j-1)); 
end, end
global RR_VERBOSE, if RR_VERBOSE>0,
  figure(1), clf, hold on, axis equal, axis tight    % Plot cells BEFORE the projection
  for i=1:N, for j=1:N+1-i                           
    if mod(j,2)==1, lw=3; else lw=1; end
    plot3([x(1,i,j) x(1,i+1,j)],[x(2,i,j) x(2,i+1,j)],[x(3,i,j) x(3,i+1,j)],"k-","LineWidth",lw);
    if mod(i,2)==1, lw=3; else lw=1; end
    plot3([x(1,i,j) x(1,i,j+1)],[x(2,i,j) x(2,i,j+1)],[x(3,i,j) x(3,i,j+1)],"k-","LineWidth",lw);
    if mod(i+j,2)==1, lw=3; else lw=1; end
    plot3([x(1,i+1,j) x(1,i,j+1)],[x(2,i+1,j) x(2,i,j+1)],[x(3,i+1,j) x(3,i,j+1)],"k-","LineWidth",lw);
  end, end
end
for i=1:N, for j=1:N+1-i   % define xR yR zR
  xR(:,i,j)=(x(:,i,j) + x(:,i+1,j) + x(:,i,j+1))/3;    % define xR (on Red points)
  lat=atan2d(xR(3,i,j),sqrt(xR(1,i,j)^2+xR(2,i,j)^2)); % project xR to sphere
  lon=atan2d(xR(2,i,j),xR(1,i,j));
  xR(1,i,j)=cosd(lat)*cosd(lon);
  xR(2,i,j)=cosd(lat)*sind(lon);
  xR(3,i,j)=sind(lat);
end, end
for i=2:N, for j=1:N+1-i   
  xB(:,i,j)=(x(:,i,j) + x(:,i-1,j+1) + x(:,i,j+1))/3;  % define xB (on Black points)
  lat=atan2d(xB(3,i,j),sqrt(xB(1,i,j)^2+xB(2,i,j)^2)); % project xB to sphere
  lon=atan2d(xB(2,i,j),xB(1,i,j));
  xB(1,i,j)=cosd(lat)*cosd(lon);
  xB(2,i,j)=cosd(lat)*sind(lon);
  xB(3,i,j)=sind(lat);
end, end
for i=1:N+1; for j=1:N+2-i                            
  lat=atan2d(x(3,i,j),sqrt(x(1,i,j)^2+x(2,i,j)^2));   % project x (corners of cells) to sphere
  lon=atan2d(x(2,i,j),x(1,i,j));
  x(1,i,j)=cosd(lat)*cosd(lon);
  x(2,i,j)=cosd(lat)*sind(lon);
  x(3,i,j)=sind(lat);
end, end
end % function tri_orthant_compute
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=chord_division_for_uniform_arc_length(a,b,N,omega)
% Compute the fractional points along along a chord for the resulting projection of the chord
% onto the unit sphere to be divided up into N equal arc lengths.
% INPUTS: a,b = 3D vectors, assumed to be on a sphere, between which lies the chord.
%         N   = number of segments that you want the projection of the chord onto the sphere
%               to be evenly divided into.
%         omega = extent of "overstretching" applied (omega=1 for normal stretching)
% OUTPUT: s   = vector of length N-1, indicating the fractional points along the chord where the
%               intermediate points should lie, at x(i)=s(i)*a+(1-s(i))*b for i=1,...,N-1
% move first point to the equator, and locate second point a distance L away on the equator
% note omega=extent of "overstretching" applied (omega=1 for normal stretching)
% note: the formula below works only for L<1/2, so it doesn't work on a tetrahedron...
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
L=omega*norm(a-b)/norm(a);
theta=2*asin(L/2); first=[1;0]; second=[cos(theta); sin(theta)]; origin=[0;0];
for i=1:N-1
   phi=i*theta/N; new=[cos(phi); sin(phi)];
   intersection=RR_line_intersection(first,second,origin,new);
   s(i)=norm(intersection-first)/L;
end
end % function chord_division_for_uniform_arc_length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function quad_orthant_plot(x,xR,N,m1,m2)
% plot a quadrilateral orthant
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
figure(2), hold on, axis equal, axis tight
for i=1:N, for j=1:N+1                              % Plot cells (corners at x)
  if mod(j,2)==1, lw=3; else lw=1; end
  plot3([x(1,i,j) x(1,i+1,j)],[x(2,i,j) x(2,i+1,j)],[x(3,i,j) x(3,i+1,j)],"k-","LineWidth",lw);
end, end
for i=1:N+1, for j=1:N                                       
  if mod(i,2)==1, lw=3; else lw=1; end
  plot3([x(1,i,j) x(1,i,j+1)],[x(2,i,j) x(2,i,j+1)],[x(3,i,j) x(3,i,j+1)],"k-","LineWidth",lw);
end, end
for i=1:N; for j=1:N                                % Plot Red points (centers at sR)
   if mod(i,2)==0 & mod(j,2)==0, lw=2; else, lw=1; end
   if mod(i+j,2)==0, m=m1; else, m=m2; end
   plot3(xR(1,i,j),xR(2,i,j),xR(3,i,j),m,"MarkerSize",10,'linewidth',lw);
end, end
end % function quad_orthant_plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tri_orthant_plot(x,xR,xB,N,m1,m2)
% plot a triangular orthant
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
figure(2), hold on, axis equal, axis tight
for i=1:N, for j=1:N+1-i                            % Plot cells (corners at x)
  if mod(j,2)==1, lw=3; else lw=1; end
  plot3([x(1,i,j) x(1,i+1,j)],[x(2,i,j) x(2,i+1,j)],[x(3,i,j) x(3,i+1,j)],"k-","LineWidth",lw);
  if mod(i,2)==1, lw=3; else lw=1; end
  plot3([x(1,i,j) x(1,i,j+1)],[x(2,i,j) x(2,i,j+1)],[x(3,i,j) x(3,i,j+1)],"k-","LineWidth",lw);
  if mod(i+j,2)==1, lw=3; else lw=1; end
  plot3([x(1,i+1,j) x(1,i,j+1)],[x(2,i+1,j) x(2,i,j+1)],[x(3,i+1,j) x(3,i,j+1)],"k-","LineWidth",lw);
end, end
for i=1:N; for j=1:N+1-i                            % Plot Red points (centers at sR)
   if mod(i,2)==0 & mod(j,2)==0, lw=2; else, lw=1; end 
   plot3(xR(1,i,j),xR(2,i,j),xR(3,i,j),m1,"MarkerSize",10,'linewidth',lw);
end, end
for i=2:N; for j=1:N+1-i                            % Plot Black points (centers at sB)
   if mod(i,2)==0 & mod(j,2)==1, lw=2; else, lw=1; end 
   plot3(xB(1,i,j),xB(2,i,j),xB(3,i,j),m2,"MarkerSize",10,'linewidth',lw);
end, end
end % function tri_orthant_plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw_quad(a,b,c,d)
% Draw a quadrilateral between points {a,b,c,d} in 3D
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
fill3([a(1),b(1),c(1),d(1)],[a(2),b(2),c(2),d(2)],[a(3),b(3),c(3),d(3)], ...
	  [.8 .8 .8],'LineWidth',3,'EdgeColor','b');
end % function draw_quad3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw_tri(a,b,c)
% Draw a triangle between points {a,b,c} in 3D
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
fill3([a(1),b(1),c(1)],[a(2),b(2),c(2)],[a(3),b(3),c(3)], ...
	  [.8 .8 .8],'LineWidth',3,'EdgeColor','b');
end % function draw_tri3